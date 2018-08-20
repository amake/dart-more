library more.printer.number_printer;

import 'dart:math' as math;

import '../../printer.dart';
import 'utils.dart';

/// Prints numbers in various formats.
class NumberPrinter extends Printer {
  /// Round towards the nearest number that is a multiple of accuracy.
  final double _accuracy;

  /// The numeric base to which the number should be printed.
  final int _base;

  /// The characters to be used to convert a number to a string.
  final String _characters;

  /// The delimiter to separate the integer and fraction part of the number.
  final String _delimiter;

  /// The number of digits to be printed in the integer part.
  final int _digits;

  /// The string that should be displayed if the number is infinite.
  final String _infinity;

  /// The string that should be displayed if the number is not a number.
  final String _nan;

  /// The padding for the integer part.
  final String _padding;

  /// The number of digits to be printed in the fraction part.
  final int _precision;

  /// The separator character to be used to group digits.
  final String _separator;

  NumberPrinter(
      this._accuracy,
      this._base,
      this._characters,
      this._delimiter,
      this._digits,
      this._infinity,
      this._nan,
      this._padding,
      this._precision,
      this._separator);

  @override
  String call(Object object) =>
      checkNumericType(object, _convertNumber, _convertBigInt);

  String _convertNumber(num value) {
    if (value.isNaN) {
      return _nan;
    }
    if (value.isInfinite) {
      return _infinity;
    }
    if (_precision == 0) {
      return _convertInteger(value);
    } else {
      return _convertFloat(value);
    }
  }

  String _convertInteger(num value) {
    final digits = _intDigits(value.abs().truncate());
    return _convertIntegerDigits(digits);
  }

  String _convertIntegerDigits(List<int> digits) {
    var result = _formatDigits(digits);
    if (_separator != null) {
      result = _separateRight(result, _separator);
    }
    if (_digits != null && _padding != null) {
      result = result.padLeft(_digits, _padding);
    }
    return result;
  }

  String _convertFloat(num value) {
    final buffer = StringBuffer();
    final multiplier = math.pow(_base, _precision);
    final accuracy = _accuracy ?? 1.0 / multiplier;
    final rounded = (value / accuracy).roundToDouble() * accuracy;
    buffer.write(_convertInteger(rounded));
    if (_delimiter != null) {
      buffer.write(_delimiter);
    }
    final fractional = rounded.abs() - rounded.abs().truncate();
    buffer.write(_convertFraction(fractional * multiplier));
    return buffer.toString();
  }

  String _convertFraction(double value) {
    final digits = _intDigits(value.round());
    var result = _formatDigits(digits).padLeft(_precision, _characters[0]);
    if (_separator != null) {
      result = _separateLeft(result, _separator);
    }
    return result;
  }

  String _convertBigInt(BigInt value) {
    final digits = _bigIntDigits(value.abs());
    return _convertIntegerDigits(digits);
  }

  List<int> _intDigits(int value) {
    final digits = <int>[];
    if (value == 0) {
      digits.add(0);
    } else {
      value = value.abs();
      while (value > 0) {
        final next = value ~/ _base;
        final index = value - next * _base;
        digits.add(index);
        value = next;
      }
    }
    return digits;
  }

  List<int> _bigIntDigits(BigInt value) {
    final digits = <int>[];
    if (value == BigInt.zero) {
      digits.add(0);
    } else {
      value = value.abs();
      final base = BigInt.from(_base);
      while (value > BigInt.zero) {
        final next = value ~/ base;
        final index = value - next * base;
        digits.add(index.toInt());
        value = next;
      }
    }
    return digits;
  }

  String _formatDigits(List<int> digits) {
    return digits.reversed.map((digit) => _characters[digit]).join();
  }

  String _separateLeft(String value, String separator) {
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      if (i != 0 && i % 3 == 0) {
        buffer.write(separator);
      }
      buffer.writeCharCode(value.codeUnitAt(i));
    }
    return buffer.toString();
  }

  String _separateRight(String value, String separator) {
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      if (i != 0 && (value.length - i) % 3 == 0) {
        buffer.write(separator);
      }
      buffer.writeCharCode(value.codeUnitAt(i));
    }
    return buffer.toString();
  }
}