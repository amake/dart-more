import 'package:collection/collection.dart' show PriorityQueue;

import '../edge.dart';
import '../graph.dart';
import '../operations/copy.dart';
import '../strategy.dart';

/// Prim's algorithm to find the minimum spanning tree in _O(E*log(V))_.
///
/// See https://en.wikipedia.org/wiki/Prim%27s_algorithm.
Graph<V, E> primsMinSpanningTree<V, E>(
  Graph<V, E> graph, {
  required V? startVertex,
  required num Function(V source, V target) edgeWeight,
  required StorageStrategy<V> vertexStrategy,
}) {
  // Create an empty copy of the graph.
  final result = graph.copy(empty: true);
  if (graph.vertices.isEmpty) return result;

  // Queue for the shortest remaining edges.
  final queue = PriorityQueue<_State<V, E>>(_stateCompare);
  void addOutgoingEdgesToQueue(V vertex) {
    for (final edge in graph.outgoingEdgesOf(vertex)) {
      if (!result.vertices.contains(edge.target)) {
        queue.add(_State<V, E>(edge, edgeWeight(edge.source, edge.target)));
      }
    }
  }

  // Prepare the initial outgoing edges.
  addOutgoingEdgesToQueue(startVertex ?? graph.vertices.first);

  // Pick the shortest edge that connects to a not yet connected vertex.
  while (queue.isNotEmpty) {
    final state = queue.removeFirst();
    if (!result.vertices.contains(state.edge.target)) {
      result.addEdge(state.edge.source, state.edge.target,
          value: state.edge.value);
      addOutgoingEdgesToQueue(state.edge.target);
    }
  }

  return result;
}

final class _State<V, E> {
  _State(this.edge, this.cost);

  final Edge<V, E> edge;
  final num cost;
}

int _stateCompare<V, E>(_State<V, E> a, _State<V, E> b) =>
    a.cost.compareTo(b.cost);
