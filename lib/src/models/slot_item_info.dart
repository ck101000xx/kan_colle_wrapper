part of kan_colle_wrapper.models;

class SlotItemInfo extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_id"];

  String get name => rawData["api_name"];

  int _iconType;
  int get iconType => _iconType != null ? _iconType : _iconType =
      rawData["api_type"].length > 3 ? rawData["api_type"][3] : 0;

  int _categoryId;
  int get categoryId => _categoryId != null ? _categoryId : _categoryId =
      rawData["api_type"].length > 2 ? rawData["api_type"][2] : double.INFINITY;

  int get aa => rawData["api_tyku"];

  bool get isAirSuperiorityFighter {
    var type = rawData["api_type"].length > 2 ? rawData["api_type"][2] : null;
    return type != null && (type == 6 || type == 7 || type == 8 || type == 11);
  }
  SlotItemInfo(rawData) : super(rawData);

  @override
  String toString() {
    return
        "ID = ${id}, Name = \"${name}\", Type = {{${rawData["api_type"].join(", ")}}}";
  }

  static final SlotItemInfo dummy = new SlotItemInfo({
    "api_id": 0,
    "api_name": "？？？"
  });
}
