part of kan_colle_wrapper.models;

class SlotItem extends RawDataWrapper implements IIdentifiable {
  int get id => rawData["api_id"];

  @observable final SlotItemInfo info;

  SlotItem(rawData)
      : info =
          KanColleClient.current.master.slotItems[rawData["api_slotitem_id"]] !=
          null ?
          KanColleClient.current.master.slotItems[rawData["api_slotitem_id"]] :
          SlotItemInfo.dummy,
        super(rawData);

  @override
  String toString() {
    return "ID = ${id}, Name = \"${info.name}\"";
  }
}
