part of kan_colle_wrapper.models;

class SlotItemInfo extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  String _name;
  @reflectable get name => _name;

  SlotItemIconType _iconType;
  @reflectable get iconType => _iconType;

  int _categoryId;
  @reflectable get categoryId => _categoryId;

  int _aa;
  @reflectable get aa => _aa;

  bool _isAirSuperiorityFighter;
  bool get isAirSuperiorityFighter => _isAirSuperiorityFighter;

	SlotItemInfo(rawData) : super(rawData);

	@override
	String toString() {
		return "ID = ${id}, Name = \"${name}\", Type = {{${rawData["api_type"].join(", ")}}}";
	}

	@override
	_update(rawData) {
	  _id = notifyPropertyChange(#id, _id, rawData["api_id"]);

    _name = notifyPropertyChange(#name, _name, rawData["api_name"]);

    _iconType = notifyPropertyChange(#iconType, _iconType,
        _iconType != null ?
        _iconType :
        _iconType = rawData["api_type"].length > 3 ? rawData["api_type"][3] : 0);

    _categoryId = notifyPropertyChange(#categoryId, _categoryId,
        _categoryId != null ?
        _categoryId :
        _categoryId = rawData["api_type"].length > 2  ? rawData["api_type"][2] : double.INFINITY);

    _aa = notifyPropertyChange(#aa, _aa, rawData["api_tyku"]);

    _isAirSuperiorityFighter = notifyPropertyChange(
        #isAirSuperiorityFighter,
        _isAirSuperiorityFighter,
        ((){
          var type = rawData["api_type"].length > 2 ? rawData["api_type"][2] : null;
          return type != null && (type == 6 || type == 7 || type == 8 || type == 11);
        }()));
  }

	static final SlotItemInfo dummy = new SlotItemInfo({
	  "api_id": 0,
		"api_name": "？？？"});
}