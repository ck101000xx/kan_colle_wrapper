part of kan_colle_wrapper.models;

class Mission extends RawDataWrapper implements IIdentifiable {
  @observable int get id => rawData["api_id"];
  @observable String get title => rawData["api_name"];
  @observable String get detail => rawData["api_details"];

	Mission(mission) : super(mission);
}
