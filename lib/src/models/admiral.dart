part of kan_colle_wrapper.models;

class Admiral extends RawDataWrapper {
  String get memberId => rawData["api_member_id"];
  String get nickname => rawData["api_nickname"];
  @observable String comment;
  int get experience => rawData["api_experience"];
  int get experienceForNexeLevel =>
      Experience.getAdmiralExpForNextLevel(
          rawData["api_level"],
          rawData["api_experience"]);
  int get level => rawData["api_level"];
  String get rank => Rank.getName(rawData["api_rank"]);
  int get sortieWins => rawData["api_st_win"];
  int get sortieLoses => rawData["api_st_lose"];
  double get sortieWinningRate {
    var battleCount = rawData["api_st_win"] + rawData["api_st_lose"];
    if (battleCount == 0) return 0.0;
    return rawData["api_st_win"] / battleCount;
  }
  int get maxShipCount => rawData["api_max_chara"];
  int get maxSlotItemCount => rawData["api_max_slotitem"];
  Admiral(rawData) : super(rawData) {
    comment = rawData["api_comment"];
  }
  @override
  String toString() {
    return
        "ID = ${memberId}, Nickname = \"${nickname}\", Level = ${level}, Rank = \"${rank}\"";
  }
}
