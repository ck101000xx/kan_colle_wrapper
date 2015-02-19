part of kan_colle_wrapper.models;

class Fleet extends Observable implements IIdentifiable {
	final Homeport _homeport;
	bool _isInSortie;
	StreamSubscription _subscription;
	@observable int id;

	@observable String name;

	@observable List<Ship> ships;

	@observable double averageLevel;

	@observable int totalLevel;

	@observable int airSuperiorityPotential;

	@observable int totalViewRange;

	@observable int speed;

	@observable FleetState state;

	FleetCondition condition;

	Expedition expedition;

	@observable bool isReady;

	@observable bool isWounded;

	@observable bool isInShortSupply;

	@observable bool isRepairling;

	Fleet(Homeport this._homeport, rawData) {
	  ships = [];

		condition = new FleetCondition(this);
		expedition = new Expedition(this);
		update(rawData);
    _subscription = KanColleClient.current.settings.changes.listen((records) {
			records.forEach((record) {
			  if (record is PropertyChangeRecord && record.name == #viewRangeCalcLogic) {
          calculate();
        }
			});
    });
	}

	void update(rawData) {
		id = rawData["api_id"];
		name = rawData["api_name"];

		expedition.update(rawData["api_mission"]);
    updateShips(rawData["api_ship"].map((id) => _homeport.organization.ships[id]).toList());
	}

	Ship change(int index, Ship ship) {
	  var current = null;
	  if (index == -1) {
	    updateShips([ships[0]]);
	  } else if (ships.length > index) {
      current = ships[index];
      updateShips(new List.from(ships)..[index] = ship);
    } else {
      updateShips(new List.from(ships)..add(ship));
    }
	  return current;
	}

  void unset(int index) {
    updateShips(new List.from(ships)..removeAt(index));
	}

	void unsetAll() {
		updateShips([ships[0]]);
	}

  void calculate() {
		totalLevel = ships.fold(0, (prev, element) => prev + element);
		averageLevel = ships.isEmpty ? totalLevel / ships.length : 0.0;
		airSuperiorityPotential =
		    ships.fold(0, (prev, element) => prev + calcAirSuperiorityPotential(element));
		totalViewRange = calcFleetViewRange(this, KanColleClient.current.settings.viewRangeCalcLogic);
		speed = ships.every((s) => s.info.speed == Speed.fast) ? Speed.fast : Speed.low;
	}


	void sortie() {
		if (!_isInSortie) {
			_isInSortie = true;
			updateStatus();
		}
	}

  void homing() {
		if (_isInSortie) {
			_isInSortie = false;
			updateStatus();
		}
	}

  void updateStatus() {
		condition.update(ships);
		isWounded = ships.any((s) => (s.hp.current / s.hp.maximum) <= 0.25);
		isRepairling = _homeport.repairyard.checkRepairing(this);
		isInShortSupply = ships.any((s) => s.fuel.current < s.fuel.maximum || s.bull.current < s.bull.maximum);

		if (ships.isEmpty) {
			this.state = FleetState.empty;
		} else if (_isInSortie) {
			this.state = FleetState.sortie;
		} else if (expedition.isInExecution) {
			this.state = FleetState.expedition;
		} else {
			this.state = FleetState.homeport;
		}

		isReady =
		    state == FleetState.homeport &&
		    !condition.isRejuvenating &&
				!isWounded &&
			  !isRepairling &&
				!isInShortSupply;
	}


	void updateShips(ships) {
		ships = ships.where((x) => x != null);
		this.calculate();
		this.updateStatus();
	}


	@override
	String toString() {
		return "ID = ${id}, Name = \"${name}\", Ships = ${ships.map((s) => "\"${s.info.name}\"").join(",")}";
	}

	void dispose() {
	  _subscription.cancel();
		safeDispose(expedition);
		safeDispose(condition);
	}
}

