part of kan_colle_wrapper.models;

class UseItemInfo extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_id"];
  String get name => rawData["api_name"];
  UseItemInfo(rawData) : super(rawData);
  @override
  String toString() {
    return "ID = ${id}, Name = \"${name}\"";
  }
}
