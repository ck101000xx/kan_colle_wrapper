part of kan_colle_wrapper.models;

class BuildingDock extends TimerNotifier implements IIdentifiable {
  bool _notificated;

  @observable int id;

  @observable BuildingDockState state;

  @observable ShipInfo ship;

  DateTime _completeTime;
  @reflectable get completeTime => _completeTime;
  @reflectable set completeTime(value) {
    _notificated = false;
    _completeTime = notifyPropertyChange(#completeTime, _completeTime, value);
  }

  @observable Duration remaining;

  StreamController<BuildingCompletedEventArgs> _completedController;

  Stream<BuildingCompletedEventArgs> completed;

  BuildingDock(rawData) {
    _completedController = new StreamController.broadcast();
    completed = _completedController.stream;
    update(rawData);
  }

  void update(rawData) {
    id = rawData["api_id"];
    state = rawData["api_state"];
    ship =
        state == BuildingDockState.building || state == BuildingDockState.completed ?
            KanColleClient.current.master.ships[rawData["api_created_ship_id"]] :
            null;
    completeTime = state == BuildingDockState.building ?
        new DateTime.fromMillisecondsSinceEpoch(rawData["api_complete_time"]) :
        null;
  }

  void finish() {
    this.state = BuildingDockState.completed;
    this.completeTime = null;
  }


  @override
  void tick() {
    super.tick();

    if (completeTime != null) {
      var remaining = completeTime.difference(new DateTime.now());
      if (remaining < Duration.ZERO) remaining = Duration.ZERO;

      this.remaining = remaining;

      if (!_notificated && completed != null && remaining <= Duration.ZERO) {
        _completedController.add(new BuildingCompletedEventArgs(id, ship));
        _notificated = true;
      }
    } else {
      this.remaining = null;
    }
  }
}
