import 'package:flutter_test/flutter_test.dart';
import 'package:trip_planner/data/models/connection_model.dart';

void main() {
  test('parses flat challenge connection JSON', () {
    final model = ConnectionModel.fromJson({
      'departure': 'Berlin',
      'destination': 'Paris',
      'price': 120,
      'departure_latitude': 52.52,
      'departure_longitude': 13.405,
      'destination_latitude': 48.8566,
      'destination_longitude': 2.3522,
    });

    expect(model.departure, 'Berlin');
    expect(model.destination, 'Paris');
    expect(model.price, 120);
    expect(model.departurePoint.latitude, 52.52);
    expect(model.destinationPoint.longitude, 2.3522);
  });

  test('parses nested coordinate JSON and common aliases', () {
    final model = ConnectionModel.fromJson({
      'from': 'A',
      'to': 'B',
      'cost': '12.5',
      'departure_coordinates': {'lat': 10, 'lng': 20},
      'destination_coordinates': {'latitude': 30, 'longitude': 40},
    });

    expect(model.departure, 'A');
    expect(model.destination, 'B');
    expect(model.price, 12.5);
    expect(model.departurePoint.longitude, 20);
    expect(model.destinationPoint.latitude, 30);
  });
}
