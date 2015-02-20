library kan_colle_wrpper.master;
import "models.dart";
import "dart:collection";

part "master_table.dart";

class Master {
  final MasterTable<ShipInfo> ships;
  final MasterTable<SlotItemInfo> slotItems;
  final MasterTable<UseItemInfo> useItems;
  final MasterTable<ShipType> shipTypes;
  final MasterTable<Mission> missions;


  Master(start2)
      : shipTypes = new MasterTable(
          start2["api_mst_stype"].map((x) => new ShipType(x))),
        ships = new MasterTable(
          start2["api_mst_ship"].map((x) => new ShipInfo(x))),
        slotItems = new MasterTable(
          start2["api_mst_slotitem"].map((x) => new SlotItemInfo(x))),
        useItems = new MasterTable(
          start2["api_mst_useitem"].map((x) => new UseItemInfo(x))),
        missions = new MasterTable(
          start2["api_mst_mission"].map((x) => new Mission(x)));
}
