part of kan_colle_wrapper.models;

class SvData extends RawDataWrapper {
  final Map request;

  bool get isSuccess => rawData["api_result"] == 1;
  get data => rawData["api_data"];
  List<Fleet> get fleets => rawData["api_data_deck"];

  SvData(rawData, Map<String, String> this.request) : super(rawData);

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
