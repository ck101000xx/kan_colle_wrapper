part of kan_colle_wrapper.models;

abstract class RawDataWrapper extends Observable {
  var _rawData;
  @reflectable get rawData => _rawData;
  RawDataWrapper(rawData) {
    updateRawData(rawData);
  }
  updateRawData(value) {
    _rawData =  notifyPropertyChange(#rawData, _rawData, value);
    _update(value);
  }
  _update(data);
}
