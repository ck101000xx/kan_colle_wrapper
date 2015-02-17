part of kan_colle_wrapper.models;

class UseItemInfo extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  String _name;
  @reflectable get name => _name;

  UseItemInfo(rawData) : super(rawData);

  @override
  _update(rawData) {
    _id = notifyPropertyChange(#id, _id, rawData["api_id"]);
    _name = notifyPropertyChange(#name, _name, rawData["api_name"]);
  }
	@override
	String toString() {
		return "ID = ${id}, Name = \"${name}\"";
	}
}

