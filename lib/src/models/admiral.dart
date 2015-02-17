part of kan_colle_wrapper.models;

class Admiral extends RawDataWrapper {

  String _memberId;
  @reflectable get memberId => _memberId;

  String _nickname;
  @reflectable get nickname => _nickname;

  @observable String comment;

  int _experience;
  @reflectable get experience => _experience;

  int _level;
  @reflectable get level => _level;

  int _sortieWins;
  @reflectable get sortieWins => _sortieWins;

  int _sortieLoses;
  @reflectable get sortieLoses => _sortieLoses;

  int _maxShipCount;
  @reflectable get maxShipCount => _maxShipCount;

  int _maxSlotItemCount;
  @reflectable get maxSlotItemCount => _maxSlotItemCount;

  int _experienceForNexeLevel;
  @reflectable get experienceForNexeLevel => _experienceForNexeLevel;

  double _sortieWinningRate;
  @reflectable get sortieWinningRate => _sortieWinningRate;

  String _rank;
  @reflectable get rank => _rank;

  Admiral(rawData) : super(rawData) {
    comment = rawData["api_comment"];
  }

  @override
  _update(data) {
    _memberId = notifyPropertyChange(#memberId, _memberId, data["api_member_id"]);
    _nickname = notifyPropertyChange(#nickname, _nickname, data["api_nickname"]);
    _experience = notifyPropertyChange(#experience, _experience, data["api_experience"]);
    _level = notifyPropertyChange(#level, _level, data["api_level"]);
    _sortieWins = notifyPropertyChange(#sortieWins, _sortieWins, data["api_st_win"]);
    _sortieLoses = notifyPropertyChange(#sortieLoses, _sortieLoses, data["api_st_lose"]);
    _maxShipCount = notifyPropertyChange(#maxShipCount, _maxShipCount, data["api_max_chara"]);
    _maxSlotItemCount = notifyPropertyChange(#maxSlotItemCount, _maxSlotItemCount, data["api_max_slotitem"]);
    _experienceForNexeLevel = notifyPropertyChange(
        #experienceForNexeLevel,
        _experienceForNexeLevel,
        Experience.getAdmiralExpForNextLevel(data["api_level"], data["api_experience"]));
    _rank = notifyPropertyChange(#rank, _rank, Rank.getName(data["api_rank"]));
    _sortieWinningRate = notifyPropertyChange(
        #sortieWinningRate,
        _sortieWinningRate,
        (() {
          var battleCount = data["api_st_win"] + data["api_st_lose"];
          if (battleCount == 0) return 0.0;
          return rawData["api_st_win"] / battleCount;
        }()));
    super.updateRawData(data);
  }

  @override
  String toString() {
    return "ID = ${memberId}, Nickname = \"${nickname}\", Level = ${level}, Rank = \"${rank}\"";
  }
}