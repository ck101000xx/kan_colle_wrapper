part of kan_colle_wrapper.models;

class Mission extends RawDataWrapper implements IIdentifiable {

  int _id;
  @reflectable get id => _id;

  String _title;
  @reflectable get title => _title;

  String _detail;
  @reflectable get detail => _detail;

	Mission(mission) : super(mission);
	@override
	_update(data) {
    _id = notifyPropertyChange(#id, _id, data["api_id"]);
    _title =notifyPropertyChange(#title, _title, data["api_name"]);
    _detail = notifyPropertyChange(#detail, _detail, data["api_details"]);;
	}
}
