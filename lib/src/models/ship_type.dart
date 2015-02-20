part of kan_colle_wrapper.models;
class ShipType extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_id"];
  String get name => rawData["api_name"];
  int get sortNumber => rawData["api_sortno"];

  ShipType(rawData) : super(rawData);

  @override
  String toString() {
    return "ID = ${id}, Name = \"${name}\"";
  }
  static final ShipType dummy = new ShipType({
    "api_id": 999,
    "api_sortno": 999,
    "api_name": "不審船"
  });
}
