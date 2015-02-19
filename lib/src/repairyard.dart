part of kan_colle_wrapper.homeport;

class Repairyard extends Observable {
  final Homeport _homeport;

  @observable MemberTable<RepairingDock> docks;

  Repairyard(Homeport this._homeport, KanColleProxy proxy) {
    docks = new MemberTable();

    tryParse(proxy["api_get_member_ndock"]).listen((x) => update(x.data));
    tryParse(proxy["api_req_nyukyo_start"]).listen(start);
    tryParse(proxy["api_req_nyukyo_speedchange"]).listen(changeSpeed);
  }

  bool checkRepairing(arg) {
    if (arg is int) {
      return docks.values.where((x) => x.ship != null).any((x) => x.shipId == arg);
    }
    if (arg is Fleet) {
      var repairingShipIds = docks.values.where((x) => x.ship != null).map((x) => x.ship.id);
      return arg.ships.any((x) => repairingShipIds.any((id) => id == x.id));
    }
  }

  void update(source) {
    if (docks.length == source.length) {
      for (var raw in source) {
        var target = docks[raw["api_id"]];
        if (target != null) target.update(raw);
      }
    } else {
      docks.values.forEach((x) => x.dispose());
      docks = new MemberTable(source.map((x) => new RepairingDock(_homeport, x)));
    }
  }

  void start(SvData data) {
    try {
      //var dock = this.Docks[int.Parse(data.Request["api_ndock_id"])];
      var ship = _homeport.organization.ships[int.parse(data.request["api_ship_id"])];
      var highspeed = data.request["api_highspeed"] == "1";
      if (highspeed) {
        ship.repair();
        var fleet = _homeport.organization.getFleet(ship.id);
        if (fleet != null) fleet.updateStatus();
      }
      // 高速修復でない場合、別途 ndock が来るので、ここで何かする必要はなさげ
    } catch (ex) {
      print("入渠開始の解析に失敗しました: ${ex}");
    }
  }

  void changeSpeed(SvData data) {
    try {
      var dock = docks[int.parse(data.request["api_ndock_id"])];
      var ship = dock.ship;

      dock.finish();
      ship.repair();

      var fleet = _homeport.organization.getFleet(ship.id);
      if (fleet != null) fleet.updateStatus();
    } catch (ex) {
      print("高速修復材の解析に失敗しました: ${ex}");
    }
  }
}
