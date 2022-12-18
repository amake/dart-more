extension IndexedExtension<E> on Iterable<E> {
  /// Returns a iterable that combines the index and value of this [Iterable].
  ///
  /// By default the index is zero based, but an arbitrary [offset] can be
  /// provided.
  ///
  /// For example, the expression
  ///
  ///     ['a', 'b'].indexed(offset: 1)
  ///       .map((each) => '${each.index}: ${each.value}')
  ///       .join(', ');
  ///
  /// returns
  ///
  ///     '1: a, 2: b'
  ///
  Iterable<Indexed<E>> indexed({int offset = 0}) sync* {
    for (final element in this) {
      yield Indexed<E>(offset++, element);
    }
  }
}

/// An indexed value.
class Indexed<E> implements MapEntry<int, E> {
  const Indexed(this.key, this.value);

  @override
  final int key;

  @override
  final E value;

  /// The index of the entry.
  int get index => key;

  @override
  String toString() => 'Indexed($key: $value)';
}
