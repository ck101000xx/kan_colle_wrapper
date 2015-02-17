part of kan_colle_wrapper.models;

class RepairingDock extends TimerNotifier implements IIdentifiable {
  Homeport _homeport;
  bool _notificated;

  @observable int id;

  @observable int state;

  @observable int shipId;

  Ship _target;

  @reflectable get ship => _target;

  @reflectable set ship(value) {
    if (_target != value) {
      if (_target != null) _target.isInRepairing = false;
      if (value != null) value.isInRepairing = true;
      _target = notifyPropertyChange(#ship, _target, value);
    }
  }

  DateTime _completeTime;

  @reflectable get completeTime => _completeTime;
  @reflectable set completeTime(value) {
    if (_completeTime != value){
      _notificated = false;
      _completeTime = notifyPropertyChange(#completeTime, _completeTime, value);
    }
  }

  @observable Duration remaining;

  StreamController<RepairingCompletedEventArgs> _completedController;
  Stream<RepairingCompletedEventArgs> completed;


  RepairingDock(this._homeport, rawData) {
    _completedController = new StreamController.broadcast();
    completed = _completedController.stream;
    update(rawData);
  }


  void update(rawData) {
    id = rawData["api_id"];
    state = rawData["api_state"];
    shipId = rawData["api_ship_id"];
    ship = state == RepairingDockState.repairing ? _homeport.organization.ships[shipId] : null;
    completeTime = state == RepairingDockState.repairing
      ? new DateTime.fromMillisecondsSinceEpoch(rawData["api_complete_time"])
      : null;
  }

  void finish() {
    state = RepairingDockState.unlocked;
    shipId = -1;
    ship = null;
    completeTime = null;
  }


  @override
  void tick() {
    super.tick();

    if (completeTime != null) {
      var remaining = completeTime.substract(new DateTime.now());
      if (remaining < Duration.ZERO) remaining = Duration.ZERO;
      this.remaining = remaining;
      if (!_notificated &&
          completed != null &&
          remaining <= new Duration(seconds: KanColleClient.Current.Settings.NotificationShorteningTime)) {
        _completedController.add(new RepairingCompletedEventArgs(id, ship));
        _notificated = true;
      }
    } else {
      this.remaining = null;
    }
  }
}
