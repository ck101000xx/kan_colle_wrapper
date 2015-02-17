part of kan_colle_wrapper.models;
class ShipType extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  String _name;
  @reflectable get name => _name;

  int _sortNumber;
  @reflectable get sortNumber => _sortNumber;

  ShipType(rawData) : super(rawData);

	@override
	String toString() {
		return "ID = ${id}, Name = \"${name}\"";
	}

	@override
	_update(rawData) {
	  _id = notifyPropertyChange(#id, _id, rawData["api_id"]);
    _name = notifyPropertyChange(#name, _name, rawData["api_name"]);
    _sortNumber = notifyPropertyChange(#sortNumber, _sortNumber, rawData["api_sortno"]);

	}
	static final ShipType dummy = new ShipType({
		"api_id": 999,
		"api_sortno": 999,
		"api_name": "不審船"});
}
