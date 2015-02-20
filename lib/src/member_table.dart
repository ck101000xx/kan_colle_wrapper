part of kan_colle_wrapper.homeport;
class MemberTable<T> extends ObservableMap<int, T> {
  @override
  operator [](int key) => containsKey(key) ? super[key] : null;
  factory MemberTable([Iterable<IIdentifiable> source]) {
    if (source == null) {
      return new MemberTable.identity();
    }
    return new MemberTable.identity()..addAll(
        new Map.fromIterable(source, key: (x) => x.id));
  }

  MemberTable.identity() : super();
  void add(T value) {
    this[(value as IIdentifiable).id] = value;
  }

  @override
  T remove(Object value) {
    return super.remove(
        value is T ? (value as IIdentifiable).id : (value as int));
  }
}
