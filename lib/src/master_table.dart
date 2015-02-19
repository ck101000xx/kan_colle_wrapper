part of kan_colle_wrpper.master;

class MasterTable<TValue> extends MapView<int, TValue> {
  @override
  TValue operator[] (int key) => super.containsKey(key) ? super[key] : null;
  MasterTable([Iterable<TValue> source])
      : super(
          source == null ?
          new Map.identity() :
          new Map.fromIterable(source, key: (x) => (x as IIdentifiable).id));
}