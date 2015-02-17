part of kan_colle_wrapper.models;

class CreatedSlotItem extends RawDataWrapper {
	@reflectable bool get succeed => rawData["api_create_flag"] == 1;

	@observable SlotItemInfo slotItemInfo;

	CreatedSlotItem(rawData) : super(rawData) {
		try {
			slotItemInfo = succeed
				? KanColleClient.Current.Master.SlotItems[rawData["api_slot_item"]["api_slotitem_id"]]
				: KanColleClient.Current.Master.SlotItems[int.parse(rawData["api_fdata"].split(',')[1])];

			print("createitem: ${succeed} - ${slotItemInfo.name}");
		} catch (ex) {
			print(ex);
		}
	}
}
