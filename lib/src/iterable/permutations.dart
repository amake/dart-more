library more.iterable.permutations;

import 'dart:collection';

import 'empty.dart';

/// Returns an iterable over the permutations of [elements]. The permutations
/// are emitted in lexicographical order based on the input.
///
/// The following expression iterates over xyz, xzy, yxz, yzx, zxy, and zyx:
///
///     permutations(string('xyz'));
///
Iterable<List<E>> permutations<E>(Iterable<E> elements) {
  return elements.isEmpty
      ? emptyIterable<List<E>>()
      : new _PermutationIterable<E>(elements.toList(growable: false));
}

class _PermutationIterable<E> extends IterableBase<List<E>> {
  final List<E> _elements;

  _PermutationIterable(this._elements);

  @override
  Iterator<List<E>> get iterator => new _PermutationIterator<E>(_elements);
}

class _PermutationIterator<E> extends Iterator<List<E>> {
  final List<E> _elements;

  List<int> _state;
  List<E> _current;
  bool _completed = false;

  _PermutationIterator(this._elements);

  @override
  List<E> get current => _current;

  @override
  bool moveNext() {
    if (_completed) {
      return false;
    } else if (_current == null) {
      _state = new List<int>(_elements.length);
      _current = new List<E>(_elements.length);
      for (var i = 0; i < _state.length; i++) {
        _state[i] = i;
        _current[i] = _elements[i];
      }
      return true;
    } else {
      var k = _state.length - 2;
      while (k >= 0 && _state[k] > _state[k + 1]) {
        k--;
      }
      if (k == -1) {
        _state = null;
        _current = null;
        _completed = true;
        return false;
      }
      var l = _state.length - 1;
      while (_state[k] > _state[l]) {
        l--;
      }
      swap(k, l);
      for (var i = k + 1, j = _state.length - 1; i < j; i++, j--) {
        swap(i, j);
      }
      return true;
    }
  }

  void swap(int i, int j) {
    var temp = _state[i];
    _state[i] = _state[j];
    _state[j] = temp;
    _current[i] = _elements[_state[i]];
    _current[j] = _elements[_state[j]];
  }
}
