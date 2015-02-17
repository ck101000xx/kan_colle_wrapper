part of kan_colle_wrapper.models;

class UseItem extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  String _name;
  @reflectable get name => _name;

  int _count;
  @reflectable get count => _count;

  UseItem(rawData) : super(rawData);

  @override
  _update(rawData) {
    _id = notifyPropertyChange(#id, _id, rawData["api_id"]);
    _name = notifyPropertyChange(#name, _name, rawData["api_name"]);
    _count = notifyPropertyChange(#count, _count, rawData["api_count"]);
  }
  @override String toString() {
    return "ID = ${id}, Name = \"${name}\", Count = ${count}";
  }
}
