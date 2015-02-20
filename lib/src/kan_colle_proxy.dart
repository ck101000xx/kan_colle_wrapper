library kan_colle_wrapper.proxy;
import "dart:async";
import "package:crypto/crypto.dart";
import "package:chrome/chrome_ext.dart" as chrome;
import "session.dart";

export "session.dart";
export "kan_colle_proxy_extensions.dart";

class KanColleProxy {
  Stream<Session> _sessionSource;
  Stream<Session> get sessionSource => _sessionSource;
  Stream<Session> _apiSessionSource;
  Stream<Session> get apiSessionSource => _apiSessionSource;

  var UpstreamProxySettings;

  bool _listening = false;

  Map<String, Stream<Session>> _endpoints;

  Stream<Session> operator [](key) {
    return _endpoints[key];
  }

  KanColleProxy() {
    _sessionSource = chrome.devtools.network.onRequestFinished.where(
        (_) => _listening).map(_handleRequest).asBroadcastStream();
    _apiSessionSource = _sessionSource.where(
        (s) =>
            s.request.url.pathSegments[0] ==
                "kcsapi").where((s) => s.response.content.mimeType == "text/html");
    _endpoints = new Map.fromIterables(
        endpoints.keys,
        endpoints.values.map(
            (uri) => apiSessionSource.where((session) => session.request.url.path == uri)));
  }

  Session _handleRequest(chrome.Request request) {
    var entry = request.toJs();
    return new Session.fromJsObject(
        entry,
        request.getContent().then(
            (result) =>
                result.encoding == "base64" ?
                    CryptoUtils.base64StringToBytes(result.content) :
                    result.content));
  }

  void startup() {
    _listening = true;
  }

  void shutdown() {
    _listening = false;
  }

  static final Map<String, Uri> endpoints = new Map.fromIterable(
      [
          "/kcsapi/api_start2",
          "/kcsapi/api_port/port",
          "/kcsapi/api_get_member/basic",
          "/kcsapi/api_get_member/ship",
          "/kcsapi/api_get_member/ship2",
          "/kcsapi/api_get_member/ship3",
          "/kcsapi/api_get_member/slot_item",
          "/kcsapi/api_get_member/useitem",
          "/kcsapi/api_get_member/deck",
          "/kcsapi/api_get_member/deck_port",
          "/kcsapi/api_get_member/ndock",
          "/kcsapi/api_get_member/kdock",
          "/kcsapi/api_get_member/material",
          "/kcsapi/api_get_member/questlist",
          "/kcsapi/api_req_hensei/change",
          "/kcsapi/api_req_hokyu/charge",
          "/kcsapi/api_req_kaisou/powerup",
          "/kcsapi/api_req_kousyou/getship",
          "/kcsapi/api_req_kousyou/createitem",
          "/kcsapi/api_req_kousyou/createship",
          "/kcsapi/api_req_kousyou/createship_speedchange",
          "/kcsapi/api_req_kousyou/destroyship",
          "/kcsapi/api_req_kousyou/destroyitem2",
          "/kcsapi/api_req_nyukyo/start",
          "/kcsapi/api_req_nyukyo/speedchange",
          "/kcsapi/api_req_map/start",
          "/kcsapi/api_req_member/updatedeckname",
          "/kcsapi/api_req_member/updatecomment",
          "/kcsapi/api_req_mission/result",
          "/kcsapi/api_req_sortie/battle",
          "/kcsapi/api_req_sortie/battleresult",
          "/kcsapi/api_req_hensei/combined",
          "/kcsapi/api_req_combined_battle/battle",
          "/kcsapi/api_req_combined_battle/airbattle",
          "/kcsapi/api_req_combined_battle/battleresult",].map(Uri.parse),
      key: _endpointName);

  static _endpointName(endpoint) =>
      "api_" +
          endpoint.pathSegments.sublist(
              1).map((str) => str.replaceAll("api_", "")).toSet().join("_");

}
