part of kan_colle_wrapper.models;

class FleetCondition extends TimerNotifier {
	final Fleet _fleet;
	List<Ship> _ships;
	bool _notificated;
	int _minCondition;

	DateTime _rejuvenateTime;
	@reflectable get rejuvenateTime => _rejuvenateTime;
	@reflectable set rejuvenateTime(value) {
	  var tmp = isRejuvenating;
    _notificated = false;
	  notifyPropertyChange(#rejuvenateTime, _rejuvenateTime, value);
    notifyPropertyChange(#isRejuvenating, tmp, isRejuvenating);
	}

	bool get isRejuvenating => rejuvenateTime != null;

	@observable Duration remaining;

	StreamController<ConditionRejuvenatedEventArgs> _rejuvenatedController;
	Stream<ConditionRejuvenatedEventArgs> rejuvenated;

	FleetCondition(Fleet this._fleet) {
	  _rejuvenatedController = new StreamController.broadcast();
	  rejuvenated = _rejuvenatedController.stream;
	}

	void update(List<Ship> ships) {
		this._ships = ships;

		if (_ships.isEmpty) {
			rejuvenateTime = null;
			return;
		}

		var sorted = _ships.map((x)=>x.condition).toList()..sort();
		var condition = sorted[0];

		if (condition != _minCondition)
		{
			_minCondition = condition;

			var rejuvnate = new DateTime.now(); // 回復完了予測時刻

			while (condition < KanColleClient.current.settings.reSortieCondition) {
			  rejuvnate = rejuvnate.add(new Duration(minutes: 3));
				condition += 3;
				if (condition > 49) condition = 49;
			}

			rejuvenateTime = rejuvnate.compareTo(new DateTime.now()) <= 0
				? null
				: rejuvnate;
		}
	}

  @override
	tick() {
		super.tick();

		if (rejuvenateTime != null && _fleet.state == FleetState.homeport)
		{
			var remaining = rejuvenateTime.subtract(new DateTime.now());
			if (remaining < Duration.ZERO) remaining = Duration.ZERO;

			this.remaining = remaining;

			if (!_notificated && rejuvenated != null && remaining <= Duration.ZERO) {
				_rejuvenatedController.add(new ConditionRejuvenatedEventArgs(_fleet.name, 0));
				_notificated = true;
			}
		} else {
			remaining = null;
		}
	}
}

