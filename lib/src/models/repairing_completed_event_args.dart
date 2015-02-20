part of kan_colle_wrapper.models;

class RepairingCompletedEventArgs {

  final int dockId;
  final Ship ship;

  RepairingCompletedEventArgs(this.dockId, this.ship);
}
