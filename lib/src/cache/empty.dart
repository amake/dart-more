import 'dart:async' show Future, FutureOr;

import 'cache.dart';
import 'loader.dart';

/// An empty or null cache, useful mostly for testing.
class EmptyCache<K, V> extends Cache<K, V> {
  final Loader<K, V> loader;

  const EmptyCache(this.loader);

  @override
  Future<V?> getIfPresent(K key) async => null;

  @override
  Future<V> get(K key) async => loader(key);

  @override
  Future<V> set(K key, FutureOr<V> value) async => value;

  @override
  Future<int> size() async => 0;

  @override
  Future<void> invalidate(K key) async {}

  @override
  Future<void> invalidateAll() async {}

  @override
  Future<int> reap() async => 0;
}
