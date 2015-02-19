part of kan_colle_wrapper.homeport;

class Organization extends Observable {
  final Homeport _homeport;

  @observable MemberTable<Ship> ships;

  @observable MemberTable<Fleet> fleets;

  @observable bool combined;

  Organization(this._homeport, KanColleProxy proxy) {

    ships = new MemberTable();
    fleets = new MemberTable();

    tryParse(proxy["api_get_member_ship"]).listen((x) => updateShips(x.data));
    tryParse(proxy["api_get_member_ship2"]).listen((x) {
      updateShips(x.data);
      updateFleets(x.fleets);
    });
    tryParse(proxy["api_get_member_ship3"]).listen((x) {
      updateShips(x.data["api_ship_data"]);
      updateFleets(x.data["api_deck_data"]);
    });

    tryParse(proxy["api_get_member_deck"]).listen((x) => updateFleets(x.data));
    tryParse(proxy["api_get_member_deck_port"]).listen((x) => updateFleets(x.data));

    tryParse(proxy["api_req_hensei_change"]).listen(change);
    tryParse(proxy["api_req_hokyu_charge"]).listen((x) => charge(x.data));
    tryParse(proxy["api_req_kaisou_powerup"]).listen(powerup);
    tryParse(proxy["api_req_kousyou_getship"]).listen((x) => getShip(x.data));
    tryParse(proxy["api_req_kousyou_destroyship"]).listen(destoryShip);
    tryParse(proxy["api_req_member_updatedeckname"]).listen(updateFleetName);

    tryParse(proxy["api_req_hensei_combined"])
      .listen((x) => combined = x.data["api_combined"] == 1);

    bool flag = false;
    tryParse(proxy["api_req_map_start"])
        ..forEach(sortie)
        ..forEach((_) => flag = true);
    proxy["api_port"]
        ..forEach((_) {
      if (flag == true) {
        flag = false;
        homing();
      }
    });
  }


  Fleet getFleet(int shipId) {
    return fleets.values.isEmpty ? null : fleets.values
        .singleWhere((x) => x.ships.any((s) => s.id == shipId));
  }



  void updateShips(List source) {
    if (source.length <= 1) {
      for (var ship in source) {
        var target = ships[ship["api_id"]];
        if (target == null) continue;
        target.update(ship);
        var fleet = getFleet(target.id);
        if (fleet != null) fleet.calculate();
      }
    } else {
      ships = new MemberTable(source.map((x) => new Ship(_homeport, x)));
    }
  }


  void updateFleets(List source) {
    if (fleets.length == source.length) {
      for (var raw in source) {
        var target = fleets[raw["api_id"]];
        if (target != null) target.update(raw);
      }
    } else {
      fleets.values.forEach((x) => x.dispose());
      fleets = new MemberTable(source.map((x) => new Fleet(_homeport, x)));
    }
  }


  void change(SvData data) {
    if (data == null || !data.isSuccess) return;
    try {
      Fleet fleet = fleets[int.parse(data.request["api_id"])];
      var index = int.parse(data.request["api_ship_idx"]);
      if (index == -1) {
        fleet.unsetAll();
        return;
      }
      Ship ship = ships[int.parse(data.request["api_ship_id"])];
      if (ship == null) {
        fleet.unset(index);
        return;
      }
      Fleet currentFleet = getFleet(ship.id);
      if (currentFleet == null)
      {
        // ship が、現状どの艦隊にも所属していないケース
        fleet.change(index, ship);
        return;
      }

      // ship が、現状いずれかの艦隊に所属しているケース
      var currentIndex = currentFleet.ships.indexOf(ship);
      var old = fleet.change(index, ship);

      // Fleet.Change(int, Ship) は、変更前の艦を返す (= old) ので、
      // ship の移動元 (currentFleet + currentIndex) に old を書き込みにいく
      currentFleet.change(currentIndex, old);
    } catch (ex) {
      print("編成の変更に失敗しました: ${ex}");
    }
  }

  void charge(source) {
    Fleet fleet = null; // 補給した艦が所属している艦隊。艦隊をまたいで補給はできないので、必ず 1 つに絞れる

    for (var ship in source["api_ship"]) {
      Ship target = ships[ship["api_id"]];
      if (target == null) continue;

      target.charge(ship["api_fuel"], ship["api_bull"], ship["api_onslot"]);

      if (fleet == null) {
        fleet = getFleet(target.id);
      }
    }

    if (fleet != null) fleet.updateStatus();
  }

  void powerup(SvData svd) {
    try {
      Ship target = ships[svd.data["api_ship"]["api_id"]];
      if (target != null) {
        target.update(svd.data["api_ship"]);
      }

      var items = svd.request["api_id_items"]
        .split(",")
        .where((String s) => s.isNotEmpty)
        .map(int.parse)
        .where((x) => ships.containsKey(x))
        .select((x) => ships[x])
        .ToList();

      // (改修に使った艦娘のこと item って呼ぶのどうなの…)

      for (var x in items) {
        _homeport.itemyard.removeFromShip(x);
        ships.remove(x);
      }

      updateFleets(svd.data["api_deck"]);
    } catch (ex) {
      print("近代化改修による更新に失敗しました: ${ex}");
    }
  }

  void getShip(source) {
    _homeport.itemyard.addFromDock(source);
    ships.add(new Ship(_homeport, source["api_ship"]));
  }

  void destoryShip(SvData svd) {
    try {
      Ship ship = ships[int.parse(svd.request["api_ship_id"])];
      if (ship != null) {
        _homeport.itemyard.removeFromShip(ship);
        ships.remove(ship);
      }
    } catch (ex) {
      print("解体による更新に失敗しました: ${ex}");
    }
  }

  void updateFleetName(SvData data) {
    if (data == null || !data.isSuccess) return;
    try {
      Fleet fleet = fleets[int.parse(data.request["api_deck_id"])];
      var name = data.request["api_name"];
      fleet.name = name;
    } catch (ex) {
      print("艦隊名の変更に失敗しました: ${ex}");
    }
  }

  void sortie(SvData data) {
    if (data == null || !data.isSuccess) return;

    try {
      var id = int.parse(data.request["api_deck_id"]);
      Fleet fleet = fleets[id];
      fleet.sortie();
      if (combined && id == 1) fleets[2].sortie();
    } catch (ex) {
      print("艦隊の出撃を検知できませんでした: ${ex}");
    }
  }

  void homing() {
    for (var target in fleets.values) {
      target.homing();
    }
  }
}