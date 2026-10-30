import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/domain/entities/connection.dart';
import 'package:trip_planner/domain/entities/geo_point.dart';
import 'package:trip_planner/domain/usecases/find_cheapest_route.dart';

Connection edge(String from, String to, double price) => Connection(
      departure: from,
      destination: to,
      price: price,
      departurePoint: const GeoPoint(latitude: 0, longitude: 0),
      destinationPoint: const GeoPoint(latitude: 1, longitude: 1),
    );

void main() {
  const finder = FindCheapestRoute();

  test('prefers a cheaper multi-leg route over an expensive direct route', () {
    final result = finder.call(
      connections: [edge('A', 'D', 100), edge('A', 'B', 30), edge('B', 'C', 20), edge('C', 'D', 25)],
      departure: 'A',
      destination: 'D',
    );

    expect(result, isNotNull);
    expect(result!.totalPrice, 75);
    expect(result.legs.map((e) => '${e.departure}-${e.destination}'), ['A-B', 'B-C', 'C-D']);
  });

  test('returns null when destination is unreachable', () {
    final result = finder.call(connections: [edge('A', 'B', 10)], departure: 'A', destination: 'C');
    expect(result, isNull);
  });

  test('city matching is case and whitespace insensitive', () {
    final result = finder.call(connections: [edge('A', 'B', 10)], departure: ' a ', destination: 'b');
    expect(result!.totalPrice, 10);
  });

  test('does not mutate the source connection list', () {
    final input = [edge('A', 'B', 10), edge('B', 'C', 20)];
    finder.call(connections: input, departure: 'A', destination: 'C');
    expect(input.length, 2);
    expect(input.first.departure, 'A');
  });
}
