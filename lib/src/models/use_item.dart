part of kan_colle_wrapper.models;

class UseItem extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_id"];
  String get name => rawData["api_name"];
  int get count => rawData["api_count"];
  UseItem(rawData) : super(rawData);
  @override
  String toString() {
    return "ID = ${id}, Name = \"${name}\", Count = ${count}";
  }
}
