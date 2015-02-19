part of kan_colle_wrapper.models;


class Quest extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_no"];
  int get category =>  rawData["api_category"];
  int get type =>  rawData["api_type"];
  int get state => rawData["api_state"];
  int get progress => rawData["api_progress_flag"];
  String get title => rawData["api_title"];
  String get detail => rawData["api_detail"];

  Quest(rawData) : super(rawData);

  @override
  String toString() {
    return "ID = ${id}, Category = ${category}, Title = \"${title}\", Type = ${type}, State = ${state}";
  }
}

