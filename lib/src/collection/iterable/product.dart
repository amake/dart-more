extension ProductExtension<E> on Iterable<Iterable<E>> {
  /// Returns an iterable over the cross product of this [Iterable].
  ///
  /// The resulting iterable is equivalent to nested for-loops. The rightmost
  /// elements advance on every iteration. This pattern creates a lexicographic
  /// ordering so that if the input’s iterables are sorted, the product is
  /// sorted as well.
  ///
  /// For example, the product of `['x', 'y']` and `[1, 2, 3]` is created with
  ///
  ///    [['x', 'y'], [1, 2, 3]].product();
  ///
  /// and results in an iterable with the following elements:
  ///
  ///    ['x', 1]
  ///    ['x', 2]
  ///    ['x', 3]
  ///    ['y', 1]
  ///    ['y', 2]
  ///    ['y', 3]
  ///
  Iterable<List<E>> product({int repeat = 1}) {
    if (repeat < 1) {
      throw RangeError.value(repeat, 'repeat', 'repeat must be positive');
    }
    if (isEmpty || any((iterable) => iterable.isEmpty)) {
      return const Iterable.empty();
    } else {
      return productNotEmpty(
          map((iterable) => iterable.toList(growable: false))
              .toList(growable: false),
          repeat);
    }
  }
}

Iterable<List<E>> productNotEmpty<E>(List<List<E>> elements, int repeat) sync* {
  final indexes = List<int>.filled(elements.length * repeat, 0);
  final current = List<E>.generate(
    elements.length * repeat,
    (i) => elements[i % elements.length][0],
  );
  var hasMore = false;
  do {
    yield current.toList(growable: false);
    hasMore = false;
    for (var i = indexes.length - 1; i >= 0; i--) {
      final e = i % elements.length;
      if (indexes[i] + 1 < elements[e].length) {
        indexes[i]++;
        current[i] = elements[e][indexes[i]];
        hasMore = true;
        break;
      } else {
        for (var j = indexes.length - 1; j >= i; j--) {
          indexes[j] = 0;
          current[j] = elements[j % elements.length][0];
        }
      }
    }
  } while (hasMore);
}
