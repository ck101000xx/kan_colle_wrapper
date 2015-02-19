part of kan_colle_wrapper.models;

abstract class RawDataWrapper extends Observable {
  @observable var rawData;
  RawDataWrapper(rawData) {
    updateRawData(rawData);
  }
  updateRawData(value) {
    rawData = value;
  }
}
