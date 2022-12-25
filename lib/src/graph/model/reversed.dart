import '../edge.dart';
import '../graph.dart';
import 'reversed_edge.dart';

extension ReversedGraphExtension<V, E> on Graph<V, E> {
  /// Returns a graph where all edges point in the opposite direction.
  Graph<V, E> get reversed {
    final self = this;
    return self is ReversedGraph<V, E>
        ? self.delegate
        : self.isDirected
            ? ReversedGraph<V, E>(self)
            : self;
  }
}

class ReversedGraph<V, E> extends Graph<V, E> {
  ReversedGraph(this.delegate);

  final Graph<V, E> delegate;

  @override
  Iterable<V> get vertices => delegate.vertices;

  @override
  Iterable<Edge<V, E>> get edges => delegate.edges.map((edge) => edge.reversed);

  @override
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex) =>
      delegate.outgoingEdgesOf(vertex).map((edge) => edge.reversed);

  @override
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex) =>
      delegate.outgoingEdgesOf(vertex).map((edge) => edge.reversed);

  @override
  bool get isDirected => delegate.isDirected;

  @override
  void addVertex(V vertex) => delegate.addVertex(vertex);

  @override
  void addEdge(V source, V target, {E? data}) =>
      delegate.addEdge(target, source, data: data);

  @override
  void removeVertex(V vertex) => delegate.removeVertex(vertex);

  @override
  void removeEdge(V source, V target, {E? data}) =>
      delegate.removeEdge(target, source, data: data);
}