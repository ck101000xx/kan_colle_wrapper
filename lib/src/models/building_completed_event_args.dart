part of kan_colle_wrapper.models;

class BuildingCompletedEventArgs {
  final int dockId;
  final ShipInfo ship;

  BuildingCompletedEventArgs(this.dockId, this.ship);
}
