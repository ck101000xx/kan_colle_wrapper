library kan_colle_wrapper.session;
import "dart:async";
import "dart:js";


Map _parseMap(JsArray array) {
  return new Map.fromIterable(
      array.toList(),
      key: (header) => header['name'].toString(),
      value: (header) => header['value'].toString());
}

class Session<T> {
  Request request;
  Response response;
  Future<T> content;
  Session([this.request, this.response, this.content]);
  Session.fromJsObject(JsObject obj, this.content) {
    this.request = new Request.fromJsObject(obj['request']);
    this.response = new Response.fromJsObject(obj['response']);
  }
}

class Request {
  String method;
  Uri url;
  Map<String, String> headers;
  Map<String, String> cookies;
  PostData postData;
  Request();
  Request.fromJsObject(JsObject obj) {
    method = obj["method"].toString();
    url = Uri.parse(obj["url"].toString());
    headers = _parseMap(obj["headers"]);
    cookies = _parseMap(obj["cookies"]);
    postData = obj.hasProperty("postData") ?
        new PostData.fromJsObject(obj["postData"]) :
        PostData.dummy;
  }
}

class PostData {
  Map<String, String> params;
  String text;
  PostData();
  PostData.fromJsObject(JsObject obj) {
    params = _parseMap(obj["params"]);
    text = obj["text"].toString();
  }
  PostData._dummy() {
    params = new Map();
    text = "";
  }
  static final dummy = new PostData._dummy();
}

class Response {
  Map<String, String> cookies;
  Map<String, String> headers;
  Content content;
  Response();
  Response.fromJsObject(JsObject obj) {
    cookies = _parseMap(obj["cookies"]);
    headers = _parseMap(obj["headers"]);
    content = new Content.fromJsObject(obj["content"]);
  }
}

class Content {
  String mimeType;
  Content();
  Content.fromJsObject(JsObject obj) {
    mimeType = obj["mimeType"].toString();
  }
}
