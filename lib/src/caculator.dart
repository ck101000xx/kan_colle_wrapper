import "dart:math";
import "internal/extensions.dart";
import "models.dart";
import 'package:collection/iterable_zip.dart';

class Calculator {
  calcAirSuperiorityPotential(dynamic a, [dynamic b]) {
    int calcItem(SlotItem slotItem, int onslot) {
      if (slotItem.info.isAirSuperiorityFighter) {
        return (slotItem.info.aa * sqrt(onslot)).toInt();
      }
      return 0;
    }
    int calcShip(Ship ship) =>
      new IterableZip([ship.slotItems, ship.onSlot])
        .fold(0, (prev, pair) =>
            prev + calcAirSuperiorityPotential(pair[0], pair[1]));
    if (b == null) {
      return calcShip(a);
    } else {
      calcItem(a, b);
    }
  }

  int calcFleetViewRange(Fleet fleet, ViewRangeCalcLogic logic) {
    if (fleet == null || fleet.ships.length == 0) return 0;

    if (logic == ViewRangeCalcLogic.type1) {
      return fleet.ships.fold(0, (a, b) => a + b);
    }

    if (logic == ViewRangeCalcLogic.type2) {
      // http://wikiwiki.jp/kancolle/?%C6%EE%C0%BE%BD%F4%C5%E7%B3%A4%B0%E8#area5
      // [索敵装備と装備例] によって示されている計算式
      // stype=7 が偵察機 (2 倍する索敵値)、stype=8 が電探

      var spotter = fleet.ships.expand((x) =>
          new IterableZip([x.slotItems, x.onSlot])
              .where((a) => get(a[0].rawData["api_type"], 1) == 7)
              .where((a) => a[1] > 0)
              .map((a) => a[1].rawData["api_saku"])
          ).fold(0, (a, b) => a + b);

      var radar = fleet.ships.expand((x) =>
          x.slotItems
              .where((i) => get(i.info.rawData["api_type"], 1) == 8)
          .map((i) => i.info.rawData["api_saku"])
        ).fold(0, (a, b) => a + b);

      return (spotter * 2) + radar +
          sqrt(fleet.ships.fold(0, (prev, ship) => prev + ship.viewRange) - spotter - radar).toInt();
    }

    return 0;
  }
}


enum ViewRangeCalcLogic {
  type1,
  type2,
}