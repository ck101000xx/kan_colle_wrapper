part of kan_colle_wrapper.models;

class SlotItem extends RawDataWrapper implements IIdentifiable {
  int _id;
  @reflectable get id => _id;

  @observable final SlotItemInfo info;

  SlotItem(rawData)
    : info =
        KanColleClient.Current.Master.SlotItems[rawData["api_slotitem_id"]] != null ?
        KanColleClient.Current.Master.SlotItems[rawData["api_slotitem_id"]] :
        SlotItemInfo.dummy
    , super(rawData);
  @override
  _update(rawData) {
    _id = notifyPropertyChange(#id, _id, rawData["api_id"]);
  }
  @override
  String toString() {
    return "ID = ${id}, Name = \"${info.name}\"";
  }
}
