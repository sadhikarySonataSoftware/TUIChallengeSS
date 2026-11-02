import 'connection.dart';

class RouteResult {
  const RouteResult({
    required this.legs,
    required this.totalPrice,
  });

  final List<Connection> legs;
  final double totalPrice;

  String get origin {
    assert(legs.isNotEmpty, 'RouteResult must contain at least one leg');
    return legs.first.departure;
  }

  String get destination {
    assert(legs.isNotEmpty, 'RouteResult must contain at least one leg');
    return legs.last.destination;
  }
}