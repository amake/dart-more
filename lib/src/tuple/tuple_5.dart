import '../../hash.dart';
import '../../tuple.dart';

/// Tuple with 5 elements.
class Tuple5<T1, T2, T3, T4, T5> extends Tuple {
  /// Const constructor.
  const Tuple5(this.first, this.second, this.third, this.fourth, this.fifth);

  /// List constructor.
  // ignore: prefer_constructors_over_static_methods
  static Tuple5<T, T, T, T, T> fromList<T>(List<T> list) {
    if (list.length != 5) {
      throw ArgumentError.value(
          list, 'list', 'Expected list of length 5, but got ${list.length}.');
    }
    return Tuple5(list[0], list[1], list[2], list[3], list[4]);
  }

  @override
  int get length => 5;

  /// Returns the first element of this tuple.
  final T1 first;

  /// Returns the second element of this tuple.
  final T2 second;

  /// Returns the third element of this tuple.
  final T3 third;

  /// Returns the fourth element of this tuple.
  final T4 fourth;

  /// Returns the fifth element of this tuple.
  final T5 fifth;

  /// Returns the last element of this tuple.
  T5 get last => fifth;

  /// Returns a new tuple with the first element replaced by [value].
  Tuple5<T, T2, T3, T4, T5> withFirst<T>(T value) =>
      Tuple5(value, second, third, fourth, fifth);

  /// Returns a new tuple with the second element replaced by [value].
  Tuple5<T1, T, T3, T4, T5> withSecond<T>(T value) =>
      Tuple5(first, value, third, fourth, fifth);

  /// Returns a new tuple with the third element replaced by [value].
  Tuple5<T1, T2, T, T4, T5> withThird<T>(T value) =>
      Tuple5(first, second, value, fourth, fifth);

  /// Returns a new tuple with the fourth element replaced by [value].
  Tuple5<T1, T2, T3, T, T5> withFourth<T>(T value) =>
      Tuple5(first, second, third, value, fifth);

  /// Returns a new tuple with the fifth element replaced by [value].
  Tuple5<T1, T2, T3, T4, T> withFifth<T>(T value) =>
      Tuple5(first, second, third, fourth, value);

  /// Returns a new tuple with the last element replaced by [value].
  Tuple5<T1, T2, T3, T4, T> withLast<T>(T value) =>
      Tuple5(first, second, third, fourth, value);

  /// Returns a new tuple with [value] added at the first position.
  Tuple6<T, T1, T2, T3, T4, T5> addFirst<T>(T value) =>
      Tuple6(value, first, second, third, fourth, fifth);

  /// Returns a new tuple with [value] added at the second position.
  Tuple6<T1, T, T2, T3, T4, T5> addSecond<T>(T value) =>
      Tuple6(first, value, second, third, fourth, fifth);

  /// Returns a new tuple with [value] added at the third position.
  Tuple6<T1, T2, T, T3, T4, T5> addThird<T>(T value) =>
      Tuple6(first, second, value, third, fourth, fifth);

  /// Returns a new tuple with [value] added at the fourth position.
  Tuple6<T1, T2, T3, T, T4, T5> addFourth<T>(T value) =>
      Tuple6(first, second, third, value, fourth, fifth);

  /// Returns a new tuple with [value] added at the fifth position.
  Tuple6<T1, T2, T3, T4, T, T5> addFifth<T>(T value) =>
      Tuple6(first, second, third, fourth, value, fifth);

  /// Returns a new tuple with [value] added at the sixth position.
  Tuple6<T1, T2, T3, T4, T5, T> addSixth<T>(T value) =>
      Tuple6(first, second, third, fourth, fifth, value);

  /// Returns a new tuple with [value] added at the last position.
  Tuple6<T1, T2, T3, T4, T5, T> addLast<T>(T value) =>
      Tuple6(first, second, third, fourth, fifth, value);

  /// Returns a new tuple with the first element removed.
  Tuple4<T2, T3, T4, T5> removeFirst() => Tuple4(second, third, fourth, fifth);

  /// Returns a new tuple with the second element removed.
  Tuple4<T1, T3, T4, T5> removeSecond() => Tuple4(first, third, fourth, fifth);

  /// Returns a new tuple with the third element removed.
  Tuple4<T1, T2, T4, T5> removeThird() => Tuple4(first, second, fourth, fifth);

  /// Returns a new tuple with the fourth element removed.
  Tuple4<T1, T2, T3, T5> removeFourth() => Tuple4(first, second, third, fifth);

  /// Returns a new tuple with the fifth element removed.
  Tuple4<T1, T2, T3, T4> removeFifth() => Tuple4(first, second, third, fourth);

  /// Returns a new tuple with the last element removed.
  Tuple4<T1, T2, T3, T4> removeLast() => Tuple4(first, second, third, fourth);

  @override
  Iterable get iterable sync* {
    yield first;
    yield second;
    yield third;
    yield fourth;
    yield fifth;
  }

  @override
  R map<R>(
          R Function(T1 first, T2 second, T3 third, T4 fourth, T5 fifth)
              callback) =>
      callback(first, second, third, fourth, fifth);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tuple5 &&
          first == other.first &&
          second == other.second &&
          third == other.third &&
          fourth == other.fourth &&
          fifth == other.fifth);

  @override
  int get hashCode => hash5(first, second, third, fourth, fifth);
}
