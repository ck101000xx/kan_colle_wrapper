part of kan_colle_wrapper.client;

class KanColleClientSettings extends Observable {
  @observable int notificationShorteningTime = 40;
  @observable int reSortieCondition = 40;
  @observable bool enableLogging;
  @observable ViewRangeCalcLogic viewRangeCalcLogic;
}
