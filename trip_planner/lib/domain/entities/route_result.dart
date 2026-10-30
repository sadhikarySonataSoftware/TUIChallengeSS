import 'connection.dart';

class RouteResult {
  const RouteResult({required this.legs, required this.totalPrice});

  final List<Connection> legs;
  final double totalPrice;

  String get origin => legs.first.departure;
  String get destination => legs.last.destination;
}
