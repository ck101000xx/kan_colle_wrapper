library kan_colle_wrapper.internal.extensions;

import "dart:async";
import "../session.dart";

Future<String> getResponseAsJson(Session session) {
  return session.content.then((string) => string.replaceFirst("svdata=", ""));
}

void safeDispose(resource) {
  if (resource != null) resource.dispose();
}

get(List list, int index) {
  return list.length > index ? list[index] : null;
}

Future whenAll(Iterable<Future> futures) {
   return Future.wait(futures);
}
