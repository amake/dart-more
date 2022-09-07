import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/iterable.dart';
import 'package:more/math.dart';
import 'package:test/test.dart';

List<bool> randomBooleans(int seed, int length) {
  final list = <bool>[];
  final generator = Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

void main() {
  group('bimap', () {
    final example = BiMap.of({1: 'a', 2: 'b', 3: 'c'});
    group('construction', () {
      test('empty', () {
        final target = BiMap();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('identity', () {
        final target = BiMap.identity();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('of', () {
        final target = BiMap.of(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('from', () {
        final target = BiMap.from(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable', () {
        final target = BiMap.fromIterable(example.keys);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [1, 2, 3]);
      });
      test('iterable (key)', () {
        final target =
            BiMap.fromIterable(example.keys, key: (e) => (e as int) + 1);
        expect(target.keys, [2, 3, 4]);
        expect(target.values, [1, 2, 3]);
      });
      test('iterable (value)', () {
        final target =
            BiMap.fromIterable(example.keys, value: (e) => (e as int) + 1);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [2, 3, 4]);
      });
      test('iterables', () {
        final target = BiMap.fromIterables(example.keys, example.values);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterables (reverse)', () {
        final target = BiMap.fromIterables(example.values, example.keys);
        expect(target.keys, ['a', 'b', 'c']);
        expect(target.values, [1, 2, 3]);
      });
      test('iterables (error)', () {
        expect(() => BiMap.fromIterables([1], []), throwsArgumentError);
        expect(() => BiMap.fromIterables([], [1]), throwsArgumentError);
      });
      test('map converter', () {
        final target = example.toBiMap();
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable converter', () {
        final target = [
          0,
          1,
          2
        ].toBiMap(key: (e) => e + 1, value: (e) => String.fromCharCode(97 + e));
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
    });
    group('accessing', () {
      test('indexed', () {
        expect(example[2], 'b');
        expect(example['b'], isNull);
      });
      test('indexed of inverse', () {
        expect(example.inverse['b'], 2);
        expect(example.inverse[2], isNull);
      });
      test('keys', () {
        expect(example.keys, [1, 2, 3]);
        expect(example.containsKey(2), isTrue);
        expect(example.containsKey('b'), isFalse);
      });
      test('keys of inverse', () {
        expect(example.inverse.keys, ['a', 'b', 'c']);
        expect(example.inverse.containsKey(2), isFalse);
        expect(example.inverse.containsKey('b'), isTrue);
      });
      test('values', () {
        expect(example.values, ['a', 'b', 'c']);
        expect(example.containsValue(2), isFalse);
        expect(example.containsValue('b'), isTrue);
      });
      test('values of inverse', () {
        expect(example.inverse.values, [1, 2, 3]);
        expect(example.inverse.containsValue(2), isTrue);
        expect(example.inverse.containsValue('b'), isFalse);
      });
      test('inverse updates', () {
        final target = BiMap.of(example);
        final inverse = target.inverse;
        target[4] = 'd';
        expect(inverse['d'], 4, reason: 'inverse sees addition');
        target.remove(3);
        expect(inverse[3], isNull, reason: 'inverse sees removal');
        inverse['e'] = 5;
        expect(target[5], 'e', reason: 'inverse updates target');
        inverse.remove('d');
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('forward updates', () {
        final target = BiMap.of(example);
        final forward = target.forward;
        target[4] = 'd';
        expect(forward[4], 'd', reason: 'inverse sees addition');
        target.remove(3);
        expect(forward[3], isNull, reason: 'inverse sees removal');
        forward[5] = 'e';
        expect(target[5], 'e', reason: 'inverse updates target');
        forward.remove(4);
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('backward updates', () {
        final target = BiMap.of(example);
        final backward = target.backward;
        target[4] = 'd';
        expect(backward['d'], 4, reason: 'inverse sees addition');
        target.remove(3);
        expect(backward[3], isNull, reason: 'inverse sees removal');
        backward['e'] = 5;
        expect(target[5], 'e', reason: 'inverse updates target');
        backward.remove('d');
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('iteration', () {
        final keys = <int>[];
        final values = <String>[];
        example.forEach((key, value) {
          keys.add(key);
          values.add(value);
        });
        expect(example.keys, keys);
        expect(example.values, values);
      });
    });
    group('writing', () {
      test('define', () {
        final target = BiMap();
        target[1] = 'a';
        expect(target.keys, [1]);
        expect(target.values, ['a']);
      });
      test('define inverse', () {
        final target = BiMap();
        target.inverse[1] = 'a';
        expect(target.keys, ['a']);
        expect(target.values, [1]);
      });
      test('redefine key to new value', () {
        final target = BiMap.of(example);
        target[2] = 'd';
        expect(target.keys, [1, 3, 2]);
        expect(target.values, ['a', 'c', 'd']);
      });
      test('redefine value to new key', () {
        final target = BiMap.of(example);
        target[4] = 'b';
        expect(target.keys, [1, 3, 4]);
        expect(target.values, ['a', 'c', 'b']);
      });
      test('redefine key and value', () {
        final target = BiMap.of(example);
        target[1] = 'c';
        expect(target.keys, [2, 1]);
        expect(target.values, ['b', 'c']);
      });
      test('remove key', () {
        final target = BiMap.of(example);
        expect(target.remove(2), 'b');
        expect(target.keys, [1, 3]);
        expect(target.values, ['a', 'c']);
        expect(target.inverse.keys, ['a', 'c']);
        expect(target.inverse.values, [1, 3]);
      });
      test('remove value', () {
        final target = BiMap.of(example);
        expect(target.inverse.remove('b'), 2);
        expect(target.keys, [1, 3]);
        expect(target.values, ['a', 'c']);
        expect(target.inverse.keys, ['a', 'c']);
        expect(target.inverse.values, [1, 3]);
      });
      test('clear', () {
        final target = BiMap.of(example);
        target.clear();
        expect(target, isEmpty);
        expect(target.inverse, isEmpty);
      });
      test('define if absent', () {
        final target = BiMap.of(example);
        target.putIfAbsent(1, () => throw StateError('Value already present!'));
        target.putIfAbsent(4, () => 'd');
        expect(target[4], 'd');
      });
    });
  });
  group('bitlist', () {
    group('construction', () {
      test('without elements', () {
        final target = BitList(0);
        expect(target, isEmpty);
        expect(target, hasLength(0));
        expect(target, []);
      });
      test('with elements', () {
        for (var len = 1; len < 100; len++) {
          final target = BitList(len);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isFalse));
        }
      });
      test('with filled false', () {
        for (var len = 1; len < 100; len++) {
          final target = BitList.filled(len, false);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isFalse));
        }
      });
      test('with filled true', () {
        for (var len = 1; len < 100; len++) {
          final target = BitList.filled(len, true);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isTrue));
        }
      });
      test('from List', () {
        for (var len = 0; len < 100; len++) {
          final source = List<bool>.of(randomBooleans(457 * len, len));
          final target = BitList.from(source);
          expect(source, target);
          expect(source, target.toList());
        }
      });
      test('of List', () {
        for (var len = 0; len < 100; len++) {
          final source = List<bool>.of(randomBooleans(457 * len, len));
          final target = BitList.of(source);
          expect(source, target);
          expect(source, target.toList());
        }
      });
      test('of Set', () {
        for (var len = 0; len < 100; len++) {
          final source = Set<bool>.of(randomBooleans(827 * len, len));
          final target = BitList.of(source);
          expect(source, target);
          expect(source, target.toSet());
        }
      });
      test('of BitList', () {
        for (var len = 0; len < 10; len++) {
          final source = Set<bool>.of(randomBooleans(287 * len, len));
          final target = BitList.of(source);
          expect(source, target);
          expect(target, source);
        }
      });
      test('converter', () {
        for (var len = 0; len < 10; len++) {
          final source = randomBooleans(195 * len, len);
          final target = source.toBitList();
          expect(source, target);
          expect(target, source);
        }
      });
    });
    group('accessors', () {
      test('reading', () {
        for (var len = 0; len < 100; len++) {
          final source = randomBooleans(135 * len, len);
          final target = BitList.of(source);
          expect(() => target[-1], throwsRangeError);
          for (var i = 0; i < len; i++) {
            expect(target[i], source[i]);
          }
          expect(() => target[len], throwsRangeError);
        }
      });
      test('writing', () {
        for (var len = 0; len < 100; len++) {
          final source = randomBooleans(396 * len, len);
          final target = BitList(len);
          expect(() => target[-1] = true, throwsRangeError);
          for (var i = 0; i < len; i++) {
            target[i] = source[i];
            expect(target.sublist(0, i), source.sublist(0, i));
            expect(target.sublist(i + 1), everyElement(isFalse));
          }
          expect(() => target[len] = true, throwsRangeError);
        }
      });
      test('flipping', () {
        for (var len = 0; len < 100; len++) {
          final source = BitList.of(randomBooleans(385 * len, len));
          final target = ~source;
          expect(() => target.flip(-1), throwsRangeError);
          for (var i = 0; i < len; i++) {
            final before = source[i];
            source.flip(i);
            expect(!before, source[i]);
          }
          expect(() => target.flip(len), throwsRangeError);
          expect(target, source);
        }
      });
      test('counting', () {
        for (var len = 0; len < 100; len++) {
          final list = BitList.of(randomBooleans(823 * len, len));
          final trueCount = list.count();
          final falseCount = list.count(false);
          expect(trueCount + falseCount, list.length);
          expect(trueCount, list.where((b) => b == true).length);
          expect(falseCount, list.where((b) => b == false).length);
        }
      });
    });
    group('operators', () {
      test('concatenate', () {
        for (var len1 = 0; len1 < 100; len1++) {
          for (var len2 = 0; len2 < 100; len2++) {
            final source1 = BitList.of(randomBooleans(954 * len1, len1));
            final source2 = BitList.of(randomBooleans(713 * len2, len2));
            final target = source1 + source2;
            expect(target.length, len1 + len2);
            for (var i = 0; i < len1 + len2; i++) {
              expect(target[i], i < len1 ? source1[i] : source2[i - len1]);
            }
          }
        }
      });
      group('complement', () {
        test('operator', () {
          final source = BitList.of(randomBooleans(702, 100));
          final target = ~source;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], !source[i]);
          }
        });
        test('in-place', () {
          final source = BitList.of(randomBooleans(702, 100));
          final target = BitList.of(source);
          target.not();
          for (var i = 0; i < target.length; i++) {
            expect(target[i], !source[i]);
          }
        });
      });
      group('intersection', () {
        test('operator', () {
          final source1 = BitList.of(randomBooleans(439, 100));
          final source2 = BitList.of(randomBooleans(902, 100));
          final target = source1 & source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] && source2[i]);
          }
          expect(target, source2 & source1);
          final other = BitList(99);
          expect(() => other & source1, throwsArgumentError);
          expect(() => source1 & other, throwsArgumentError);
        });
        test('in-place', () {
          final source1 = BitList.of(randomBooleans(439, 100));
          final source2 = BitList.of(randomBooleans(902, 100));
          final target = BitList.of(source1);
          target.and(source2);
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] && source2[i]);
          }
        });
      });
      group('union', () {
        test('operator', () {
          final source1 = BitList.of(randomBooleans(817, 100));
          final source2 = BitList.of(randomBooleans(858, 100));
          final target = source1 | source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] || source2[i]);
          }
          expect(target, source2 | source1);
          final other = BitList(99);
          expect(() => other | source1, throwsArgumentError);
          expect(() => source1 | other, throwsArgumentError);
        });
        test('in-place', () {
          final source1 = BitList.of(randomBooleans(439, 100));
          final source2 = BitList.of(randomBooleans(902, 100));
          final target = BitList.of(source1);
          target.or(source2);
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] || source2[i]);
          }
        });
      });
      test('difference', () {
        final source1 = BitList.of(randomBooleans(364, 100));
        final source2 = BitList.of(randomBooleans(243, 100));
        final target = source1 - source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] && !source2[i]);
        }
        expect(target, source1 & ~source2);
        final other = BitList(99);
        expect(() => other - source1, throwsArgumentError);
        expect(() => source1 - other, throwsArgumentError);
      });
      test('shift-left', () {
        for (var len = 0; len < 100; len++) {
          final source = BitList.of(randomBooleans(836 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            final target = source << shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target, everyElement(isFalse));
            } else {
              for (var i = shift; i < source.length; i++) {
                expect(target[i], source[i - shift]);
              }
            }
          }
          expect(() => source << -1, throwsArgumentError);
        }
      });
      test('shift-right', () {
        for (var len = 0; len < 100; len++) {
          final source = BitList.of(randomBooleans(963 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            final target = source >> shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target, everyElement(isFalse));
            } else {
              for (var i = 0; i < source.length - shift; i++) {
                expect(target[i], source[i + shift]);
              }
            }
          }
          expect(() => source >> -1, throwsArgumentError);
        }
      });
    });
    test('fixed length', () {
      final list = BitList(32);
      expect(() => list.add(false), throwsUnsupportedError);
      expect(() => list.addAll([true, false]), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(() => list.insert(2, true), throwsUnsupportedError);
      expect(() => list.insertAll(2, [true, false]), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(true), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(
          () => list.replaceRange(2, 4, [true, false]), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
    });
  });
  group('heap', () {
    group(
        'of',
        () => allHeapTests(<T>(List<T> list, {Comparator<T>? comparator}) =>
            Heap<T>.of(list, comparator: comparator)));
    group(
        'pushAll',
        () => allHeapTests(<T>(List<T> list, {Comparator<T>? comparator}) =>
            Heap<T>(comparator: comparator)..pushAll(list)));

    // const ordered = [1, 2, 3, 4, 5];
    // group('constructor', () {
    //   test('empty', () {
    //     final heap = Heap<int>();
    //     verifyHeapInvariants(heap, source: []);
    //   });
    //   for (var permutation in ordered.permutations()) {
    //     test('of(${permutation.join(', ')})', () {
    //       final heap = Heap<int>.of(permutation);
    //       verifyHeapInvariants(heap, source: permutation);
    //       for (var i = ordered.length - 1; i >= 0; i--) {
    //         expect(heap.peek, ordered[i]);
    //         expect(heap.pop(), ordered[i]);
    //       }
    //     });
    //   }
    // });
    // group('push/pop', () {
    //   for (var permutation in ordered.permutations()) {
    //     test(permutation.join(', '), () {
    //       final heap = Heap<int>();
    //       heap.pushAll(permutation);
    //       verifyHeapInvariants(heap, source: permutation);
    //       for (var i = ordered.length - 1; i >= 0; i--) {
    //         expect(heap.peek, ordered[i]);
    //         expect(heap.pop(), ordered[i]);
    //       }
    //     });
    //   }
    // });
    // group('stress', () {
    //
    //
    //
    //   final random = Random(314);
    //   final unique = <int>{};
    //   // Create 1000 unique numbers.
    //   while (unique.length < 1000) {
    //     unique.add(random.nextInt(0xffffff));
    //   }
    //   final list = unique.toList()..sort();
    //   final heap1 = Heap<int>.of(unique);
    //   final heap2 = Heap<int>()..pushAll(unique);
    //   // Remove the 500 largest numbers
    //   while (list.length > 500) {
    //     final max = list.removeLast();
    //     expect(heap1.length, list.length + 1);
    //     expect(heap1.peek, max);
    //     expect(heap1.pop(), max);
    //     expect(heap2.length, list.length + 1);
    //     expect(heap2.peek, max);
    //     expect(heap2.pop(), max);
    //   }
    //   // Push and pop
    //
    // });
  });
  group('multimap', () {
    group('list', () {
      group('constructor', () {
        test('empty', () {
          final map = ListMultimap();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.isEmpty, isTrue);
          expect(map.isNotEmpty, isFalse);
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('of', () {
          final map = ListMultimap.of(
              ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]));
          expect(map, hasLength(3));
          expect(map.isEmpty, isFalse);
          expect(map.isNotEmpty, isTrue);
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('identity', () {
          final map = ListMultimap.identity();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('fromIterable', () {
          final map = ListMultimap<String, int>.fromIterable(IntegerRange(3),
              key: (i) => String.fromCharCode((i as int) + 97),
              value: (i) => (i as int) + 1);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b', 'c']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2],
            'c': [3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2]);
          expect(map['c'], [3]);
        });
        test('fromIterable (no providers)', () {
          final map = ListMultimap.fromIterable(IntegerRange(3));
          expect(map, hasLength(3));
          expect(map.keys, [0, 1, 2]);
          expect(map.values, [0, 1, 2]);
          expect(map.asMap(), {
            0: [0],
            1: [1],
            2: [2]
          });
          expect(map[0], [0]);
          expect(map[1], [1]);
          expect(map[2], [2]);
        });
        test('fromIterables', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('fromIterables (error)', () {
          expect(() => ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2]),
              throwsArgumentError);
        });
        test('fromEntries', () {
          final map = ListMultimap.fromEntries(
              const [MapEntry('a', 1), MapEntry('b', 2), MapEntry('b', 3)]);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('map converter', () {
          final target = {'a': 1, 'b': 2, 'c': 3}.toListMultimap();
          expect(target.keys, ['a', 'b', 'c']);
          expect(target.values, [1, 2, 3]);
          expect(target.asMap(), {
            'a': [1],
            'b': [2],
            'c': [3]
          });
        });
        test('iterable converter', () {
          final target = ['a', 'abb', 'abb', 'bb']
              .toListMultimap(key: (e) => e[0], value: (e) => e.length);
          expect(target.keys, ['a', 'b']);
          expect(target.values, [1, 3, 3, 2]);
          expect(target.asMap(), {
            'a': [1, 3, 3],
            'b': [2],
          });
        });
      });
      group('accessor', () {
        test('containsKey', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map.containsKey('a'), isTrue);
          expect(map.containsKey('b'), isTrue);
          expect(map.containsKey('c'), isFalse);
        });
        test('containsValue', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map.containsValue(1), isTrue);
          expect(map.containsValue(2), isTrue);
          expect(map.containsValue(3), isTrue);
          expect(map.containsValue(4), isFalse);
        });
      });
      group('modifiers', () {
        test('add', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.add('b', 4);
          expect(map, hasLength(4));
          expect(collection, [2, 3, 4]);
        });
        test('addAll', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.addAll('b', [3, 4, 5]);
          expect(map, hasLength(6));
          expect(collection, [2, 3, 3, 4, 5]);
        });
        test('remove', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.remove('b', 3);
          expect(map, hasLength(2));
          expect(collection, [2]);
        });
        test('removeAll', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.removeAll('b');
          expect(map, hasLength(1));
          expect(collection, isEmpty);
        });
        test('removeAll with list', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.removeAll('b', [3]);
          expect(map, hasLength(2));
          expect(collection, [2]);
        });
        test('replace', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.replace('b', 4);
          expect(map, hasLength(2));
          expect(collection, [4]);
        });
        test('replaceAll', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.replaceAll('b', [3, 4, 5]);
          expect(map, hasLength(4));
          expect(collection, [3, 4, 5]);
        });
        test('clear', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.clear();
          expect(map, isEmpty);
          expect(collection, isEmpty);
        });
        test('clear', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.clear();
          expect(map, isEmpty);
          expect(collection, isEmpty);
        });
      });
      group('views', () {
        group('values', () {
          test('refresh empty', () {
            final map = ListMultimap<String, int>();
            final keyView1 = map['a'];
            final keyView2 = map['a'];
            expect(keyView1, isNot(same(keyView2)));
            keyView1.add(1);
            expect(keyView1, [1]);
            expect(keyView2, [1]);
          });
          test('refresh full', () {
            final map = ListMultimap.fromIterables(['a'], [1]);
            final keyView1 = map['a'];
            final keyView2 = map['a'];
            expect(keyView1, isNot(same(keyView2)));
            keyView1.add(2);
            expect(keyView1, [1, 2]);
            expect(keyView2, [1, 2]);
          });
        });
        group('asMap', () {
          test('access', () {
            final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
            final mapView = map.asMap();
            expect(mapView['b'], [2, 3]);
            mapView['b'] = [4, 5, 6];
            expect(map['b'], [4, 5, 6]);
            expect(mapView['b'], [4, 5, 6]);
          });
          test('clear', () {
            final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
            final mapView = map.asMap();
            mapView.clear();
            expect(map, isEmpty);
            expect(mapView, isEmpty);
          });
          test('remove', () {
            final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
            final mapView = map.asMap();
            mapView.remove('b');
            expect(map.keys, ['a']);
            expect(mapView.keys, ['a']);
          });
        });
        test('toString', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map.toString(), '{a: [1], b: [2, 3]}');
        });
      });
    });
    group('set', () {
      group('constructor', () {
        test('empty', () {
          final map = SetMultimap();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.isEmpty, isTrue);
          expect(map.isNotEmpty, isFalse);
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('of', () {
          final map = SetMultimap.of(
              SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]));
          expect(map, hasLength(3));
          expect(map.isEmpty, isFalse);
          expect(map.isNotEmpty, isTrue);
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('identity', () {
          final map = SetMultimap.identity();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('fromIterable', () {
          final map = SetMultimap.fromIterable(IntegerRange(3),
              key: (i) => String.fromCharCode((i as int) + 97),
              value: (i) => (i as int) + 1);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b', 'c']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2],
            'c': [3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2]);
          expect(map['c'], [3]);
        });
        test('fromIterable (no providers)', () {
          final map = SetMultimap.fromIterable(IntegerRange(3));
          expect(map, hasLength(3));
          expect(map.keys, [0, 1, 2]);
          expect(map.values, [0, 1, 2]);
          expect(map.asMap(), {
            0: [0],
            1: [1],
            2: [2]
          });
          expect(map[0], [0]);
          expect(map[1], [1]);
          expect(map[2], [2]);
        });
        test('fromIterables', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('fromIterables (error)', () {
          expect(() => SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2]),
              throwsArgumentError);
        });
        test('fromEntries', () {
          final map = SetMultimap.fromEntries(
              const [MapEntry('a', 1), MapEntry('b', 2), MapEntry('b', 3)]);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('map converter', () {
          final target = {'a': 1, 'b': 2, 'c': 3}.toSetMultimap();
          expect(target.keys, ['a', 'b', 'c']);
          expect(target.values, [1, 2, 3]);
          expect(target.asMap(), {
            'a': [1],
            'b': [2],
            'c': [3]
          });
        });
        test('iterable converter', () {
          final target = ['a', 'abb', 'abb', 'bb']
              .toSetMultimap(key: (e) => e[0], value: (e) => e.length);
          expect(target.keys, ['a', 'b']);
          expect(target.values, [1, 3, 2]);
          expect(target.asMap(), {
            'a': {1, 3},
            'b': {2},
          });
        });
      });
      group('accessors', () {
        test('containsKey', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map.containsKey('a'), isTrue);
          expect(map.containsKey('b'), isTrue);
          expect(map.containsKey('c'), isFalse);
        });
        test('containsValue', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map.containsValue(1), isTrue);
          expect(map.containsValue(2), isTrue);
          expect(map.containsValue(3), isTrue);
          expect(map.containsValue(4), isFalse);
        });
        test('lookup', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map['b'].lookup(2), 2);
          expect(map['b'].lookup(3), 3);
          expect(map['b'].lookup(4), null);
        });
      });
      group('modifiers', () {
        test('add', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.add('b', 4);
          expect(map, hasLength(4));
          expect(collection, [2, 3, 4]);
        });
        test('addAll', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.addAll('b', [3, 4, 5]);
          expect(map, hasLength(5));
          expect(collection, [2, 3, 4, 5]);
        });
        test('remove', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.remove('b', 3);
          expect(map, hasLength(2));
          expect(collection, [2]);
        });
        test('removeAll', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.removeAll('b');
          expect(map, hasLength(1));
          expect(collection, isEmpty);
        });
        test('removeAll with list', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.removeAll('b', [3]);
          expect(map, hasLength(2));
          expect(collection, [2]);
        });
        test('replace', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.replace('b', 4);
          expect(map, hasLength(2));
          expect(collection, [4]);
        });
        test('replaceAll', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.replaceAll('b', [3, 4, 5]);
          expect(map, hasLength(4));
          expect(collection, [3, 4, 5]);
        });
        test('clear', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final collection = map['b'];
          map.clear();
          expect(map, isEmpty);
          expect(collection, isEmpty);
        });
      });
      group('views', () {
        group('values', () {
          test('refresh empty', () {
            final map = SetMultimap<String, int>();
            final keyView1 = map['a'];
            final keyView2 = map['a'];
            expect(keyView1, isNot(same(keyView2)));
            keyView1.add(1);
            expect(keyView1, [1]);
            expect(keyView2, [1]);
          });
          test('refresh full', () {
            final map = SetMultimap.fromIterables(['a'], [1]);
            final keyView1 = map['a'];
            final keyView2 = map['a'];
            expect(keyView1, isNot(same(keyView2)));
            keyView1.add(2);
            expect(keyView1, [1, 2]);
            expect(keyView2, [1, 2]);
          });
        });
        group('asMap', () {
          test('access', () {
            final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
            final mapView = map.asMap();
            expect(mapView['b'], [2, 3]);
            mapView['b'] = {4, 5, 6};
            expect(map['b'], [4, 5, 6]);
            expect(mapView['b'], [4, 5, 6]);
          });
          test('clear', () {
            final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
            final mapView = map.asMap();
            mapView.clear();
            expect(map, isEmpty);
            expect(mapView, isEmpty);
          });
          test('remove', () {
            final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
            final mapView = map.asMap();
            mapView.remove('b');
            expect(map.keys, ['a']);
            expect(mapView.keys, ['a']);
          });
        });
        test('toString', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          expect(map.toString(), '{a: {1}, b: {2, 3}}');
        });
      });
    });
  });
  group('multiset', () {
    group('constructor', () {
      test('empty', () {
        final set = Multiset();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('empty identity', () {
        final set = Multiset.identity();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('of one unique', () {
        final set = Multiset.of(['a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('of many unique', () {
        final set = Multiset.of(['a', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('of one repeated', () {
        final set = Multiset.of(['a', 'a', 'a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([3]));
      });
      test('of many repeated', () {
        final set = Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('of set', () {
        final set = Multiset.of({'a', 'b', 'c'});
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('from many repeated', () {
        final set = Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('copy', () {
        final set = Multiset.of(Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate', () {
        final set = Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with key', () {
        final set = Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c'],
            key: (e) => (e as String).codeUnitAt(0));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
        expect(set.distinct, unorderedEquals([97, 98, 99]));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with count', () {
        final set = Multiset.fromIterable(['aaa', 'bb', 'c'],
            key: (e) => (e as String).substring(0, 1),
            count: (e) => (e as String).length);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('convert', () {
        final set = ['a', 'a', 'a', 'b', 'b', 'c'].toMultiset();
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
    });
    group('adding', () {
      test('zero', () {
        final set = Multiset()
          ..add('a', 0)
          ..add('b', 0);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('single', () {
        final set = Multiset()
          ..add('a')
          ..add('b')
          ..add('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        final set = Multiset()
          ..add('a', 2)
          ..add('b', 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('all', () {
        final set = Multiset()..addAll(['a', 'a', 'b', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('error', () {
        final set = Multiset();
        expect(() => set.add('a', -1), throwsArgumentError);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
    });
    group('removing', () {
      test('zero', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set
          ..remove('a', 0)
          ..remove('b', 0);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('single', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set
          ..remove('a')
          ..remove('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set
          ..remove('a', 3)
          ..remove('b', 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['b']));
        expect(set.distinct, unorderedEquals(['b']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('all', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set.removeAll(['a', 'b', 'b', 123, null]);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 1]));
      });
      test('clear', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set.clear();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('invalid', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('c'), returnsNormally);
        expect(() => set.remove('z'), returnsNormally);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('error', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('a', -1), throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('access', () {
      test('single', () {
        final set = Multiset();
        set['a'] = 2;
        expect(set['a'], 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('multiple', () {
        final set = Multiset();
        set['a'] = 2;
        set['b'] = 3;
        expect(set['a'], 2);
        expect(set['b'], 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('remove', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set['b'] = 0;
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('error', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set['a'] = -1, throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('operator', () {
      final firstList = ['a', 'b', 'c', 'c'];
      final firstSet = Multiset.of(firstList);
      final secondList = ['a', 'c', 'd', 'd'];
      final secondSet = Multiset.of(secondList);
      test('contains', () {
        expect(firstSet.contains('a'), isTrue);
        expect(firstSet.contains('b'), isTrue);
        expect(firstSet.contains('c'), isTrue);
        expect(firstSet.contains('d'), isFalse);
      });
      test('containsAll', () {
        expect(firstSet.containsAll(firstSet), isTrue);
        expect(firstSet.containsAll(secondSet), isFalse);
        expect(firstSet.containsAll(Multiset()), isTrue);
        expect(firstSet.containsAll(Multiset.of(['a', 'b', 'b'])), isFalse);
        expect(firstSet.containsAll(Multiset.of(['a', 'b', 'd'])), isFalse);
      });
      test('containsAll (iterable)', () {
        expect(firstSet.containsAll(firstList), isTrue);
        expect(firstSet.containsAll(secondList), isFalse);
        expect(firstSet.containsAll([]), isTrue);
        expect(firstSet.containsAll(['a']), isTrue);
        expect(firstSet.containsAll(['x']), isFalse);
        expect(firstSet.containsAll(['a', 'b', 'b']), isFalse);
        expect(firstSet.containsAll(['a', 'b', 'd']), isFalse);
        expect(firstSet.containsAll([1, 2]), isFalse);
        expect(firstSet.containsAll(['a', null]), isFalse);
      });
      test('intersection', () {
        expect(firstSet.intersection(secondSet), unorderedEquals(['a', 'c']));
        expect(firstSet.intersection(secondSet).distinct,
            unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstSet), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstSet).distinct,
            unorderedEquals(['a', 'c']));
      });
      test('intersection (iterable)', () {
        expect(firstSet.intersection(secondList), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstList), unorderedEquals(['a', 'c']));
        expect(firstSet.intersection(['a', 1, null]), unorderedEquals(['a']));
      });
      test('union', () {
        expect(firstSet.union(secondSet),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(firstSet.union(secondSet).distinct,
            unorderedEquals(['a', 'b', 'c', 'd']));
        expect(secondSet.union(firstSet),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(secondSet.union(firstSet).distinct,
            unorderedEquals(['a', 'b', 'c', 'd']));
      });
      test('union (iterable)', () {
        expect(firstSet.union(secondList),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(secondSet.union(firstList),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
      });
      test('difference', () {
        expect(firstSet.difference(secondSet), unorderedEquals(['b', 'c']));
        expect(firstSet.difference(secondSet).distinct,
            unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstSet), unorderedEquals(['d', 'd']));
        expect(secondSet.difference(firstSet).distinct, unorderedEquals(['d']));
      });
      test('difference (iterable)', () {
        expect(firstSet.difference(secondList), unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstList), unorderedEquals(['d', 'd']));
        expect(firstSet.difference(['a', 1, null]),
            unorderedEquals(['b', 'c', 'c']));
      });
    });
  });
  group('range', () {
    void verify<T extends num>(Range<T> range,
        {required List<T> included, required List<T> excluded}) {
      expect(range, included);
      expect(range.length, included.length);
      if (included.isEmpty) {
        expect(range.isEmpty, isTrue);
      } else {
        expect(range.isNotEmpty, isTrue);
        expect(range.start, included.first);
        if (range.step > 0) {
          expect(range.start, lessThanOrEqualTo(range.end));
        } else {
          expect(range.start, greaterThanOrEqualTo(range.end));
        }
      }
      expect(range.reversed, included.reversed);
      for (var each in included.indexed()) {
        expect(each.value, range[each.index]);
        expect(range.contains(each.value), isTrue);
        expect(range.indexOf(each.value), each.index);
        expect(range.indexOf(each.value, each.index), each.index);
        expect(range.indexOf(each.value, -1), each.index);
        expect(range.lastIndexOf(each.value), each.index);
        expect(range.lastIndexOf(each.value, each.index), each.index);
        expect(range.lastIndexOf(each.value, included.length), each.index);
      }
      for (var value in excluded) {
        expect(range.contains(value), isFalse);
        expect(range.indexOf(value), -1);
        expect(range.indexOf(value, 0), -1);
        expect(range.indexOf(value, range.length), -1);
        expect(range.lastIndexOf(value), -1);
        expect(range.lastIndexOf(value, 0), -1);
        expect(range.lastIndexOf(value, range.length), -1);
      }
      expect(() => range[-1], throwsRangeError);
      expect(() => range[included.length], throwsRangeError);
    }

    group('int', () {
      group('constructor', () {
        test('empty', () {
          verify<int>(IntegerRange(), included: [], excluded: [0]);
        });
        test('1 argument', () {
          verify<int>(IntegerRange(0), included: [], excluded: [-1, 0, 1]);
          verify<int>(IntegerRange(1), included: [0], excluded: [-1, 1]);
          verify<int>(IntegerRange(2), included: [0, 1], excluded: [-1, 2]);
          verify<int>(IntegerRange(3), included: [0, 1, 2], excluded: [-1, 3]);
        });
        test('2 argument', () {
          verify<int>(IntegerRange(0, 4),
              included: [0, 1, 2, 3], excluded: [-1, 4]);
          verify<int>(IntegerRange(5, 9),
              included: [5, 6, 7, 8], excluded: [4, 9]);
          verify<int>(IntegerRange(9, 5),
              included: [9, 8, 7, 6], excluded: [10, 5]);
        });
        test('3 argument (positive step)', () {
          verify<int>(IntegerRange(2, 8, 2),
              included: [2, 4, 6], excluded: [0, 1, 3, 5, 7, 8]);
          verify<int>(IntegerRange(3, 8, 2),
              included: [3, 5, 7], excluded: [1, 2, 4, 6, 8, 9]);
          verify<int>(IntegerRange(4, 8, 2),
              included: [4, 6], excluded: [2, 3, 5, 7, 8]);
          verify<int>(IntegerRange(2, 7, 2),
              included: [2, 4, 6], excluded: [0, 1, 3, 5, 7, 8]);
          verify<int>(IntegerRange(2, 6, 2),
              included: [2, 4], excluded: [0, 1, 3, 5, 6, 7, 8]);
        });
        test('3 argument (negative step)', () {
          verify<int>(IntegerRange(8, 2, -2),
              included: [8, 6, 4], excluded: [2, 3, 5, 7, 9, 10]);
          verify<int>(IntegerRange(8, 3, -2),
              included: [8, 6, 4], excluded: [2, 3, 5, 7, 9, 10]);
          verify<int>(IntegerRange(8, 4, -2),
              included: [8, 6], excluded: [2, 3, 4, 5, 7, 9, 10]);
          verify<int>(IntegerRange(7, 2, -2),
              included: [7, 5, 3], excluded: [1, 2, 4, 6, 8, 9]);
          verify<int>(IntegerRange(6, 2, -2),
              included: [6, 4], excluded: [2, 3, 5, 7, 8, 9]);
        });
        test('shorthand', () {
          verify<int>(0.to(3), included: [0, 1, 2], excluded: [-1, 4]);
          verify<int>(2.to(8, step: 2),
              included: [2, 4, 6], excluded: [0, 1, 3, 5, 7, 8]);
        });
        test('invalid', () {
          expect(() => IntegerRange(0, 2, 0), throwsArgumentError);
          expect(() => IntegerRange(0, 2, -1), throwsArgumentError);
          expect(() => IntegerRange(2, 0, 1), throwsArgumentError);
        });
        group('indices', () {
          test('empty', () {
            verify<int>([].indices(), included: [], excluded: [0, 1, 2]);
            verify<int>([].indices(step: -1),
                included: [], excluded: [0, 1, 2]);
            expect(() => [].indices(step: 0), throwsArgumentError);
          });
          test('default', () {
            verify<int>([1, 2, 3].indices(),
                included: [0, 1, 2], excluded: [-1, 3]);
            verify<int>([1, 2, 3].indices(step: -1),
                included: [2, 1, 0], excluded: [-1, 3]);
            expect(() => [1, 2, 3].indices(step: 0), throwsArgumentError);
          });
          test('step', () {
            verify<int>([1, 2, 3].indices(step: 2),
                included: [0, 2], excluded: [-1, 1, 3]);
            verify<int>([1, 2, 3, 4].indices(step: 2),
                included: [0, 2], excluded: [-1, 1, 3]);
            verify<int>([1, 2, 3].indices(step: -2),
                included: [2, 0], excluded: [-1, 1, 3]);
            verify<int>([1, 2, 3, 4].indices(step: -2),
                included: [3, 1], excluded: [0, 2, 4, 6]);
          });
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify<int>(IntegerRange(3).sublist(0),
              included: [0, 1, 2], excluded: [-1, 3]);
          verify<int>(IntegerRange(3).sublist(1),
              included: [1, 2], excluded: [-1, 0, 3]);
          verify<int>(IntegerRange(3).sublist(2),
              included: [2], excluded: [-1, 0, 1, 3]);
          verify<int>(IntegerRange(3).sublist(3),
              included: [], excluded: [-1, 0, 1, 2, 3]);
          expect(() => IntegerRange(3).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify<int>(IntegerRange(3).sublist(0, 3),
              included: [0, 1, 2], excluded: [-1, 3]);
          verify<int>(IntegerRange(3).sublist(0, 2),
              included: [0, 1], excluded: [-1, 2, 3]);
          verify<int>(IntegerRange(3).sublist(0, 1),
              included: [0], excluded: [-1, 1, 2, 3]);
          verify<int>(IntegerRange(3).sublist(0, 0),
              included: [], excluded: [-1, 0, 1, 2, 3]);
          expect(() => IntegerRange(3).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verify<int>(IntegerRange(3).getRange(0, 3),
              included: [0, 1, 2], excluded: [-1, 3]);
          verify<int>(IntegerRange(3).getRange(0, 2),
              included: [0, 1], excluded: [-1, 2, 3]);
          verify<int>(IntegerRange(3).getRange(0, 1),
              included: [0], excluded: [-1, 1, 2, 3]);
          verify<int>(IntegerRange(3).getRange(0, 0),
              included: [], excluded: [-1, 0, 1, 2, 3]);
          expect(() => IntegerRange(3).getRange(0, 4), throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          final r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1), -1);
          expect(r.indexOf(2), 0);
          expect(r.indexOf(3), -1);
          expect(r.indexOf(4), 1);
          expect(r.indexOf(5), -1);
          expect(r.indexOf(6), 2);
          expect(r.indexOf(7), -1);
          expect(r.indexOf(8), -1);
          expect(r.indexOf(2, 0), 0);
          expect(r.indexOf(2, 1), -1);
          expect(r.indexOf(4, 1), 1);
          expect(r.indexOf(4, 2), -1);
          expect(r.indexOf(6, 2), 2);
          expect(r.indexOf(6, 3), -1);
        });
        test('contains (positive step)', () {
          final r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.contains(null), isFalse);
          expect(r.contains(0), isFalse);
          expect(r.contains(1), isFalse);
          expect(r.contains(2), isTrue);
          expect(r.contains(3), isFalse);
          expect(r.contains(4), isTrue);
          expect(r.contains(5), isFalse);
          expect(r.contains(6), isTrue);
          expect(r.contains(7), isFalse);
          expect(r.contains(8), isFalse);
        });
        test('indexOf (negative step)', () {
          final r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(0), -1);
          expect(r.indexOf(1), -1);
          expect(r.indexOf(2), -1);
          expect(r.indexOf(3), 2);
          expect(r.indexOf(4), -1);
          expect(r.indexOf(5), 1);
          expect(r.indexOf(6), -1);
          expect(r.indexOf(7), 0);
          expect(r.indexOf(8), -1);
          expect(r.indexOf(9), -1);
          expect(r.indexOf(3, 2), 2);
          expect(r.indexOf(3, 3), -1);
          expect(r.indexOf(5, 1), 1);
          expect(r.indexOf(5, 2), -1);
          expect(r.indexOf(7, 0), 0);
          expect(r.indexOf(7, 1), -1);
        });
        test('contains (negative step)', () {
          final r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.contains(null), isFalse);
          expect(r.contains(0), isFalse);
          expect(r.contains(1), isFalse);
          expect(r.contains(2), isFalse);
          expect(r.contains(3), isTrue);
          expect(r.contains(4), isFalse);
          expect(r.contains(5), isTrue);
          expect(r.contains(6), isFalse);
          expect(r.contains(7), isTrue);
          expect(r.contains(8), isFalse);
          expect(r.contains(9), isFalse);
        });
        test('lastIndexOf (positive step)', () {
          final r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(0), -1);
          expect(r.lastIndexOf(1), -1);
          expect(r.lastIndexOf(2), 0);
          expect(r.lastIndexOf(3), -1);
          expect(r.lastIndexOf(4), 1);
          expect(r.lastIndexOf(5), -1);
          expect(r.lastIndexOf(6), 2);
          expect(r.lastIndexOf(7), -1);
          expect(r.lastIndexOf(8), -1);
          expect(r.lastIndexOf(2, 0), 0);
          expect(r.lastIndexOf(2, -1), -1);
          expect(r.lastIndexOf(4, 1), 1);
          expect(r.lastIndexOf(4, 0), -1);
          expect(r.lastIndexOf(6, 2), 2);
          expect(r.lastIndexOf(6, 1), -1);
        });
        test('lastIndexOf (negative step)', () {
          final r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(1), -1);
          expect(r.lastIndexOf(2), -1);
          expect(r.lastIndexOf(3), 2);
          expect(r.lastIndexOf(4), -1);
          expect(r.lastIndexOf(5), 1);
          expect(r.lastIndexOf(6), -1);
          expect(r.lastIndexOf(7), 0);
          expect(r.lastIndexOf(8), -1);
          expect(r.lastIndexOf(8), -1);
          expect(r.lastIndexOf(3, 2), 2);
          expect(r.lastIndexOf(3, 1), -1);
          expect(r.lastIndexOf(5, 1), 1);
          expect(r.lastIndexOf(5, 0), -1);
          expect(r.lastIndexOf(7, 0), 0);
          expect(r.lastIndexOf(7, -1), -1);
        });
      });
      test('printing', () {
        expect(IntegerRange().toString(), 'IntegerRange()');
        expect(IntegerRange(1).toString(), 'IntegerRange(1)');
        expect(IntegerRange(1, 2).toString(), 'IntegerRange(1, 2)');
        expect(IntegerRange(1, 5, 2).toString(), 'IntegerRange(1, 5, 2)');
      });
      test('unmodifiable', () {
        final list = IntegerRange(1, 5);
        expect(() => list[0] = 5, throwsUnsupportedError);
        expect(() => list.add(5), throwsUnsupportedError);
        expect(() => list.addAll([5, 6]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.fillRange(2, 4, 5), throwsUnsupportedError);
        expect(() => list.insert(2, 5), throwsUnsupportedError);
        expect(() => list.insertAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(5), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(() => list.replaceRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(() => list.shuffle(), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
    group('double', () {
      group('constructor', () {
        test('empty', () {
          verify<double>(DoubleRange(), included: [], excluded: [0.0]);
        });
        test('1 argument', () {
          verify<double>(DoubleRange(0.0),
              included: [], excluded: [-1.0, 0.0, 1.0]);
          verify<double>(DoubleRange(1.0),
              included: [0.0], excluded: [-1.0, 1.0]);
          verify<double>(DoubleRange(2.0),
              included: [0.0, 1.0], excluded: [-1.0, 2.0]);
          verify<double>(DoubleRange(3.0),
              included: [0.0, 1.0, 2.0], excluded: [-1.0, 3.0]);
        });
        test('2 argument', () {
          verify<double>(DoubleRange(0.0, 4.0),
              included: [0.0, 1.0, 2.0, 3.0], excluded: [-1.0, 4.0]);
          verify<double>(DoubleRange(5.0, 9.0),
              included: [5.0, 6.0, 7.0, 8.0], excluded: [4.0, 9.0]);
          verify<double>(DoubleRange(9.0, 5.0),
              included: [9.0, 8.0, 7.0, 6.0], excluded: [10.0, 5.0]);
        });
        test('3 argument (positive step)', () {
          verify<double>(DoubleRange(2.0, 8.0, 1.5),
              included: [2.0, 3.5, 5.0, 6.5], excluded: [0.5, 3.0, 8.0]);
          verify<double>(DoubleRange(3.0, 8.0, 1.5),
              included: [3.0, 4.5, 6.0, 7.5], excluded: [1.5, 5.0, 9.0]);
          verify<double>(DoubleRange(4.0, 8.0, 1.5),
              included: [4.0, 5.5, 7.0], excluded: [3.5, 5.0, 6.0, 8.5]);
          verify<double>(DoubleRange(2.0, 7.0, 1.5),
              included: [2.0, 3.5, 5.0, 6.5], excluded: [0.5, 4.0, 8.0]);
          verify<double>(DoubleRange(2.0, 6.0, 1.5),
              included: [2.0, 3.5, 5.0], excluded: [0.5, 3.0, 4.0, 6.0]);
        });
        test('3 argument (negative step)', () {
          verify<double>(DoubleRange(8.0, 2.0, -1.5),
              included: [8.0, 6.5, 5.0, 3.5], excluded: [9.5, 6.0, 2.0]);
          verify<double>(DoubleRange(8.0, 3.0, -1.5),
              included: [8.0, 6.5, 5.0, 3.5], excluded: [9.5, 6.0, 2.0]);
          verify<double>(DoubleRange(8.0, 4.0, -1.5),
              included: [8.0, 6.5, 5.0], excluded: [9.5, 5.5, 3.5]);
          verify<double>(DoubleRange(7.0, 2.0, -1.5),
              included: [7.0, 5.5, 4.0, 2.5], excluded: [8.5, 3.0, 2.0]);
          verify<double>(DoubleRange(6.0, 2.0, -1.5),
              included: [6.0, 4.5, 3.0], excluded: [7.5, 4.0, 1.5]);
        });
        test('shorthand', () {
          verify<double>(0.0.to(3.0),
              included: [0.0, 1.0, 2.0], excluded: [-1.0, 0.5, 1.5, 2.5, 3.0]);
          verify<double>(4.0.to(8.0, step: 1.5),
              included: [4.0, 5.5, 7.0], excluded: [2.5, 5.0, 6.0, 8.5]);
        });
        test('invalid', () {
          expect(() => DoubleRange(0.0, 2.0, 0.0), throwsArgumentError);
          expect(() => DoubleRange(0.0, 2.0, -1.5), throwsArgumentError);
          expect(() => DoubleRange(2.0, 0.0, 1.5), throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify<double>(DoubleRange(3.0).sublist(0),
              included: [0.0, 1.0, 2.0], excluded: [-1.0, 3.0]);
          verify<double>(DoubleRange(3.0).sublist(1),
              included: [1.0, 2.0], excluded: [-1.0, 0.0, 3.0]);
          verify<double>(DoubleRange(3.0).sublist(2),
              included: [2.0], excluded: [-1.0, 0.0, 1.0, 3.0]);
          verify<double>(DoubleRange(3.0).sublist(3),
              included: [], excluded: [-1.0, 0.0, 1.0, 2.0, 3.0]);
          expect(() => DoubleRange(3.0).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify<double>(DoubleRange(3.0).sublist(0, 3),
              included: [0.0, 1.0, 2.0], excluded: [-1.0, 3.0]);
          verify<double>(DoubleRange(3.0).sublist(0, 2),
              included: [0.0, 1.0], excluded: [-1.0, 2.0, 3.0]);
          verify<double>(DoubleRange(3.0).sublist(0, 1),
              included: [0.0], excluded: [-1.0, 1.0, 2.0, 3.0]);
          verify<double>(DoubleRange(3.0).sublist(0, 0),
              included: [], excluded: [-1.0, 0.0, 1.0, 2.0, 3.0]);
          expect(() => DoubleRange(3.0).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verify<double>(DoubleRange(3.0).getRange(0, 3),
              included: [0.0, 1.0, 2.0], excluded: []);
          verify<double>(DoubleRange(3.0).getRange(0, 2),
              included: [0.0, 1.0], excluded: []);
          verify<double>(DoubleRange(3.0).getRange(0, 1),
              included: [0.0], excluded: []);
          verify<double>(DoubleRange(3.0).getRange(0, 0),
              included: [], excluded: []);
          expect(() => DoubleRange(3.0).getRange(0, 4), throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          final r = DoubleRange(2.0, 7.0, 1.5); // [2.0, 3.5, 5.0, 6.5]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1.0), -1);
          expect(r.indexOf(2.0), 0);
          expect(r.indexOf(3.0), -1);
          expect(r.indexOf(3.5), 1);
          expect(r.indexOf(7.0), -1);
          expect(r.indexOf(5.0), 2);
          expect(r.indexOf(6.0), -1);
          expect(r.indexOf(6.5), 3);
          expect(r.indexOf(8.0), -1);
          expect(r.indexOf(2.0, 0), 0);
          expect(r.indexOf(2.0, 1), -1);
          expect(r.indexOf(3.5, 1), 1);
          expect(r.indexOf(3.5, 2), -1);
          expect(r.indexOf(5.0, 2), 2);
          expect(r.indexOf(5.0, 3), -1);
          expect(r.indexOf(6.5, 3), 3);
          expect(r.indexOf(6.5, 4), -1);
        });
        test('indexOf (negative step)', () {
          final r = DoubleRange(7.0, 2.0, -1.5); // [7.0, 5.5, 4.0, 2.5]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1.0), -1);
          expect(r.indexOf(2.5), 3);
          expect(r.indexOf(3.5), -1);
          expect(r.indexOf(4.0), 2);
          expect(r.indexOf(4.0), 2);
          expect(r.indexOf(4.0), 2);
          expect(r.indexOf(4.0), 2);

          expect(r.indexOf(8.0), -1);
          expect(r.indexOf(7.0, 1), -1);
          expect(r.indexOf(5.5, 2), -1);
          expect(r.indexOf(4.0, 3), -1);
          expect(r.indexOf(2.5, 4), -1);
        });
        test('lastIndexOf (positive step)', () {
          final r = DoubleRange(2.0, 7.0, 1.5); // [2.0, 3.5, 5.0, 6.5]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(1.0), -1);
          expect(r.lastIndexOf(3.0), -1);
          expect(r.lastIndexOf(7.0), -1);
          expect(r.lastIndexOf(2.0, -1), -1);
          expect(r.lastIndexOf(3.5, 0), -1);
          expect(r.lastIndexOf(5.0, 1), -1);
          expect(r.lastIndexOf(6.5, 2), -1);
          expect(r.lastIndexOf(7.0, 3), -1);
          expect(r.lastIndexOf(8.5, 4), -1);
        });
        test('lastIndexOf (negative step)', () {
          final r = DoubleRange(7.0, 2.0, -1.5); // [7.0, 5.5, 4.0, 2.5]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(2.0), -1);
          expect(r.lastIndexOf(5.0), -1);
          expect(r.lastIndexOf(8.0), -1);
          expect(r.lastIndexOf(7.0, -1), -1);
          expect(r.lastIndexOf(5.5, 0), -1);
          expect(r.lastIndexOf(4.0, 1), -1);
          expect(r.lastIndexOf(2.5, 2), -1);
          expect(r.lastIndexOf(1.0, 3), -1);
          expect(r.lastIndexOf(0.0, 4), -1);
        });
      });
      test('printing', () {
        expect(DoubleRange().toString(), 'DoubleRange()');
        expect(DoubleRange(1.2).toString(), 'DoubleRange(1.2)');
        expect(DoubleRange(1.2, 3.4).toString(), 'DoubleRange(1.2, 3.4)');
        expect(DoubleRange(1.2, 3.4, 0.5).toString(),
            'DoubleRange(1.2, 3.4, 0.5)');
      });
      test('unmodifiable', () {
        final list = DoubleRange(1.0, 5.0);
        expect(() => list[0] = 5.0, throwsUnsupportedError);
        expect(() => list.add(5.0), throwsUnsupportedError);
        expect(() => list.addAll([5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.fillRange(2, 4, 5.0), throwsUnsupportedError);
        expect(() => list.insert(2, 5.0), throwsUnsupportedError);
        expect(() => list.insertAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(5.0), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(
            () => list.replaceRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
    group('BigInt', () {
      void verify(List<BigInt> range, List/*<int|BigInt>*/ expected) {
        final normalized = expected
            .map((value) => value is BigInt ? value : BigInt.from(value))
            .cast<BigInt>()
            .toList(growable: false);
        expect(range, normalized);
        expect(range.reversed, normalized.reversed);
        final iterator = range.iterator;
        for (var i = 0; i < normalized.length; i++) {
          expect(iterator.moveNext(), isTrue);
          expect(iterator.current, range[i]);
          expect(range.contains(iterator.current), isTrue);
          expect(range.indexOf(iterator.current), i);
          expect(range.indexOf(iterator.current, i), i);
          expect(range.indexOf(iterator.current, -1), i);
          expect(range.lastIndexOf(iterator.current), i);
          expect(range.lastIndexOf(iterator.current, i), i);
          expect(range.lastIndexOf(iterator.current, expected.length), i);
        }
        expect(iterator.moveNext(), isFalse);
        expect(() => range[-1], throwsRangeError);
        expect(() => range[normalized.length], throwsRangeError);
        for (final value in normalized) {
          expect(range.contains(value), isTrue);
        }
      }

      group('constructor', () {
        test('empty', () {
          verify(BigIntRange(), []);
          expect(BigIntRange().contains(BigInt.one), isFalse);
        });
        test('1 argument', () {
          verify(BigIntRange(BigInt.from(0)), []);
          verify(BigIntRange(BigInt.from(1)), [0]);
          verify(BigIntRange(BigInt.from(2)), [0, 1]);
          verify(BigIntRange(BigInt.from(3)), [0, 1, 2]);
        });
        test('2 argument', () {
          verify(BigIntRange(BigInt.from(0), BigInt.from(4)), [0, 1, 2, 3]);
          verify(BigIntRange(BigInt.from(5), BigInt.from(9)), [5, 6, 7, 8]);
          verify(BigIntRange(BigInt.from(9), BigInt.from(5)), [9, 8, 7, 6]);
        });
        test('3 argument (positive step)', () {
          verify(BigIntRange(BigInt.from(2), BigInt.from(8), BigInt.two),
              [2, 4, 6]);
          verify(BigIntRange(BigInt.from(3), BigInt.from(8), BigInt.two),
              [3, 5, 7]);
          verify(
              BigIntRange(BigInt.from(4), BigInt.from(8), BigInt.two), [4, 6]);
          verify(BigIntRange(BigInt.from(2), BigInt.from(7), BigInt.two),
              [2, 4, 6]);
          verify(
              BigIntRange(BigInt.from(2), BigInt.from(6), BigInt.two), [2, 4]);
        });
        test('3 argument (negative step)', () {
          verify(BigIntRange(BigInt.from(8), BigInt.from(2), -BigInt.two),
              [8, 6, 4]);
          verify(BigIntRange(BigInt.from(8), BigInt.from(3), -BigInt.two),
              [8, 6, 4]);
          verify(
              BigIntRange(BigInt.from(8), BigInt.from(4), -BigInt.two), [8, 6]);
          verify(BigIntRange(BigInt.from(7), BigInt.from(2), -BigInt.two),
              [7, 5, 3]);
          verify(
              BigIntRange(BigInt.from(6), BigInt.from(2), -BigInt.two), [6, 4]);
        });
        test('shorthand', () {
          verify(BigInt.zero.to(BigInt.from(3)), [0, 1, 2]);
          verify(BigInt.two.to(BigInt.from(8), step: BigInt.two), [2, 4, 6]);
        });
        test('invalid', () {
          expect(() => BigIntRange(BigInt.zero, BigInt.two, BigInt.zero),
              throwsArgumentError);
          expect(() => BigIntRange(BigInt.zero, BigInt.two, -BigInt.one),
              throwsArgumentError);
          expect(() => BigIntRange(BigInt.two, BigInt.zero, BigInt.one),
              throwsArgumentError);
          expect(() => BigIntRange(BigInt.zero, BigInt.two.pow(100)),
              throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify(BigIntRange(BigInt.from(3)).sublist(0), [0, 1, 2]);
          verify(BigIntRange(BigInt.from(3)).sublist(1), [1, 2]);
          verify(BigIntRange(BigInt.from(3)).sublist(2), [2]);
          verify(BigIntRange(BigInt.from(3)).sublist(3), []);
          expect(
              () => BigIntRange(BigInt.from(3)).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify(BigIntRange(BigInt.from(3)).sublist(0, 3), [0, 1, 2]);
          verify(BigIntRange(BigInt.from(3)).sublist(0, 2), [0, 1]);
          verify(BigIntRange(BigInt.from(3)).sublist(0, 1), [0]);
          verify(BigIntRange(BigInt.from(3)).sublist(0, 0), []);
          expect(() => BigIntRange(BigInt.from(3)).sublist(0, 4),
              throwsRangeError);
        });
        test('getRange', () {
          verify(
              BigIntRange(BigInt.from(3)).getRange(0, 3).toList(), [0, 1, 2]);
          verify(BigIntRange(BigInt.from(3)).getRange(0, 2).toList(), [0, 1]);
          verify(BigIntRange(BigInt.from(3)).getRange(0, 1).toList(), [0]);
          verify(BigIntRange(BigInt.from(3)).getRange(0, 0).toList(), []);
          expect(() => BigIntRange(BigInt.from(3)).getRange(0, 4),
              throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          final r = BigIntRange(
              BigInt.from(2), BigInt.from(7), BigInt.from(2)); // [2, 4, 6]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(BigInt.from(1)), -1);
          expect(r.indexOf(BigInt.from(2)), 0);
          expect(r.indexOf(BigInt.from(3)), -1);
          expect(r.indexOf(BigInt.from(4)), 1);
          expect(r.indexOf(BigInt.from(5)), -1);
          expect(r.indexOf(BigInt.from(6)), 2);
          expect(r.indexOf(BigInt.from(7)), -1);
          expect(r.indexOf(BigInt.from(8)), -1);
          expect(r.indexOf(BigInt.from(2), 0), 0);
          expect(r.indexOf(BigInt.from(2), 1), -1);
          expect(r.indexOf(BigInt.from(4), 1), 1);
          expect(r.indexOf(BigInt.from(4), 2), -1);
          expect(r.indexOf(BigInt.from(6), 2), 2);
          expect(r.indexOf(BigInt.from(6), 3), -1);
        });
        test('contains (positive step)', () {
          final r = BigIntRange(
              BigInt.from(2), BigInt.from(7), BigInt.from(2)); // [2, 4, 6]
          expect(r.contains(null), isFalse);
          expect(r.contains(BigInt.from(0)), isFalse);
          expect(r.contains(BigInt.from(1)), isFalse);
          expect(r.contains(BigInt.from(2)), isTrue);
          expect(r.contains(BigInt.from(3)), isFalse);
          expect(r.contains(BigInt.from(4)), isTrue);
          expect(r.contains(BigInt.from(5)), isFalse);
          expect(r.contains(BigInt.from(6)), isTrue);
          expect(r.contains(BigInt.from(7)), isFalse);
          expect(r.contains(BigInt.from(8)), isFalse);
        });
        test('indexOf (negative step)', () {
          final r = BigIntRange(
              BigInt.from(7), BigInt.from(2), BigInt.from(-2)); // [7, 5, 3]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(BigInt.from(0)), -1);
          expect(r.indexOf(BigInt.from(1)), -1);
          expect(r.indexOf(BigInt.from(2)), -1);
          expect(r.indexOf(BigInt.from(3)), 2);
          expect(r.indexOf(BigInt.from(4)), -1);
          expect(r.indexOf(BigInt.from(5)), 1);
          expect(r.indexOf(BigInt.from(6)), -1);
          expect(r.indexOf(BigInt.from(7)), 0);
          expect(r.indexOf(BigInt.from(8)), -1);
          expect(r.indexOf(BigInt.from(9)), -1);
          expect(r.indexOf(BigInt.from(3), 2), 2);
          expect(r.indexOf(BigInt.from(3), 3), -1);
          expect(r.indexOf(BigInt.from(5), 1), 1);
          expect(r.indexOf(BigInt.from(5), 2), -1);
          expect(r.indexOf(BigInt.from(7), 0), 0);
          expect(r.indexOf(BigInt.from(7), 1), -1);
        });
        test('contains (negative step)', () {
          final r = BigIntRange(
              BigInt.from(7), BigInt.from(2), BigInt.from(-2)); // [7, 5, 3]
          expect(r.contains(null), isFalse);
          expect(r.contains(BigInt.from(0)), isFalse);
          expect(r.contains(BigInt.from(1)), isFalse);
          expect(r.contains(BigInt.from(2)), isFalse);
          expect(r.contains(BigInt.from(3)), isTrue);
          expect(r.contains(BigInt.from(4)), isFalse);
          expect(r.contains(BigInt.from(5)), isTrue);
          expect(r.contains(BigInt.from(6)), isFalse);
          expect(r.contains(BigInt.from(7)), isTrue);
          expect(r.contains(BigInt.from(8)), isFalse);
          expect(r.contains(BigInt.from(9)), isFalse);
        });
        test('lastIndexOf (positive step)', () {
          final r = BigIntRange(
              BigInt.from(2), BigInt.from(7), BigInt.from(2)); // [2, 4, 6]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(BigInt.from(0)), -1);
          expect(r.lastIndexOf(BigInt.from(1)), -1);
          expect(r.lastIndexOf(BigInt.from(2)), 0);
          expect(r.lastIndexOf(BigInt.from(3)), -1);
          expect(r.lastIndexOf(BigInt.from(4)), 1);
          expect(r.lastIndexOf(BigInt.from(5)), -1);
          expect(r.lastIndexOf(BigInt.from(6)), 2);
          expect(r.lastIndexOf(BigInt.from(7)), -1);
          expect(r.lastIndexOf(BigInt.from(8)), -1);
          expect(r.lastIndexOf(BigInt.from(2), 0), 0);
          expect(r.lastIndexOf(BigInt.from(2), -1), -1);
          expect(r.lastIndexOf(BigInt.from(4), 1), 1);
          expect(r.lastIndexOf(BigInt.from(4), 0), -1);
          expect(r.lastIndexOf(BigInt.from(6), 2), 2);
          expect(r.lastIndexOf(BigInt.from(6), 1), -1);
        });
        test('lastIndexOf (negative step)', () {
          final r = BigIntRange(
              BigInt.from(7), BigInt.from(2), BigInt.from(-2)); // [7, 5, 3]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(BigInt.from(1)), -1);
          expect(r.lastIndexOf(BigInt.from(2)), -1);
          expect(r.lastIndexOf(BigInt.from(3)), 2);
          expect(r.lastIndexOf(BigInt.from(4)), -1);
          expect(r.lastIndexOf(BigInt.from(5)), 1);
          expect(r.lastIndexOf(BigInt.from(6)), -1);
          expect(r.lastIndexOf(BigInt.from(7)), 0);
          expect(r.lastIndexOf(BigInt.from(8)), -1);
          expect(r.lastIndexOf(BigInt.from(8)), -1);
          expect(r.lastIndexOf(BigInt.from(3), 2), 2);
          expect(r.lastIndexOf(BigInt.from(3), 1), -1);
          expect(r.lastIndexOf(BigInt.from(5), 1), 1);
          expect(r.lastIndexOf(BigInt.from(5), 0), -1);
          expect(r.lastIndexOf(BigInt.from(7), 0), 0);
          expect(r.lastIndexOf(BigInt.from(7), -1), -1);
        });
      });
      test('printing', () {
        expect(BigIntRange().toString(), 'BigIntRange()');
        expect(BigIntRange(BigInt.from(1)).toString(), 'BigIntRange(1)');
        expect(BigIntRange(BigInt.from(1), BigInt.from(2)).toString(),
            'BigIntRange(1, 2)');
        expect(
            BigIntRange(BigInt.from(1), BigInt.from(5), BigInt.from(2))
                .toString(),
            'BigIntRange(1, 5, 2)');
      });
      test('unmodifiable', () {
        final list = BigIntRange(BigInt.from(1), BigInt.from(5));
        expect(() => list[0] = BigInt.from(5), throwsUnsupportedError);
        expect(() => list.add(BigInt.from(5)), throwsUnsupportedError);
        expect(() => list.addAll(list), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(
            () => list.fillRange(2, 4, BigInt.from(5)), throwsUnsupportedError);
        expect(() => list.insert(2, BigInt.from(5)), throwsUnsupportedError);
        expect(() => list.insertAll(2, list), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(BigInt.one), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(() => list.replaceRange(2, 4, list), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, list), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, list), throwsUnsupportedError);
        expect(() => list.shuffle(), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
  });
  group('sortedlist', () {
    group('default constructor', () {
      allSortedListTests(<E>(Iterable<E> elements,
              {Comparator<E>? comparator}) =>
          SortedList<E>(comparator: comparator)..addAll(elements));
    });
    group('iterable constructor', () {
      allSortedListTests(<E>(Iterable<E> elements,
              {Comparator<E>? comparator}) =>
          SortedList<E>.of(elements, comparator: comparator));
    });
    group('converting constructor', () {
      allSortedListTests(<E>(Iterable<E> elements,
              {Comparator<E>? comparator}) =>
          elements.toSortedList(comparator: comparator));
    });
  });
  group('string', () {
    group('immutable', () {
      final empty = ''.toList();
      final plenty = 'More Dart'.toList();
      test('creating', () {
        final coerced = '123'.toList();
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmpty', () {
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
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'M', 'o', 'r', 'e', ' ', 'D', 'a', 't'});
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('read-only', () {
        expect(() => plenty[0] = 'a', throwsUnsupportedError);
        expect(() => plenty.length = 10, throwsUnsupportedError);
        expect(() => plenty.add('a'), throwsUnsupportedError);
        expect(() => plenty.remove('a'), throwsUnsupportedError);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
            plenty.sublist(5, 7).toString(), plenty.toString().substring(5, 7));
      });
    });
    group('mutable', () {
      final empty = ''.toList(mutable: true);
      final plenty = 'More Dart'.toList(mutable: true);
      test('creating', () {
        final coerced = '123'.toList(mutable: true);
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmpty', () {
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
        final mutable = 'abc'.toList(mutable: true);
        mutable[1] = 'd';
        expect(mutable.toString(), 'adc');
      });
      test('writing (range error)', () {
        expect(() => empty[0] = 'a', throwsRangeError);
        expect(() => plenty[-1] = 'a', throwsRangeError);
        expect(() => plenty[9] = 'a', throwsRangeError);
      });
      test('writing (argument error)', () {
        expect(() => plenty[0] = 'ab', throwsArgumentError);
      });
      test('adding', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.add('d');
        expect(mutable.toString(), 'abcd');
      });
      test('removing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.remove('a');
        expect(mutable.toString(), 'bc');
      });
      test('converting', () {
        expect(empty.toList(), []);
        expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'M', 'o', 'r', 'e', ' ', 'D', 'a', 't'});
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
            plenty.sublist(5, 7).toString(), plenty.toString().substring(5, 7));
      });
    });
    group('remove prefix', () {
      test('string', () {
        expect('abcd'.removePrefix(''), 'abcd');
        expect('abcd'.removePrefix('a'), 'bcd');
        expect('abcd'.removePrefix('ab'), 'cd');
        expect('abcd'.removePrefix('abc'), 'd');
        expect('abcd'.removePrefix('abcd'), '');
        expect('abcd'.removePrefix('xyz'), 'abcd');
      });
      test('regexp pattern', () {
        expect('abcd'.removePrefix(RegExp('')), 'abcd');
        expect('abcd'.removePrefix(RegExp('a')), 'bcd');
        expect('abcd'.removePrefix(RegExp('ab')), 'cd');
        expect('abcd'.removePrefix(RegExp('abc')), 'd');
        expect('abcd'.removePrefix(RegExp('abcd')), '');
        expect('abcd'.removePrefix(RegExp('xyz')), 'abcd');
      });
    });
    group('remove suffix', () {
      test('string', () {
        expect('abcd'.removeSuffix(''), 'abcd');
        expect('abcd'.removeSuffix('d'), 'abc');
        expect('abcd'.removeSuffix('cd'), 'ab');
        expect('abcd'.removeSuffix('bcd'), 'a');
        expect('abcd'.removeSuffix('abcd'), '');
        expect('abcd'.removeSuffix('xyz'), 'abcd');
      });
    });
    group('converters', () {
      test('convert first character', () {
        expect(
            ''.convertFirstCharacters((value) {
              fail('Not supposed to be called');
            }),
            '');
        expect(
            'a'.convertFirstCharacters((value) {
              expect(value, 'a');
              return 'A';
            }),
            'A');
        expect(
            'ab'.convertFirstCharacters((value) {
              expect(value, 'a');
              return 'A';
            }),
            'Ab');
        expect(
            'abc'.convertFirstCharacters((value) {
              expect(value, 'a');
              return 'A';
            }),
            'Abc');
      });
      test('convert first two characters', () {
        expect(
            ''.convertFirstCharacters((value) {
              fail('Not supposed to be called');
            }, count: 2),
            '');
        expect(
            'a'.convertFirstCharacters((value) {
              fail('Not supposed to be called');
            }, count: 2),
            'a');
        expect(
            'ab'.convertFirstCharacters((value) {
              expect(value, 'ab');
              return '*';
            }, count: 2),
            '*');
        expect(
            'abc'.convertFirstCharacters((value) {
              expect(value, 'ab');
              return '*';
            }, count: 2),
            '*c');
      });
      test('convert last character', () {
        expect(
            ''.convertLastCharacters((value) {
              fail('Not supposed to be called');
            }),
            '');
        expect(
            'a'.convertLastCharacters((value) {
              expect(value, 'a');
              return 'A';
            }),
            'A');
        expect(
            'ab'.convertLastCharacters((value) {
              expect(value, 'b');
              return 'B';
            }),
            'aB');
        expect(
            'abc'.convertLastCharacters((value) {
              expect(value, 'c');
              return 'C';
            }),
            'abC');
      });
      test('convert last two characters', () {
        expect(
            ''.convertLastCharacters((value) {
              fail('Not supposed to be called');
            }, count: 2),
            '');
        expect(
            'a'.convertLastCharacters((value) {
              fail('Not supposed to be called');
            }, count: 2),
            'a');
        expect(
            'ab'.convertLastCharacters((value) {
              expect(value, 'ab');
              return '*';
            }, count: 2),
            '*');
        expect(
            'abc'.convertLastCharacters((value) {
              expect(value, 'bc');
              return '*';
            }, count: 2),
            'a*');
      });
      test('convert first character to upper-case', () {
        expect(''.toUpperCaseFirstCharacter(), '');
        expect('a'.toUpperCaseFirstCharacter(), 'A');
        expect('ab'.toUpperCaseFirstCharacter(), 'Ab');
        expect('abc'.toUpperCaseFirstCharacter(), 'Abc');
      });
      test('convert first character to lower-case', () {
        expect(''.toLowerCaseFirstCharacter(), '');
        expect('A'.toLowerCaseFirstCharacter(), 'a');
        expect('AB'.toLowerCaseFirstCharacter(), 'aB');
        expect('ABC'.toLowerCaseFirstCharacter(), 'aBC');
      });
    });
    group('indent', () {
      test('default', () {
        expect(''.indent('*'), '');
        expect('foo'.indent('*'), '*foo');
        expect('foo\nbar'.indent('*'), '*foo\n*bar');
        expect('foo\n\nbar'.indent('*'), '*foo\n\n*bar');
        expect(' zork '.indent('*'), '*zork');
      });
      test('firstPrefix', () {
        expect(''.indent('*', firstPrefix: '!'), '');
        expect('foo'.indent('*', firstPrefix: '!'), '!foo');
        expect('foo\nbar'.indent('*', firstPrefix: '!'), '!foo\n*bar');
        expect('foo\n\nbar'.indent('*', firstPrefix: '!'), '!foo\n\n*bar');
        expect(' zork '.indent('*', firstPrefix: '!'), '!zork');
      });
      test('trimWhitespace', () {
        expect(''.indent('*', trimWhitespace: false), '');
        expect('foo'.indent('*', trimWhitespace: false), '*foo');
        expect('foo\nbar'.indent('*', trimWhitespace: false), '*foo\n*bar');
        expect('foo\n\nbar'.indent('*', trimWhitespace: false), '*foo\n\n*bar');
        expect(' zork '.indent('*', trimWhitespace: false), '* zork ');
      });
      test('indentEmpty', () {
        expect(''.indent('*', indentEmpty: true), '*');
        expect('foo'.indent('*', indentEmpty: true), '*foo');
        expect('foo\nbar'.indent('*', indentEmpty: true), '*foo\n*bar');
        expect('foo\n\nbar'.indent('*', indentEmpty: true), '*foo\n*\n*bar');
        expect(' zork '.indent('*', indentEmpty: true), '*zork');
      });
    });
    group('dedent', () {
      test('default', () {
        expect(''.dedent(), '');
        expect('1\n2'.dedent(), '1\n2');
        expect('1\n\n2'.dedent(), '1\n\n2');
        expect(' 1\n\n 2'.dedent(), '1\n\n2');
        expect(' 1'.dedent(), '1');
        expect(' 1\n  2'.dedent(), '1\n 2');
        expect('  2\n 1'.dedent(), ' 2\n1');
        expect(' 1\n  2\n   3'.dedent(), '1\n 2\n  3');
        expect('   3\n  2\n 1'.dedent(), '  3\n 2\n1');
      });
      test('whitespace', () {
        expect(''.dedent(whitespace: '\t'), '');
        expect('1\n2'.dedent(whitespace: '\t'), '1\n2');
        expect('1\n\n2'.dedent(whitespace: '\t'), '1\n\n2');
        expect('\t1\n\n\t2'.dedent(whitespace: '\t'), '1\n\n2');
        expect('\t1'.dedent(whitespace: '\t'), '1');
        expect('\t1\n\t\t2'.dedent(whitespace: '\t'), '1\n\t2');
        expect('\t\t2\n\t1'.dedent(whitespace: '\t'), '\t2\n1');
        expect('\t1\n\t\t2\n\t\t\t3'.dedent(whitespace: '\t'), '1\n\t2\n\t\t3');
        expect('\t\t\t3\n\t\t2\n\t1'.dedent(whitespace: '\t'), '\t\t3\n\t2\n1');
      });
      test('ignoreEmpty', () {
        expect(''.dedent(ignoreEmpty: false), '');
        expect('1\n2'.dedent(ignoreEmpty: false), '1\n2');
        expect('1\n\n2'.dedent(ignoreEmpty: false), '1\n\n2');
        expect(' 1\n\n 2'.dedent(ignoreEmpty: false), ' 1\n\n 2');
        expect(' 1'.dedent(ignoreEmpty: false), '1');
        expect(' 1\n  2'.dedent(ignoreEmpty: false), '1\n 2');
        expect('  2\n 1'.dedent(ignoreEmpty: false), ' 2\n1');
        expect(' 1\n  2\n   3'.dedent(ignoreEmpty: false), '1\n 2\n  3');
        expect('   3\n  2\n 1'.dedent(ignoreEmpty: false), '  3\n 2\n1');
      });
    });
    group('take/skip', () {
      test('take', () {
        expect('abc'.take(0), '');
        expect('abc'.take(1), 'a');
        expect('abc'.take(2), 'ab');
        expect('abc'.take(3), 'abc');
        expect('abc'.take(4), 'abc');
      });
      test('takeTo', () {
        expect('abc'.takeTo('a'), '');
        expect('abc'.takeTo('b'), 'a');
        expect('abc'.takeTo('c'), 'ab');
        expect('abc'.takeTo('d'), 'abc');
      });
      test('takeLast', () {
        expect('abc'.takeLast(0), '');
        expect('abc'.takeLast(1), 'c');
        expect('abc'.takeLast(2), 'bc');
        expect('abc'.takeLast(3), 'abc');
        expect('abc'.takeLast(4), 'abc');
      });
      test('takeLastTo', () {
        expect('abc'.takeLastTo('a'), 'bc');
        expect('abc'.takeLastTo('b'), 'c');
        expect('abc'.takeLastTo('c'), '');
        expect('abc'.takeLastTo('d'), 'abc');
      });
      test('skip', () {
        expect('abc'.skip(0), 'abc');
        expect('abc'.skip(1), 'bc');
        expect('abc'.skip(2), 'c');
        expect('abc'.skip(3), '');
        expect('abc'.skip(4), '');
      });
      test('skipTo', () {
        expect('abc'.skipTo('a'), 'bc');
        expect('abc'.skipTo('b'), 'c');
        expect('abc'.skipTo('c'), '');
        expect('abc'.skipTo('d'), '');
      });
      test('skipLast', () {
        expect('abc'.skipLast(0), 'abc');
        expect('abc'.skipLast(1), 'ab');
        expect('abc'.skipLast(2), 'a');
        expect('abc'.skipLast(3), '');
        expect('abc'.skipLast(4), '');
      });
      test('skipLastTo', () {
        expect('abc'.skipLastTo('a'), '');
        expect('abc'.skipLastTo('b'), 'a');
        expect('abc'.skipLastTo('c'), 'ab');
        expect('abc'.skipLastTo('d'), '');
      });
    });
    group('wrap', () {
      test('default', () {
        expect('a'.wrap(4), 'a');
        expect('a b'.wrap(4), 'a b');
        expect('a b c'.wrap(4), 'a b\nc');
        expect('aa bb cc'.wrap(4), 'aa\nbb\ncc');
        expect('a\nb'.wrap(4), 'a\nb');
        expect('1234'.wrap(4), '1234');
        expect('12345'.wrap(4), '1234\n5');
        expect('12345678'.wrap(4), '1234\n5678');
        expect('123456789'.wrap(4), '1234\n5678\n9');
      });
      test('whitespace', () {
        const whitespace = ' ';
        expect('a'.wrap(4, whitespace: whitespace), 'a');
        expect('a b'.wrap(4, whitespace: whitespace), 'a b');
        expect('a b c'.wrap(4, whitespace: whitespace), 'a b\nc');
        expect('aa bb cc'.wrap(4, whitespace: whitespace), 'aa\nbb\ncc');
        expect('a\nb'.wrap(4, whitespace: whitespace), 'a\nb');
        expect('1234'.wrap(4, whitespace: whitespace), '1234');
        expect('12345'.wrap(4, whitespace: whitespace), '1234\n5');
        expect('12345678'.wrap(4, whitespace: whitespace), '1234\n5678');
        expect('123456789'.wrap(4, whitespace: whitespace), '1234\n5678\n9');
      });
      test('breakLongWords', () {
        expect('a'.wrap(4, breakLongWords: false), 'a');
        expect('a b'.wrap(4, breakLongWords: false), 'a b');
        expect('a b c'.wrap(4, breakLongWords: false), 'a b\nc');
        expect('aa bb cc'.wrap(4, breakLongWords: false), 'aa\nbb\ncc');
        expect('a\nb'.wrap(4, breakLongWords: false), 'a\nb');
        expect('1234'.wrap(4, breakLongWords: false), '1234');
        expect('12345'.wrap(4, breakLongWords: false), '12345');
        expect('12345678'.wrap(4, breakLongWords: false), '12345678');
        expect('123456789'.wrap(4, breakLongWords: false), '123456789');
      });
      test('invalid', () {
        expect(() => 'a'.wrap(-1), throwsRangeError);
        expect(() => 'a'.wrap(0), throwsRangeError);
      });
    });
    group('unwrap', () {
      test('single', () {
        expect('1'.unwrap(), '1');
        expect('1\n2'.unwrap(), '1 2');
        expect('1\n2\n3'.unwrap(), '1 2 3');
      });
      test('multiple', () {
        expect('1\n\na'.unwrap(), '1\n\na');
        expect('1\n2\n\na\nb'.unwrap(), '1 2\n\na b');
        expect('1\n2\n3\n\na\nb\nc'.unwrap(), '1 2 3\n\na b c');
      });
    });
  });
  group('trie', () {
    group(
        'list-based',
        () => allTrieTests(
            <K, P extends Comparable<P>, V>() => TrieNodeList<K, P, V>()));
    group(
        'map-based',
        () => allTrieTests(
            <K, P extends Comparable<P>, V>() => TrieNodeMap<K, P, V>()));
  });
  group('typemap', () {
    test('empty', () {
      final map = TypeMap<Object>();
      expect(map.hasInstance<String>(), isFalse);
      expect(map.getInstance<String>(), isNull);
      expect(map.types, []);
      expect(map.instances, []);
      expect(map.length, 0);
      expect(map.isEmpty, isTrue);
      expect(map.isNotEmpty, isFalse);
      expect(map.asMap(), {});
      expect(map.toString(), '{}');
    });
    test('single', () {
      final map = TypeMap<Object>();
      map.setInstance('hello');
      expect(map.hasInstance<String>(), isTrue);
      expect(map.getInstance<String>(), 'hello');
      expect(map.hasInstance<int>(), isFalse);
      expect(map.getInstance<int>(), isNull);
      expect(map.types, [String]);
      expect(map.instances, ['hello']);
      expect(map.length, 1);
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
      expect(map.asMap(), {String: 'hello'});
      expect(map.toString(), '{String: hello}');
    });
    test('double', () {
      final map = TypeMap<Object>();
      map.setInstance('hello');
      expect(map.hasInstance<String>(), isTrue);
      expect(map.getInstance<String>(), 'hello');
      expect(map.hasInstance<int>(), isFalse);
      expect(map.getInstance<int>(ifAbsentPut: () => 42), 42);
      expect(map.hasInstance<int>(), isTrue);
      expect(map.getInstance<int>(ifAbsentPut: () => 52), 42);
      expect(map.types, [String, int]);
      expect(map.instances, ['hello', 42]);
      expect(map.length, 2);
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
      expect(map.asMap(), {String: 'hello', int: 42});
      expect(map.toString(), '{String: hello, int: 42}');
    });
  });
}

void allHeapTests(
    Heap<T> Function<T>(List<T> list, {Comparator<T>? comparator}) createHeap) {
  final comparators = {
    'max': (int a, int b) => a.compareTo(b),
    'min': (int a, int b) => b.compareTo(a),
  };
  test('empty', () {
    final heap = createHeap<String>([]);
    expect(heap.isEmpty, isTrue);
    expect(heap.isNotEmpty, isFalse);
    expect(heap.length, 0);
    expect(() => heap.peek, throwsStateError);
    expect(() => heap.pop(), throwsStateError);
    expect(() => heap.popAndPush('Hello'), throwsStateError);
    expect(heap.pushAndPop('World'), 'World');
    expect(heap.length, 0);
  });
  test('popAndPush', () {
    final heap = createHeap<String>(['Olivia', 'Emma', 'Sophia']);
    expect(heap.popAndPush('Amelia'), 'Sophia');
    expect(heap.popAndPush('Nora'), 'Olivia');
    expect(heap.popAndPush('Violet'), 'Nora');
    expect(heap.toList()..sort(), ['Amelia', 'Emma', 'Violet']);
  });
  test('pushAndPop', () {
    final heap = createHeap<String>(['Olivia', 'Emma', 'Sophia']);
    expect(heap.pushAndPop('Amelia'), 'Sophia');
    expect(heap.pushAndPop('Nora'), 'Olivia');
    expect(heap.pushAndPop('Violet'), 'Violet');
    expect(heap.toList()..sort(), ['Amelia', 'Emma', 'Nora']);
  });
  test('clear', () {
    final heap = createHeap<String>(['Olivia', 'Emma', 'Sophia']);
    heap.clear();
    expect(heap.isEmpty, isTrue);
    expect(heap.isNotEmpty, isFalse);
    expect(heap.length, 0);
  });
  for (var comparator in comparators.entries) {
    test('stress ${comparator.key}', () {
      final random = Random(comparator.key.hashCode);
      final source = <int>[];
      while (source.length < 2500) {
        source.add(random.nextInt(0xffffff));
      }
      final heap = createHeap<int>(source, comparator: comparator.value);
      source.sort(comparator.value);
      while (source.isNotEmpty) {
        expect(heap.isEmpty, isFalse);
        expect(heap.isNotEmpty, isTrue);
        expect(heap.length, source.length);
        final value = source.removeLast();
        expect(heap.peek, value);
        expect(heap.pop(), value);
      }
      expect(heap.isEmpty, isTrue);
      expect(heap.isNotEmpty, isFalse);
      expect(heap.length, 0);
    });
  }
}

void allSortedListTests(
    SortedList<E> Function<E>(Iterable<E> list, {Comparator<E>? comparator})
        createSortedList) {
  test('default ordering', () {
    final list = createSortedList<int>([5, 1, 2, 4, 3]);
    expect(list, [1, 2, 3, 4, 5]);
  });
  test('custom ordering', () {
    final list = createSortedList<num>([5, 1, 2, 4, 3],
        comparator: reverseComparator<num>());
    expect(list, [5, 4, 3, 2, 1]);
  });
  test('custom comparator', () {
    final list =
        createSortedList<int>([5, 1, 2, 4, 3], comparator: (a, b) => b - a);
    expect(list, [5, 4, 3, 2, 1]);
  });
  test('empty list', () {
    final list = createSortedList<int>([]);
    expect(list, isEmpty);
  });
  test('accessors', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.length, 3);
    expect(list.first, 1);
    expect(list.last, 5);
    expect(list[0], 1);
    expect(list[2], 5);
  });
  test('contains', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.contains(0), isFalse);
    expect(list.contains(1), isTrue);
    expect(list.contains(2), isFalse);
    expect(list.contains(3), isTrue);
    expect(list.contains(4), isFalse);
    expect(list.contains(5), isTrue);
    expect(list.contains(6), isFalse);
    expect(list.contains(null), isFalse);
  });
  test('add', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    list.add(4);
    expect(list, [1, 3, 4, 5]);
  });
  test('addAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    list.addAll([2, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });
  test('remove', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    expect(list.remove(3), isTrue);
    expect(list, [1, 5]);
    expect(list.remove(3), isFalse);
    expect(list.remove(null), isFalse);
  });
  test('stress', () {
    final random = Random(6412);
    final numbers = <int>{};
    // Create 1000 unique numbers.
    while (numbers.length < 1000) {
      numbers.add(random.nextInt(0xffffff));
    }
    final values = List.of(numbers);
    // Create a list from digit of the values.
    final list = createSortedList<int>(values);
    // Verify all values are present.
    expect(list, hasLength(values.length));
    for (final value in values) {
      expect(list.contains(value), isTrue);
    }
    // Remove values in different order.
    values.shuffle(random);
    for (final value in values) {
      expect(list.remove(value), isTrue);
    }
    // Verify all values are gone.
    expect(list, isEmpty);
  });
  test('errors', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(() => list[0] = 2, throwsUnsupportedError);
    expect(() => list.length = 2, throwsUnsupportedError);
    expect(() => list.sort(), throwsUnsupportedError);
    expect(() => list.shuffle(), throwsUnsupportedError);
  });
}

void allTrieTests(
    TrieNode<K, P, V> Function<K, P extends Comparable<P>, V>() createRoot) {
  Trie<String, String, num> newTrie() => Trie<String, String, num>(
      parts: (key) => key.toList(), root: createRoot<String, String, num>());
  group('add', () {
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      expect(trie, hasLength(1));
      expect(trie.keys, ['disobey']);
      expect(trie.values, [42]);
      expect(trie['disobey'], 42);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disorder'] = 43;
      trie['disown'] = 44;
      trie['distrust'] = 45;
      expect(trie, hasLength(4));
      expect(trie.keys, ['disobey', 'disorder', 'disown', 'distrust']);
      expect(trie.values, [42, 43, 44, 45]);
      expect(trie.keysWithPrefix('dis'),
          ['disobey', 'disorder', 'disown', 'distrust']);
      expect(trie.keysWithPrefix('diso'), ['disobey', 'disorder', 'disown']);
      expect(trie.keysWithPrefix('disobeying'), isEmpty);
      expect(trie['disobey'], 42);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['disorder'], 43);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie['disown'], 44);
      expect(trie.containsKey('disown'), isTrue);
      expect(trie['distrust'], 45);
      expect(trie.containsKey('distrust'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      expect(trie, hasLength(1));
      expect(trie.keys, ['']);
      expect(trie.values, [42]);
      expect(trie[''], 42);
      expect(trie.containsKey(''), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
    });
    test('replace', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobey'] = 43;
      expect(trie, hasLength(1));
      expect(trie.keys, ['disobey']);
      expect(trie.values, [43]);
      expect(trie['disobey'], 43);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('enhancing', () {
      final trie = newTrie();
      trie['disobeying'] = 42;
      trie['disobey'] = 43;
      expect(trie, hasLength(2));
      expect(trie.keys, ['disobey', 'disobeying']);
      expect(trie.values, [43, 42]);
      expect(trie['disobeying'], 42);
      expect(trie.containsKey('disobeying'), isTrue);
      expect(trie['disobey'], 43);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
    });
  });
  group('remove', () {
    test('missing', () {
      final trie = newTrie();
      expect(trie.remove('disobey'), isNull);
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, []);
      expect(trie.values, []);
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      expect(trie.remove(''), 42);
      expect(trie.containsKey(''), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, []);
      expect(trie.values, []);
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      expect(trie.remove('disobey'), 42);
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, []);
      expect(trie.values, []);
    });
    test('prefix', () {
      final trie = newTrie();
      trie['dis'] = 42;
      trie['disorder'] = 43;
      expect(trie.remove('dis'), 42);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie, hasLength(1));
      expect(trie.keys, ['disorder']);
      expect(trie.values, [43]);
    });
    test('root prefix', () {
      final trie = newTrie();
      trie[''] = 42;
      trie['disorder'] = 43;
      expect(trie.remove(''), 42);
      expect(trie.containsKey(''), isFalse);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie, hasLength(1));
      expect(trie.keys, ['disorder']);
      expect(trie.values, [43]);
    });
  });
  group('clear', () {
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      trie.clear();
      expect(trie.containsKey(''), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, []);
      expect(trie.values, []);
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie.clear();
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, []);
      expect(trie.values, []);
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobeying'] = 43;
      trie.clear();
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie.containsKey('disobeying'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, []);
      expect(trie.values, []);
    });
  });
  group('constructor', () {
    test('fromTrie', () {
      final firstTrie = newTrie();
      firstTrie['abc'] = 42;
      final secondTrie = Trie<String, String, num>.fromTrie(firstTrie,
          root: createRoot<String, String, num>());
      secondTrie['abcdef'] = 43;
      expect(firstTrie, hasLength(1));
      expect(firstTrie.keys, ['abc']);
      expect(firstTrie.values, [42]);
      expect(secondTrie, hasLength(2));
      expect(secondTrie.keys, ['abc', 'abcdef']);
      expect(secondTrie.values, [42, 43]);
    });
    test('fromMap', () {
      final trie = Trie<String, String, int>.fromMap(
        {
          'abc': 42,
          'abcdef': 43,
        },
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [42, 43]);
    });
    test('fromIterable', () {
      final trie = Trie<String, String, int>.fromIterable(
        ['abc', 'abcdef'],
        parts: (key) => key.toList(),
        value: (value) => (value as String).length,
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [3, 6]);
    });
    test('fromIterables', () {
      final trie = Trie<String, String, int>.fromIterables(
        ['abc', 'abcdef'],
        [42, 43],
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [42, 43]);
    });
    test('fromIterables (error)', () {
      expect(
          () => Trie<String, String, int>.fromIterables(
                ['abc', 'abcdef'],
                [42],
                parts: (key) => key.toList(),
                root: createRoot(),
              ),
          throwsArgumentError);
    });
  });
  group('other', () {
    test('typed', () {
      final trie = newTrie();
      expect(trie.containsKey(42), isFalse);
      expect(trie[42], isNull);
    });
    test('nodes', () {
      final trie = newTrie();
      trie.addAll({'a': 1, 'aa': 2, 'ab': 3});
      final root = createRoot<String, String, num>();
      expect(root.hasKeyAndValue, isFalse);
      expect(root.hasChildren, isFalse);
      final types = trie.entries.map((each) => each.runtimeType).toSet();
      expect(types.single, root.runtimeType);
    });
    test('stress', () {
      final random = Random(42);
      final numbers = <int>{};
      // Create 1000 unique numbers.
      while (numbers.length < 1000) {
        numbers.add(random.nextInt(0xffffff));
      }
      final values = List.of(numbers);
      // Create a trie from digit of the values.
      final trie = Trie<int, String, bool>(
        parts: (value) => value.digits().map((digit) => digit.toString()),
        root: createRoot(),
      );
      for (final value in values) {
        trie[value] = true;
      }
      // Verify all values are present.
      expect(trie, hasLength(values.length));
      for (final value in values) {
        expect(trie.containsKey(value), isTrue);
        expect(trie[value], isTrue);
      }
      // Remove values in different order.
      values.shuffle(random);
      for (final value in values) {
        expect(trie.remove(value), isTrue);
      }
      // Verify all values are gone.
      expect(trie, isEmpty);
      for (final value in values) {
        expect(trie.containsKey(value), isFalse);
        expect(trie[value], isNull);
      }
    });
  });
}
