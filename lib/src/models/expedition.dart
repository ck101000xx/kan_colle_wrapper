part of kan_colle_wrapper.models;

class Expedition extends TimerNotifier implements IIdentifiable {
  final Fleet _fleet;
  bool _notificated;

  @observable int id;

  @observable Mission mission;

	DateTime _returnTime;
  @reflectable get returnTime => _returnTime;
  @reflectable set returnTime(value) {
    _notificated = false;
    var tmp = isInExecution;
    _returnTime = notifyPropertyChange(#returnTime, _returnTime, value);
    notifyPropertyChange(#isInExecution, tmp, isInExecution);
  }

  @reflectable bool get isInExecution => returnTime != null;

	@observable Duration remaining;

  StreamController<ExpeditionReturnedEventArgs> _returnedController;
  Stream<ExpeditionReturnedEventArgs> returned;

	Expedition(this._fleet) {
	  _returnedController = new StreamController.broadcast();
	  returned = _returnedController.stream;
	}

	void update(rawData) {
		if (rawData.length != 4 || rawData.all((x) => x == 0)) {
			id = -1;
			mission = null;
			returnTime = null;
			remaining = null;
		} else {
			id = rawData[1];
			mission = KanColleClient.current.master.missions[id];
			returnTime = new DateTime.fromMillisecondsSinceEpoch(rawData[2]);
			updateCore();
		}
	}

  void updateCore() {
		if (returnTime != null) {
			var remaining = returnTime.substract(new DateTime.now());
			if (remaining < Duration.ZERO) remaining = Duration.ZERO;

			this.remaining = remaining;

			if (!_notificated &&
			    returned != null &&
			    remaining <= new Duration(seconds: KanColleClient.current.settings.notificationShorteningTime)) {
				_returnedController.add(new ExpeditionReturnedEventArgs(_fleet.name));
				_notificated = true;
			}
		} else {
			this.remaining = null;
		}
	}

	@override void tick() {
		super.tick();
		updateCore();
	}
}
