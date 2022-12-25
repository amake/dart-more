import 'edge.dart';
import 'model/directed.dart';
import 'model/undirected.dart';

/// Abstract base class of graphs.
abstract class Graph<V, E> {
  /// Directed graph.
  factory Graph.directed() = DirectedGraph;

  /// Undirected graph.
  factory Graph.undirected() = UndirectedGraph;

  /// Generative constructor.
  Graph();

  /// Returns the vertices of this graph.
  Iterable<V> get vertices;

  /// Returns the edges of this graph.
  Iterable<Edge<V, E>> get edges;

  /// Returns the incoming and outgoing edges of `vertex`.
  Iterable<Edge<V, E>> edgesOf(V vertex) =>
      incomingEdgesOf(vertex).followedBy(outgoingEdgesOf(vertex));

  /// Returns the incoming edges of `vertex`.
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex);

  /// Returns the outgoing edges of `vertex`.
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex);

  /// Returns the vertices that are adjacent to a `vertex`.
  Iterable<V> neighboursOf(V vertex) =>
      predecessorsOf(vertex).followedBy(successorsOf(vertex));

  /// Returns the vertices that come before a `vertex`.
  Iterable<V> predecessorsOf(V vertex) =>
      incomingEdgesOf(vertex).map((edge) => edge.source);

  /// Returns the vertices that come after a `vertex`.
  Iterable<V> successorsOf(V vertex) =>
      outgoingEdgesOf(vertex).map((edge) => edge.target);

  /// Returns `true` if the graph is directed.
  bool get isDirected;

  /// Adds a vertex to this graph.
  void addVertex(V vertex);

  /// Adds an edge between `source` and `target` vertex. Optionally
  /// associates the provided `data` with the edge.
  void addEdge(V source, V target, {E? data});

  void addEdgeObject(Edge<V, E> edge) =>
      addEdge(edge.source, edge.target, data: edge.dataOrNull);

  /// Removes a vertex from this graph.
  void removeVertex(V vertex);

  void removeEdge(V source, V target, {E? data});

  void removeEdgeObject(Edge<V, E> edge) =>
      removeEdge(edge.source, edge.target, data: edge.dataOrNull);
}