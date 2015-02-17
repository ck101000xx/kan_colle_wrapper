part of kan_colle_wrapper.models;


class Quest extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  QuestCategory _category;
  @reflectable get category => _category;

  QuestType _type;
  @reflectable get type => _type;

  QuestState _state;
  @reflectable get state => _state;

  QuestProgress _progress;
  @reflectable get progress => _progress;

  String _title;
  @reflectable get title => _title;

  String _detail;
  @reflectable get detail => _detail;

  Quest(rawData) : super(rawData);

  @override
  _update(data) {
    _id = notifyPropertyChange(#id, _id, data["api_no"]);
    _category = notifyPropertyChange(#category, _category, data["api_category"]);
    _type = notifyPropertyChange(#type, _type, data["api_type"]);
    _state = notifyPropertyChange(#state, _state, data["api_state"]);
    _progress = notifyPropertyChange(#progress, _progress, data["api_progress_flag"]);
    _title = notifyPropertyChange(#title, _title, data["api_title"]);
    _detail = notifyPropertyChange(#detail, _detail, data["api_detail"]);
  }

  @override
  String toString() {
    return "ID = ${id}, Category = ${category}, Title = \"${title}\", Type = ${type}, State = ${state}";
  }
}

