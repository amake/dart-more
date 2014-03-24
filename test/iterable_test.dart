library iterable_test;

import 'package:unittest/unittest.dart';
import 'package:more/iterable.dart';

void main() {
  group('iterable', () {
    group('concat', () {
      var a = [1, 2, 3], b = [4, 5], c = [6], d = [];
      test('void', () {
        expect(concat([]), []);
      });
      test('basic', () {
        expect(concat([a]), [1, 2, 3]);
        expect(concat([a, b]), [1, 2, 3, 4, 5]);
        expect(concat([b, a]), [4, 5, 1, 2, 3]);
        expect(concat([a, b, c]), [1, 2, 3, 4, 5, 6]);
        expect(concat([a, c, b]), [1, 2, 3, 6, 4, 5]);
        expect(concat([b, a, c]), [4, 5, 1, 2, 3, 6]);
        expect(concat([b, c, a]), [4, 5, 6, 1, 2, 3]);
        expect(concat([c, a, b]), [6, 1, 2, 3, 4, 5]);
        expect(concat([c, b, a]), [6, 4, 5, 1, 2, 3]);
      });
      test('empty', () {
        expect(concat([a, b, c, d]), [1, 2, 3, 4, 5, 6]);
        expect(concat([a, b, d, c]), [1, 2, 3, 4, 5, 6]);
        expect(concat([a, d, b, c]), [1, 2, 3, 4, 5, 6]);
        expect(concat([d, a, b, c]), [1, 2, 3, 4, 5, 6]);
      });
      test('repeated', () {
        expect(concat([a, a]), [1, 2, 3, 1, 2, 3]);
        expect(concat([b, b, b]), [4, 5, 4, 5, 4, 5]);
        expect(concat([c, c, c, c]), [6, 6, 6, 6]);
        expect(concat([d, d, d, d, d]), []);
      });
      test('types', () {
        expect(concat([new Set.from(c)]), [6]);
        expect(concat([new List.from(b)]), [4, 5]);
      });
    });
    group('cycle', () {
      test('empty', () {
        expect(cycle([]), isEmpty);
        expect(cycle([], 5), isEmpty);
        expect(cycle([1, 2], 0), isEmpty);
      });
      test('fixed', () {
        expect(cycle([1, 2], 1), [1, 2]);
        expect(cycle([1, 2], 2), [1, 2, 1, 2]);
        expect(cycle([1, 2], 3), [1, 2, 1, 2, 1, 2]);
      });
      test('infinite', () {
        expect(cycle([1, 2]).isEmpty, isFalse);
        expect(cycle([1, 2]).isNotEmpty, isTrue);
        expect(cycle([1, 2]).take(3), [1, 2, 1]);
        expect(cycle([1, 2]).skip(3).take(3), [2, 1, 2]);
      });
      test('invalid', () {
        expect(() => cycle([1, 2], -1), throwsArgumentError);
      });
      test('infinite', () {
        expect(cycle([1, 2]).isEmpty, isFalse);
        expect(cycle([1, 2]).isNotEmpty, isTrue);
        expect(() => cycle([1, 2]).length, throwsStateError);
        expect(() => cycle([1, 2]).last, throwsStateError);
        expect(() => cycle([1, 2]).lastWhere((e) => false), throwsStateError);
        expect(() => cycle([1, 2]).single, throwsStateError);
        expect(() => cycle([1, 2]).singleWhere((e) => false), throwsStateError);
        expect(() => cycle([1, 2]).toList(), throwsStateError);
        expect(() => cycle([1, 2]).toSet(), throwsStateError);
      });
    });
    group('empty', () {
      noCall1(a) => fail('No call expected, but got ($a).');
      noCall2(a, b) => fail('No call expected, but got ($a, $b).');
      test('iterator', () {
        var iterator = empty().iterator;
        expect(iterator.current, isNull);
        expect(iterator.moveNext(), isFalse);
        expect(iterator.current, isNull);
      });
      test('testing', () {
        expect(empty().isEmpty, isTrue);
        expect(empty().isNotEmpty, isFalse);
        expect(empty().length, 0);
      });
      test('iterating', () {
        empty().forEach(noCall1);
        expect(empty().map(noCall1), isEmpty);
        expect(empty().where(noCall1), isEmpty);
        expect(empty().fold(true, noCall2), isTrue);
        expect(() => empty().reduce(noCall2), throwsStateError);
        expect(empty().expand(noCall1), isEmpty);
      });
      test('testing', () {
        expect(empty().any(noCall1), isFalse);
        expect(empty().every(noCall1), isTrue);
        expect(empty().contains(1), isFalse);
      });
      test('take', () {
        expect(empty().take(5), isEmpty);
        expect(empty().takeWhile(noCall1), isEmpty);
      });
      test('skip', () {
        expect(empty().skip(5), isEmpty);
        expect(empty().skipWhile(noCall1), isEmpty);
      });
      test('first', () {
        expect(() => empty().first, throwsStateError);
        expect(() => empty().firstWhere(noCall1), throwsStateError);
        expect(empty().firstWhere(noCall1, orElse: () => true), isTrue);
      });
      test('last', () {
        expect(() => empty().last, throwsStateError);
        expect(() => empty().lastWhere(noCall1), throwsStateError);
        expect(empty().lastWhere(noCall1, orElse: () => true), isTrue);
      });
      test('single', () {
        expect(() => empty().single, throwsStateError);
        expect(() => empty().singleWhere(noCall1), throwsStateError);
      });
      test('converting', () {
        expect(empty().toList(), isEmpty);
        expect(empty().toList(growable: true), isEmpty);
        expect(empty().toList(growable: false), isEmpty);
        expect(empty().toSet(), isEmpty);
        expect(empty().join(), '');
      });
    });
    group('combinations', () {
      test('permutations', () {
        expect(permutations([0, 1, 2]),
            [[0, 1, 2], [0, 2, 1], [1, 0, 2],
             [1, 2, 0], [2, 0, 1], [2, 1, 0]]);
      });
      test('permutations (reverse)', () {
        expect(permutations([2, 1, 0], (a, b) => b - a),
            [[2, 1, 0], [2, 0, 1], [1, 2, 0],
             [1, 0, 2], [0, 2, 1], [0, 1, 2]]);
      });
    });
    group('string', () {
      group('immutable', () {
        var empty = string('');
        var plenty = string('More Dart');
        test('creating', () {
          var coerced = string(123);
          expect(coerced.length, 3);
          expect(coerced.toString(), '123');
        });
        test('isEmtpy', () {
          expect(empty.isEmpty, isTrue);
          expect(plenty.isEmpty, isFalse);
        });
        test('length', () {
          expect(empty.length, 0);
          expect(plenty.length, 9);
        });
        test('reading', () {
          expect(plenty[0], 'M');
          expect(plenty[1], 'o');
          expect(plenty[2], 'r');
          expect(plenty[3], 'e');
          expect(plenty[4], ' ');
          expect(plenty[5], 'D');
          expect(plenty[6], 'a');
          expect(plenty[7], 'r');
          expect(plenty[8], 't');
        });
        test('reading (range error)', () {
          expect(() => empty[0], throwsRangeError);
          expect(() => plenty[-1], throwsRangeError);
          expect(() => plenty[9], throwsRangeError);
        });
        test('converting', () {
          expect(empty.toList(), []);
          expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
          expect(empty.toSet(), new Set());
          expect(plenty.toSet(), new Set.from(['M', 'o', 'r', 'e', ' ', 'D', 'a', 't']));
          expect(empty.toString(), '');
          expect(plenty.toString(), 'More Dart');
        });
        test('read-only', () {
          expect(() => plenty[0] = 'a', throwsUnsupportedError);
          expect(() => plenty.length = 10, throwsUnsupportedError);
          expect(() => plenty.add('a'), throwsUnsupportedError);
          expect(() => plenty.remove('a'), throwsUnsupportedError);
        });
      });
      group('mutable', () {
        var empty = mutableString('');
        var plenty = mutableString('More Dart');
        test('creating', () {
          var coerced = mutableString(123);
          expect(coerced.length, 3);
          expect(coerced.toString(), '123');
        });
        test('isEmtpy', () {
          expect(empty.isEmpty, isTrue);
          expect(plenty.isEmpty, isFalse);
        });
        test('length', () {
          expect(empty.length, 0);
          expect(plenty.length, 9);
        });
        test('reading', () {
          expect(plenty[0], 'M');
          expect(plenty[1], 'o');
          expect(plenty[2], 'r');
          expect(plenty[3], 'e');
          expect(plenty[4], ' ');
          expect(plenty[5], 'D');
          expect(plenty[6], 'a');
          expect(plenty[7], 'r');
          expect(plenty[8], 't');
        });
        test('reading (range error)', () {
          expect(() => empty[0], throwsRangeError);
          expect(() => plenty[-1], throwsRangeError);
          expect(() => plenty[9], throwsRangeError);
        });
        test('writing', () {
          var mutable = mutableString('abc');
          mutable[1] = 'd';
          expect(mutable.toString(), 'adc');
        });
        test('writing (range error)', () {
          expect(() => empty[0] = 'a', throwsRangeError);
          expect(() => plenty[-1] = 'a', throwsRangeError);
          expect(() => plenty[9] = 'a', throwsRangeError);
        });
        test('adding', () {
          var mutable = mutableString('abc');
          mutable.add('d');
          expect(mutable.toString(), 'abcd');
        });
        test('removing', () {
          var mutable = mutableString('abc');
          mutable.remove('a');
          expect(mutable.toString(), 'bc');
        });
        test('converting', () {
          expect(empty.toList(), []);
          expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
          expect(empty.toSet(), new Set());
          expect(plenty.toSet(), new Set.from(['M', 'o', 'r', 'e', ' ', 'D', 'a', 't']));
          expect(empty.toString(), '');
          expect(plenty.toString(), 'More Dart');
        });
      });
    });




    test('fibonacci', () {
      expect(fibonacci(0, 1).take(8), [0, 1, 1, 2, 3, 5, 8, 13]);
      expect(fibonacci(1, 1).take(8), [1, 1, 2, 3, 5, 8, 13, 21]);
      expect(fibonacci(1, 0).take(8), [1, 0, 1, 1, 2, 3, 5, 8]);
    });

    test('digits', () {
      expect(digits(0).toList(), [0]);
      expect(digits(1).toList(), [1]);
      expect(digits(12).toList(), [2, 1]);
      expect(digits(123).toList(), [3, 2, 1]);
      expect(digits(1001).toList(), [1, 0, 0, 1]);
      expect(digits(10001).toList(), [1, 0, 0, 0, 1]);
      expect(digits(1000).toList(), [0, 0, 0, 1]);
      expect(digits(10000).toList(), [0, 0, 0, 0, 1]);
    });
    test('digits (base 2)', () {
      expect(digits(0, 2).toList(), [0]);
      expect(digits(1, 2).toList(), [1]);
      expect(digits(12, 2).toList(), [0, 0, 1, 1]);
      expect(digits(123, 2).toList(), [1, 1, 0, 1, 1, 1, 1]);
      expect(digits(1001, 2).toList(), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10001, 2).toList(), [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      expect(digits(1000, 2).toList(), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10000, 2).toList(), [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
    });
    test('digits (base 16)', () {
      expect(digits(0, 16).toList(), [0]);
      expect(digits(1, 16).toList(), [1]);
      expect(digits(12, 16).toList(), [12]);
      expect(digits(123, 16).toList(), [11, 7]);
      expect(digits(1001, 16).toList(), [9, 14, 3]);
      expect(digits(10001, 16).toList(), [1, 1, 7, 2]);
      expect(digits(1000, 16).toList(), [8, 14, 3]);
      expect(digits(10000, 16).toList(), [0, 1, 7, 2]);
    });
  });
}

