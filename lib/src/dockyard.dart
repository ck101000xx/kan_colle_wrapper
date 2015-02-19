part of kan_colle_wrapper.homeport;

class Dockyard extends Observable {
  @observable MemberTable<BuildingDock> docks;
  @observable CreatedSlotItem createdSlotItem;

  Dockyard(KanColleProxy proxy) {
    docks = new MemberTable();
    tryParse(proxy["api_get_member_kdock"]).listen((x) => update(x.data));
    tryParse(proxy["api_req_kousyou_getship"]).listen((x) => getShip(x.data));
    tryParse(proxy["api_req_kousyou_createship_speedchange"]).listen(changeSpeed);
    tryParse(proxy["api_req_kousyou_createitem"]).listen(createSlotItem);
  }


  void update(List source) {
    if (docks.length == source.length) {
      source.forEach((raw) {
        var target = docks[raw["api_id"]];
        if (target != null) target.update(raw);
      });
    } else {
      docks.values.forEach((x) => x.dispose());
      docks = new MemberTable(source.map((x) => new BuildingDock(x)));
    }
  }

  void getShip(source) {
    this.update(source["api_kdock"]);
  }

  void changeSpeed(SvData svd) {
    try {
      var dock = docks[int.parse(svd.request["api_kdock_id"])];
      var highspeed = svd.request["api_highspeed"] == "1";
      if (highspeed) dock.finish();
    } catch (ex) {
      print("高速建造材使用の解析に失敗しました: ${ex}");
    }
  }

  void createSlotItem(SvData svd) {
    createdSlotItem = new CreatedSlotItem(svd.data);
  }
}
