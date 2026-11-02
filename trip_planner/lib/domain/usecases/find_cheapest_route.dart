import '../../core/logging/app_logger.dart';
import '../entities/connection.dart';
import '../entities/route_result.dart';

class FindCheapestRoute {
  const FindCheapestRoute();

  /// Dijkstra over a directed weighted graph.
  /// Complexity: O((V + E) log V) with the binary heap.
  RouteResult? call({
    required List<Connection> connections,
    required String departure,
    required String destination,
  }) {
    final start = _normalize(departure);
    final target = _normalize(destination);

    AppLogger.info(
      'Route search: $departure → $destination (${connections.length} connections)',
      tag: 'ROUTE',
    );

    if (start == target) {
      AppLogger.warning(
        'Departure and destination are identical; no route search needed',
        tag: 'ROUTE',
      );
      return null;
    }

    final graph = <String, List<Connection>>{};
    for (final edge in connections) {
      final from = _normalize(edge.departure);
      graph.putIfAbsent(from, () => <Connection>[]).add(edge);
    }

    if (!graph.containsKey(start)) {
      AppLogger.warning('Departure city not found in graph: $departure', tag: 'ROUTE');
      return null;
    }

    final distances = <String, double>{start: 0};
    final previous = <String, Connection>{};
    final queue = _MinHeap<_QueueNode>((a, b) => a.distance.compareTo(b.distance));
    queue.add(_QueueNode(start, 0));

    var visitedNodes = 0;
    var relaxedEdges = 0;

    while (queue.isNotEmpty) {
      final current = queue.remove();
      final known = distances[current.city];
      if (known == null || current.distance > known) continue;

      visitedNodes++;
      AppLogger.debug(
        'Visiting ${current.city} at cost ${current.distance.toStringAsFixed(2)}',
        tag: 'ROUTE',
      );

      if (current.city == target) break;

      for (final edge in graph[current.city] ?? const <Connection>[]) {
        final next = _normalize(edge.destination);
        final candidate = current.distance + edge.price;
        if (candidate < (distances[next] ?? double.infinity)) {
          distances[next] = candidate;
          previous[next] = edge;
          queue.add(_QueueNode(next, candidate));
          relaxedEdges++;

          AppLogger.debug(
            'Relaxed ${edge.departure} → ${edge.destination} '
            'price=${edge.price.toStringAsFixed(2)}, '
            'total=${candidate.toStringAsFixed(2)}',
            tag: 'ROUTE',
          );
        }
      }
    }

    if (!distances.containsKey(target)) {
      AppLogger.warning(
        'No route found: $departure → $destination. '
        'visited=$visitedNodes relaxed=$relaxedEdges',
        tag: 'ROUTE',
      );
      return null;
    }

    final legs = <Connection>[];
    var cursor = target;
    while (cursor != start) {
      final edge = previous[cursor];
      if (edge == null) {
        AppLogger.error('Route reconstruction failed at city=$cursor', tag: 'ROUTE');
        return null;
      }
      legs.add(edge);
      cursor = _normalize(edge.departure);
    }

    final orderedLegs = legs.reversed.toList(growable: false);
    final totalPrice = distances[target]!;

    AppLogger.info(
      'Route found: $departure → $destination | '
      'legs=${orderedLegs.length} | total=${totalPrice.toStringAsFixed(2)} | '
      'visited=$visitedNodes | relaxed=$relaxedEdges',
      tag: 'ROUTE',
    );

    for (final leg in orderedLegs) {
      AppLogger.debug(
        '  leg: ${leg.departure} → ${leg.destination} = '
        '${leg.price.toStringAsFixed(2)}',
        tag: 'ROUTE',
      );
    }

    return RouteResult(
      legs: orderedLegs,
      totalPrice: totalPrice,
    );
  }

  static String _normalize(String city) => city.trim().toLowerCase();
}

class _QueueNode {
  const _QueueNode(this.city, this.distance);
  final String city;
  final double distance;
}

class _MinHeap<T> {
  _MinHeap(this._compare);
  final int Function(T a, T b) _compare;
  final List<T> _items = [];

  bool get isNotEmpty => _items.isNotEmpty;

  void add(T value) {
    _items.add(value);
    var index = _items.length - 1;
    while (index > 0) {
      final parent = (index - 1) ~/ 2;
      if (_compare(_items[index], _items[parent]) >= 0) break;
      _swap(index, parent);
      index = parent;
    }
  }

  T remove() {
    final root = _items.first;
    final last = _items.removeLast();
    if (_items.isNotEmpty) {
      _items[0] = last;
      var index = 0;
      while (true) {
        final left = index * 2 + 1;
        final right = left + 1;
        var smallest = index;
        if (left < _items.length && _compare(_items[left], _items[smallest]) < 0) {
          smallest = left;
        }
        if (right < _items.length && _compare(_items[right], _items[smallest]) < 0) {
          smallest = right;
        }
        if (smallest == index) break;
        _swap(index, smallest);
        index = smallest;
      }
    }
    return root;
  }

  void _swap(int a, int b) {
    final value = _items[a];
    _items[a] = _items[b];
    _items[b] = value;
  }
}
