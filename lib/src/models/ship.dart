part of kan_colle_wrapper.models;

class Ship extends RawDataWrapper implements IIdentifiable {
	final Homeport _homeport;

	int _id;
  @reflectable get id => _id;

  int _sortNumber;
  @reflectable get sortNumber => _sortNumber;

  int _level;
  @reflectable get level => _level;

  bool _isLocked;
  @reflectable get isLocked => _isLocked;

  int _exp;
  @reflectable get exp => _exp;

  int _expForNextLevel;
  @reflectable get expForNextLevel => _expForNextLevel;

  int _viewRange;
  @reflectable get viewRange => _viewRange;

  bool _isMaxModernized;
  @reflectable get isMaxModernized => _isMaxModernized;

  int _condition;
  @reflectable get condition => _condition;

  ConditionType _conditionType;
  @reflectable get conditionType => _conditionType;

  int _sallyArea;
  @reflectable get sallyArea => _sallyArea;

	@observable ShipInfo info;

	@observable LimitedValue hp;

	@observable LimitedValue fuel;

	@observable LimitedValue bull;

	@observable ModernizableStatus firepower;

	@observable ModernizableStatus torpedo;

	@observable ModernizableStatus aa;

	@observable ModernizableStatus armer;

	@observable ModernizableStatus luck;

	@observable List<SlotItem> slotItems;

	@observable List<int> onSlot;

	@observable bool isInRepairing;

  Ship(this._homeport, rawData) : super(rawData) {
		update(rawData);
	}

	void update(rawData) {
		updateRawData(rawData);

		info = KanColleClient.Current.Master.Ships[rawData["api_ship_id"]] != null ?
		    KanColleClient.Current.Master.Ships[rawData["api_ship_id"]] :
		    ShipInfo.dummy;
		hp = new LimitedValue(rawData["api_nowhp"], rawData["api_maxhp"], 0);
		fuel = new LimitedValue(rawData["api_fuel"], info.rawData["api_fuel_max"], 0);
		bull = new LimitedValue(rawData["api_bull"], info.rawData["api_bull_max"], 0);

		if (rawData["api_kyouka"].length >= 5) {
			firepower = new ModernizableStatus(info.rawData["api_houg"], rawData["api_kyouka"][0]);
			torpedo = new ModernizableStatus(info.rawData["api_raig"], rawData["api_kyouka"][1]);
			aa = new ModernizableStatus(info.rawData["api_tyku"], rawData["api_kyouka"][2]);
			armer = new ModernizableStatus(info.rawData["api_souk"], rawData["api_kyouka"][3]);
			luck = new ModernizableStatus(info.rawData["api_luck"], rawData["api_kyouka"][4]);
		}

		slotItems = rawData["api_slot"]
		    .map((id) => _homeport.itemyard.slotItems[id])
		    .where((x) => x != null).toList();
		onSlot = rawData["api_onslot"];
	}

	@override
	_update(rawData) {
	  _id = notifyPropertyChange(#id, _id, rawData["api_id"]);
    _sortNumber = notifyPropertyChange(#sortNumber, _sortNumber, rawData["api_sortno"]);
    _level = notifyPropertyChange(#level, _level, rawData["api_lv"]);
    _isLocked = notifyPropertyChange(#isLocked, _isLocked, rawData["api_locked"] == 1);
    _exp = notifyPropertyChange(
        #exp,
        _exp,
        rawData["api_exp"].length > 0 ? rawData["api_exp"][0] : 0);
    _expForNextLevel = notifyPropertyChange(
        #expForNextLevel,
        _expForNextLevel,
        rawData["api_exp"].length > 1 ? rawData["api_exp"][1] : 0);
    _viewRange = notifyPropertyChange(
        #viewRange,
        _viewRange,
        rawData["api_sakuteki"].length > 0 ? rawData["api_sakuteki"][0] : 0);
    _isMaxModernized = notifyPropertyChange(
        #isMaxModernized,
        _isMaxModernized,
        firepower.isMax && torpedo.isMax && aa.isMax && armer.isMax);
    _condition = notifyPropertyChange(#condition, _condition, rawData["api_cond"]);
    _conditionType = notifyPropertyChange(
        #conditionType,
        _conditionType,
        ConditionTypeHelper.toConditionType(rawData["api_cond"]));
    _sallyArea = notifyPropertyChange(#sallyArea, _sallyArea, rawData["api_sally_area"]);
	}

	void charge(int fuel, int bull, List<int> onslot) {
		this.fuel = this.fuel.update(fuel);
		this.bull = this.bull.update(bull);
		this.onSlot = onslot;
	}

	void repair() {
		var max = hp.maximum;
	  hp = hp.update(max);
	}

	@override
	String toString() {
		return "ID = ${id}, Name = \"${info.name}\", ShipType = \"${info.shipType.name}\", Level = ${level}";
	}
}
