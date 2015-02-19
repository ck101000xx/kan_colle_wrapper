part of kan_colle_wrapper.homeport;

class Materials extends Observable {
  @observable int fuel;
  @observable int ammunition;
  @observable int steel;
  @observable int bauxite;
  @observable int developmentMaterials;

  int _instantRepairMaterials;

  @reflectable get instantRepairMaterials => _instantRepairMaterials;
  @reflectable get bucket => _instantRepairMaterials;
  @reflectable set instantRepairMaterials(value) {
    notifyPropertyChange(#instantRepairMaterials, _instantRepairMaterials, value);
    _instantRepairMaterials = notifyPropertyChange(#Bucket, _instantRepairMaterials, value);
  }

  @observable int instantBuildMaterials;

  Materials(KanColleProxy proxy) {
    tryParse(proxy["api_get_member_material"])
      .listen((x) => update(x.data));
    tryParse(proxy["api_req_hokyu_charge"])
      .listen((x) => update(x.data["api_material"]));
    tryParse(proxy["api_req_kousyou_destroyship"])
      .listen((x) => update(x.data["api_material"]));
  }


  void update(source) {
    if (source != null && source.Length >= 7) {
      fuel = source[0]["api_value"];
      ammunition = source[1]["api_value"];
      steel = source[2]["api_value"];
      bauxite = source[3]["api_value"];
      developmentMaterials = source[6]["api_value"];
      instantRepairMaterials = source[5]["api_value"];
      instantBuildMaterials = source[4]["api_value"];
    } else if (source != null && source.Length == 4) {
      fuel = source[0];
      ammunition = source[1];
      steel = source[2];
      bauxite = source[3];
    }
  }

}