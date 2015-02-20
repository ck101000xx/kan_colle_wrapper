part of kan_colle_wrapper.models;

class LimitedValue<T> {
  final T current;
  final T maximum;
  final T minimum;

  LimitedValue(this.current, this.maximum, this.minimum);

  LimitedValue update(int current) {
    return new LimitedValue(current, maximum, minimum);
  }
}
