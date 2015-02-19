library kan_colle_wrapper.proxy.extensions;
import "dart:async";
import "models.dart";
import "session.dart";

Stream<SvData> tryParse(Stream<Session> source) {
  return source
      .asyncMap(SvData.tryParse)
      .where((x) => x != null && x.isSuccess);
}
