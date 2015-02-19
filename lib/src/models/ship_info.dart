part of kan_colle_wrapper.models;
_get0 (list, index) {
  var result;
  result = get(list, index);
  if (result == null) return 0;
  return result;
}
class ShipInfo extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_id"];

  int get sortId => rawData["api_sortno"];

  String get name => rawData["api_name"];

  int get maxFirepower => _get0(rawData["api_houg"], 1);

  int get maxArmer => _get0(rawData["api_souk"], 1);

  int get maxTorpedo => _get0(rawData["api_raig"], 1);

  int get maxAA => _get0(rawData["api_tyku"], 1);

  int get hp => _get0(rawData["api_taik"], 0);

  int get maxEvasion => _get0(rawData["api_kaih"], 1);

  int get maxASW => _get0(rawData["api_tais"], 1);

  int get maxLOS => _get0(rawData["api_saku"], 1);

  int get speed => rawData["api_soku"];

  int get nextRemodelingLevel =>
      rawData["api_afterlv"] == 0 ? null : rawData["api_afterlv"];


  ShipType _shipType;
  ShipType get shipType {
    if (_shipType != null) return _shipType;
    if ((_shipType =
        KanColleClient.current.master.shipTypes[rawData["api_stype"]]) != null) return _shipType;
    return ShipType.dummy;
  }

  ShipInfo(rawData) : super(rawData);

  @override String toString() {
    return "ID = ${id}, Name = \"${name}\", ShipType = \"${shipType.name}\"";
  }

  static final ShipInfo dummy = new ShipInfo({
    "api_id": 0,
    "api_name": "？？？"
  });

}
