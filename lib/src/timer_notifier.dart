import "dart:async";
import "package:observe/observe.dart";

class TimerNotifier extends Observable {
  static final Stream timer =
      new Stream.periodic(new Duration(seconds: 1)).asBroadcastStream();
  StreamSubscription subscriber;

  TimerNotifier() {
    this.subscriber = timer.listen((_) => tick());
  }

  void tick() {
  }

  void dispose() {
    subscriber.cancel();
  }
}
