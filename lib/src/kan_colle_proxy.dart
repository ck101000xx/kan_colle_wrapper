library kan_colle_wrapper.proxy;

import "dart:async";
import "package:crypto/crypto.dart";
import "package:chrome/chrome_ext.dart" as chrome;

import "session.dart";

class KanColleProxy {
  Stream<Session> _sessionSource;
  Stream<Session> get sessionSource => _sessionSource;
  Stream<Session> _apiSessionSource;
  Stream<Session> get apiSessionSource => _apiSessionSource;

  var UpstreamProxySettings;

  bool _listening = false;

  KanColleProxy() {
    _sessionSource = chrome.devtools.network.onRequestFinished
        .where((_) => _listening)
        .map(_handleRequest)
        .asBroadcastStream();
    _apiSessionSource = _sessionSource
        .where((s) => s.request.url.pathSegments[0] == "kcsapi")
        .where((s) => s.response.content.mimeType == "text/html");
  }

  Session _handleRequest(chrome.Request request) {
    var entry = request.toJs();
    return new Session.fromJsObject(
        entry,
        request.getContent().then((result) =>
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
}
