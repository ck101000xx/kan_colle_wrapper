part of kan_colle_wrapper.models;

class ShipInfo extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  int _sortId;
  @reflectable get sortId => _sortId;

  String _name;
  @reflectable get name => _name;

  int _maxFirepower;
  @reflectable get maxFirepower => _maxFirepower;

  int _maxArmer;
  @reflectable get maxArmer => _maxArmer;

  int _maxTorpedo;
  @reflectable get maxTorpedo => _maxTorpedo;

  int _maxAA;
  @reflectable get maxAA => _maxAA;

  int _hp;
  @reflectable get hp => _hp;

  int _maxEvasion;
  @reflectable get maxEvasion => _maxEvasion;

  int _maxASW;
  @reflectable get maxASW => _maxASW;

  int _maxLOS;
  @reflectable get maxLOS => _maxLOS;

  Speed _speed;
  @reflectable get speed => _speed;

  int _nextRemodelingLevel;
  @reflectable get nextRemodelingLevel => _nextRemodelingLevel;


  ShipType _shipType;
  @reflectable ShipType get shipType {
    if (_shipType != null) return _shipType;
    if (_shipType = KanColleClient.Current.Master.ShipTypes[rawData["api_stype"]]) return _shipType;
    return ShipType.dummy;
  }

  ShipInfo(rawData) : super(rawData);

  @override String toString() {
    return "ID = ${id}, Name = \"${name}\", ShipType = \"${shipType.name}\"";
  }

  @override
  _update(rawData) {
    var get0 = (list, index) {
      var result;
      result = get(list, index);
      if (result == null) return 0;
      return result;
    };
    _id = notifyPropertyChange(#id, _id, rawData["api_id"]);

    _sortId = notifyPropertyChange(#sortId, _sortId, rawData["api_sortno"]);

    _name = notifyPropertyChange(#name, _name, rawData["api_name"]);

    _maxFirepower = notifyPropertyChange(#maxFirepower, _maxFirepower, get0(rawData["api_houg"], 1));

    _maxArmer = notifyPropertyChange(#maxArmer, _maxArmer, get0(rawData["api_souk"], 1));

    _maxTorpedo = notifyPropertyChange(#maxTorpedo, _maxTorpedo, get0(rawData["api_raig"], 1));

    _maxAA = notifyPropertyChange(#maxAA, _maxAA, get0(rawData["api_tyku"],1));

    _hp = notifyPropertyChange(#hp, _hp, get0(rawData["api_taik"], 0));

    _maxEvasion = notifyPropertyChange(#maxEvasion, _maxEvasion, get0(rawData["api_kaih"], 1));

    _maxASW = notifyPropertyChange(#maxASW, _maxASW, get0(rawData["api_tais"], 1));

    _maxLOS = notifyPropertyChange(#maxLOS, _maxLOS, get0(rawData["api_saku"],1));

    _speed = notifyPropertyChange(#speed, _speed, rawData["api_soku"]);

    _nextRemodelingLevel = notifyPropertyChange(#nextRemodelingLevel, _nextRemodelingLevel, rawData["api_afterlv"] == 0 ? null : rawData["api_afterlv"]);

  }

  static final ShipInfo dummy = new ShipInfo({
      "api_id": 0,
      "api_name": "？？？"});

}