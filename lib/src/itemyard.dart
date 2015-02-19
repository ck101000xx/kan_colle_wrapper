part of kan_colle_wrapper.homeport;

class Itemyard extends Observable {
  int __droppedItemsCount;
  get _droppedItemsCount => __droppedItemsCount;
  set _droppedItemsCount (value) {
    __droppedItemsCount = value;
    notifyPropertyChange(#slotItemsCount, _slotItemsCount, slotItems.length + _droppedItemsCount);
  }

  int _slotItemsCount;
  @reflectable get slotItemsCount => _slotItemsCount;

  MemberTable<SlotItem> _slotItems;
  @reflectable get slotItems => _slotItems;
  @reflectable set slotItems(value) {
    _slotItems = notifyPropertyChange(#slotItems, _slotItems, value);
    _slotItemsCount = notifyPropertyChange(#slotItemsCount, _slotItemsCount, slotItems.length + _droppedItemsCount);
    value.changes.listen((list) {
      list.forEach((_) {
        _slotItemsCount = notifyPropertyChange(#slotItemsCount, _slotItemsCount, slotItems.length + _droppedItemsCount);
      });
    });
  }
  @observable MemberTable<UseItem> useItems;

  Itemyard(KanColleProxy proxy) {
    slotItems = new MemberTable();
    useItems = new MemberTable();
    tryParse(proxy["api_get_member_slot_item"]).listen((x) => updateSlotItems(x.data));
    tryParse(proxy["api_req_kousyou_createitem"]).listen((x) => createItem(x.data));
    tryParse(proxy["api_req_kousyou_destroyitem2"]).listen(destroyItem);
    tryParse(proxy["api_req_sortie_battleresult"]).listen((x) => dropShip(x.data));
    tryParse(proxy["api_get_member_useitem"]).listen((x) => updateUseItems(x.data));
  }


  void updateSlotItems(source) {
    _droppedItemsCount = 0;
    slotItems = new MemberTable(source.map((x) => new SlotItem(x)));
  }

  void updateUseItems(source) {
    useItems = new MemberTable(source.map((x) => new UseItem(x)));
  }

  void addFromDock(source) {
    for (var x in source["api_slotitem"].map((x) => new SlotItem(x))) {
      slotItems.add(x);
    }
  }

  void removeFromShip(Ship ship) {
    for (var x in ship.slotItems.where((x) => x != null)) {
      slotItems.remove(x);
    }
  }

  void createItem(source) {
    if (source["api_create_flag"] == 1 && source["api_slot_item"] != null) {
      slotItems.add(new SlotItem(source["api_slot_item"]));
    }
  }

  void destroyItem(SvData data) {
    if (data == null || !data.isSuccess) return;

    try {
      for (var x in data.request["api_slotitem_ids"].split(',').map(int.parse)) {
        slotItems.remove(x);
      }
    } catch (ex) {
      print("装備の破棄に失敗しました: ${ex}");
    }
  }

  void dropShip(source) {
    try {
      if (source.hasProperty("api_get_ship")) return;

      var target = KanColleClient.current.master.ships[source["api_get_ship"]["api_ship_id"]];
      if (target == null) return;

      _droppedItemsCount += target.rawData["api_defeq"].where((x) => x != -1).length;
    } catch (ex) {
      // defeq が消えてるっぽい暫定対応 (雑)
      print(ex);
    }
  }
}
