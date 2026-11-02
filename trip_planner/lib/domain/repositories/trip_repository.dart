import '../entities/city.dart';
import '../entities/connection.dart';

abstract interface class TripRepository {
  Future<List<Connection>> getConnections();
  Future<List<City>> getCities();
}
