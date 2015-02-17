part of kan_colle_wrapper.models;

class SvData extends RawDataWrapper {
  final Map request;

  bool _isSuccess;
  @reflectable get isSuccess => _isSuccess;

  var _data;
  @reflectable get data => _data;

  List _fleets;
  @reflectable get fleets => _fleets;

  SvData(rawData, Map<String, String> this.request) : super(rawData);

  @override
  _update(rawData) {
    _isSuccess = notifyPropertyChange(#isSuccess, _isSuccess, rawData["api_result"] == 1);
    _data = notifyPropertyChange(#data, _data, rawData["api_data"]);
    _fleets = notifyPropertyChange(#fleets, _fleets, rawData["api_data_deck"]);
  }

  static Future<SvData> parse(Session session) {
    return getResponseAsJson(session)
       .then(JSON.decode)
       .then((obj) => new SvData(obj, session.request.url.queryParameters));
  }

  static Future<SvData> tryParse(Session session) {
    return SvData.parse(session).catchError((error) {
      print(error);
      return null;
    });
  }
}
