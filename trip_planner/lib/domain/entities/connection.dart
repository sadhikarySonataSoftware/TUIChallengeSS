import 'geo_point.dart';

class Connection {
  const Connection({
    required this.departure,
    required this.destination,
    required this.price,
    required this.departurePoint,
    required this.destinationPoint,
  });

  final String departure;
  final String destination;
  final double price;
  final GeoPoint departurePoint;
  final GeoPoint destinationPoint;
}
