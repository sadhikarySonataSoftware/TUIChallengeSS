
import 'package:trip_planner/domain/entities/city.dart';
import 'package:trip_planner/domain/entities/connection.dart';
import 'package:trip_planner/domain/entities/geo_point.dart';
import 'package:trip_planner/domain/repositories/trip_repository.dart';

class FakeTripRepository implements TripRepository {
  @override
  Future<List<City>> getCities() async {
    return const [
      City(name: 'Paris'),
      City(name: 'London'),
      City(name: 'Amsterdam'),
    ];
  }

  @override
  Future<List<Connection>> getConnections() async {
    return const [
      Connection(
        departure: 'Paris',
        destination: 'London',
        price: 120.0,
        departurePoint: GeoPoint(latitude: 48.8566, longitude: 2.3522),
        destinationPoint: GeoPoint(latitude: 51.5072, longitude: -0.1276),
      ),
      Connection(
        departure: 'London',
        destination: 'Amsterdam',
        price: 85.0,
        departurePoint: GeoPoint(latitude:51.5072, longitude:-0.1276),
        destinationPoint: GeoPoint(latitude:52.3676, longitude:4.9041),
      ),
      Connection(
        departure: 'Paris',
        destination: 'Amsterdam',
        price: 180.0,
        departurePoint: GeoPoint(latitude:48.8566, longitude:2.3522),
        destinationPoint: GeoPoint(latitude:52.3676, longitude:4.9041),
      )
    ];
  }
}