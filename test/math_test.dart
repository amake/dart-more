library more.test.math_test;

import 'dart:math' as math;

import 'package:more/math.dart';
import 'package:test/test.dart';

void main() {
  final epsilon = 2.pow(-32);
  group('binomial', () {
    group('values', () {
      test('int', () {
        expect(7.binomial(0), 1);
        expect(7.binomial(1), 7);
        expect(7.binomial(2), 21);
        expect(7.binomial(3), 35);
        expect(7.binomial(4), 35);
        expect(7.binomial(5), 21);
        expect(7.binomial(6), 7);
        expect(7.binomial(7), 1);
      });
      test('BigInt', () {
        expect(BigInt.from(7).binomial(BigInt.from(0)), BigInt.from(1));
        expect(BigInt.from(7).binomial(BigInt.from(1)), BigInt.from(7));
        expect(BigInt.from(7).binomial(BigInt.from(2)), BigInt.from(21));
        expect(BigInt.from(7).binomial(BigInt.from(3)), BigInt.from(35));
        expect(BigInt.from(7).binomial(BigInt.from(4)), BigInt.from(35));
        expect(BigInt.from(7).binomial(BigInt.from(5)), BigInt.from(21));
        expect(BigInt.from(7).binomial(BigInt.from(6)), BigInt.from(7));
        expect(BigInt.from(7).binomial(BigInt.from(7)), BigInt.from(1));
      });
    });
    group('bounds', () {
      test('int', () {
        expect(() => 7.binomial(-1), throwsArgumentError);
        expect(() => 7.binomial(8), throwsArgumentError);
      });
      test('BigInt', () {
        expect(() => BigInt.from(7).binomial(BigInt.from(-1)),
            throwsArgumentError);
        expect(
            () => BigInt.from(7).binomial(BigInt.from(8)), throwsArgumentError);
      });
    });
  });
  group('digits', () {
    group('base 10', () {
      test('int', () {
        expect(0.digits(), [0]);
        expect(1.digits(), [1]);
        expect(12.digits(), [2, 1]);
        expect(123.digits(), [3, 2, 1]);
        expect(1001.digits(), [1, 0, 0, 1]);
        expect(10001.digits(), [1, 0, 0, 0, 1]);
        expect(1000.digits(), [0, 0, 0, 1]);
        expect(10000.digits(), [0, 0, 0, 0, 1]);
      });
      test('BigInt', () {
        expect(BigInt.from(0).digits(), [0]);
        expect(BigInt.from(1).digits(), [1]);
        expect(BigInt.from(12).digits(), [2, 1]);
        expect(BigInt.from(123).digits(), [3, 2, 1]);
        expect(BigInt.from(1001).digits(), [1, 0, 0, 1]);
        expect(BigInt.from(10001).digits(), [1, 0, 0, 0, 1]);
        expect(BigInt.from(1000).digits(), [0, 0, 0, 1]);
        expect(BigInt.from(10000).digits(), [0, 0, 0, 0, 1]);
      });
    });
    group('base 2', () {
      test('int', () {
        expect(0.digits(2), [0]);
        expect(1.digits(2), [1]);
        expect(12.digits(2), [0, 0, 1, 1]);
        expect(123.digits(2), [1, 1, 0, 1, 1, 1, 1]);
        expect(1001.digits(2), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(10001.digits(2), [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
        expect(1000.digits(2), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(10000.digits(2), [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      });
      test('BigInt', () {
        expect(BigInt.from(0).digits(2), [0]);
        expect(BigInt.from(1).digits(2), [1]);
        expect(BigInt.from(12).digits(2), [0, 0, 1, 1]);
        expect(BigInt.from(123).digits(2), [1, 1, 0, 1, 1, 1, 1]);
        expect(BigInt.from(1001).digits(2), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(BigInt.from(10001).digits(2),
            [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
        expect(BigInt.from(1000).digits(2), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
        expect(BigInt.from(10000).digits(2),
            [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      });
    });
    group('base 16', () {
      test('int', () {
        expect(0.digits(16), [0]);
        expect(1.digits(16), [1]);
        expect(12.digits(16), [12]);
        expect(123.digits(16), [11, 7]);
        expect(1001.digits(16), [9, 14, 3]);
        expect(10001.digits(16), [1, 1, 7, 2]);
        expect(1000.digits(16), [8, 14, 3]);
        expect(10000.digits(16), [0, 1, 7, 2]);
      });
      test('BigInt', () {
        expect(BigInt.from(0).digits(16), [0]);
        expect(BigInt.from(1).digits(16), [1]);
        expect(BigInt.from(12).digits(16), [12]);
        expect(BigInt.from(123).digits(16), [11, 7]);
        expect(BigInt.from(1001).digits(16), [9, 14, 3]);
        expect(BigInt.from(10001).digits(16), [1, 1, 7, 2]);
        expect(BigInt.from(1000).digits(16), [8, 14, 3]);
        expect(BigInt.from(10000).digits(16), [0, 1, 7, 2]);
      });
    });
    group('negative', () {
      test('int', () {
        expect((-0).digits(), [0]);
        expect((-1).digits(), [1]);
        expect((-12).digits(), [2, 1]);
        expect((-123).digits(), [3, 2, 1]);
      });
      test('BigInt', () {
        expect(BigInt.from(-0).digits(), [0]);
        expect(BigInt.from(-1).digits(), [1]);
        expect(BigInt.from(-12).digits(), [2, 1]);
        expect(BigInt.from(-123).digits(), [3, 2, 1]);
      });
    });
  });
  group('factorial', () {
    group('values', () {
      test('int', () {
        expect(0.factorial(), 1);
        expect(1.factorial(), 1);
        expect(5.factorial(), 120);
        expect(12.factorial(), 479001600);
        expect(20.factorial(), 2432902008176640000);
        expect(21.factorial(), 2432902008176640000 * 21);
        expect(22.factorial(), 2432902008176640000 * 21 * 22);
      });
      test('BigInt', () {
        expect(BigInt.from(0).factorial(), BigInt.from(1));
        expect(BigInt.from(1).factorial(), BigInt.from(1));
        expect(BigInt.from(5).factorial(), BigInt.from(120));
        expect(BigInt.from(12).factorial(), BigInt.from(479001600));
        expect(BigInt.from(20).factorial(), BigInt.from(2432902008176640000));
        expect(BigInt.from(21).factorial(),
            BigInt.from(2432902008176640000) * BigInt.from(21));
        expect(BigInt.from(22).factorial(),
            BigInt.from(2432902008176640000) * BigInt.from(21 * 22));
      });
    });
    group('bounds', () {
      test('int', () {
        expect(() => (-1).factorial(), throwsArgumentError);
      });
      test('BigInt', () {
        expect(() => (-BigInt.one).factorial(), throwsArgumentError);
      });
    });
  });
  group('hyperbolic', () {
    test('cosh', () {
      expect(0.cosh(), closeTo(1, epsilon));
      expect(1.cosh(), closeTo(1.5430806348152437, epsilon));
      expect((-1).cosh(), closeTo(1.5430806348152437, epsilon));
    });
    test('acosh', () {
      expect((-1).acosh(), isNaN);
      expect(0.acosh(), isNaN);
      expect(0.5.acosh(), isNaN);
      expect(1.acosh(), closeTo(0, epsilon));
      expect(2.acosh(), closeTo(1.3169578969248166, epsilon));
    });
    test('sinh', () {
      expect(0.sinh(), closeTo(0, epsilon));
      expect(1.sinh(), closeTo(1.1752011936438014, epsilon));
    });
    test('asinh', () {
      expect(1.asinh(), closeTo(0.881373587019543, epsilon));
      expect(0.asinh(), closeTo(0, epsilon));
    });
    test('tanh', () {
      expect(0.tanh(), closeTo(0, epsilon));
      expect(double.infinity.tanh(), closeTo(1, epsilon));
      expect(1.tanh(), closeTo(0.7615941559557649, epsilon));
    });
    test('atanh', () {
      expect(-2.atanh(), isNaN);
      expect(-1.atanh(), double.negativeInfinity);
      expect(0.atanh(), closeTo(0, epsilon));
      expect(0.5.atanh(), closeTo(0.5493061443340548, epsilon));
      expect(1.atanh(), double.infinity);
      expect(2.atanh(), isNaN);
    });
  });
  group('isProbablyPrime', () {
    const max = 100000;
    final primes = max.primes.toSet();
    test('int', () {
      for (var i = 0; i < max; i++) {
        expect(i.isProbablyPrime, primes.contains(i));
      }
    });
    test('BigInt', () {
      for (var i = 0; i < max; i++) {
        expect(BigInt.from(i).isProbablyPrime, primes.contains(i));
      }
    });
  });
  group('lcm', () {
    test('int', () {
      expect(5.lcm(2), 10);
      expect(2.lcm(5), 10);
      expect(5.lcm(0), 0);
      expect(0.lcm(5), 0);
    });
    test('BigInt', () {
      expect(BigInt.from(5).lcm(BigInt.from(2)), BigInt.from(10));
      expect(BigInt.from(2).lcm(BigInt.from(5)), BigInt.from(10));
      expect(BigInt.from(5).lcm(BigInt.from(0)), BigInt.from(0));
      expect(BigInt.from(0).lcm(BigInt.from(5)), BigInt.from(0));
    });
  });
  group('math', () {
    test('pow(x, 0)', () {
      expect((-2).pow(0), 1);
      expect((-1).pow(0), 1);
      expect(0.pow(0), 1);
      expect(1.pow(0), 1);
      expect(2.pow(0), 1);
    });
    test('pow(x, 1)', () {
      expect((-2).pow(1), -2);
      expect((-1).pow(1), -1);
      expect(0.pow(1), 0);
      expect(1.pow(1), 1);
      expect(2.pow(1), 2);
    });
    test('pow(x, 5)', () {
      expect((-2).pow(5), -32);
      expect((-1).pow(5), -1);
      expect(0.pow(5), 0);
      expect(1.pow(5), 1);
      expect(2.pow(5), 32);
    });
    test('pow(x, -2)', () {
      expect((-2).pow(-2), 0.25);
      expect((-1).pow(-2), 1.0);
      expect(1.pow(-2), 1.0);
      expect(2.pow(-2), 0.25);
    });
    test('sin', () {
      expect(0.sin(), closeTo(0, epsilon));
      expect((0.5 * math.pi).sin(), closeTo(1, epsilon));
      expect(math.pi.sin(), closeTo(0, epsilon));
    });
    test('asin', () {
      expect(1.asin(), closeTo(1.5707963267948966, epsilon));
      expect(-1.asin(), closeTo(-1.5707963267948966, epsilon));
    });
    test('cos', () {
      expect(0.cos(), closeTo(1, epsilon));
      expect((0.5 * math.pi).cos(), closeTo(0, epsilon));
      expect(math.pi.cos(), closeTo(-1, epsilon));
    });
    test('acos', () {
      expect(1.acos(), closeTo(0, epsilon));
      expect((-1).acos(), closeTo(math.pi, epsilon));
    });
    test('tan', () {
      expect(0.tan(), closeTo(0, epsilon));
      expect(1.tan(), closeTo(1.55740772465, epsilon));
    });
    test('atan', () {
      expect(1.atan(), closeTo(0.7853981633974483, epsilon));
      expect((-1).atan(), closeTo(-0.7853981633974483, epsilon));
    });
    test('atan2', () {
      expect(1.atan2(2), closeTo(0.4636476090008061, epsilon));
      expect(2.atan2(1), closeTo(1.1071487177940904, epsilon));
    });
    test('sqrt', () {
      expect(2.sqrt(), closeTo(1.4142135623730951, epsilon));
      expect(3.sqrt(), closeTo(1.7320508075688772, epsilon));
      expect(4.sqrt(), closeTo(2.00, epsilon));
    });
    test('exp', () {
      expect(0.exp(), closeTo(1, epsilon));
      expect(1.exp(), closeTo(math.e, epsilon));
      expect((-1).exp(), closeTo(1 / math.e, epsilon));
    });
    test('log', () {
      expect(1.log(), closeTo(0, epsilon));
      expect(math.e.log(), closeTo(1, epsilon));
      expect((1 / math.e).log(), closeTo(-1, epsilon));
    });
  });
  test('primes', () {
    expect(10.primes, [2, 3, 5, 7]);
    expect(20.primes, [2, 3, 5, 7, 11, 13, 17, 19]);
  });
}
