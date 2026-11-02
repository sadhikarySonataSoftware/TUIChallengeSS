import '../../core/logging/app_logger.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/connection.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/connections_remote_data_source.dart';

class TripRepositoryImpl implements TripRepository {
  const TripRepositoryImpl(this._remoteDataSource);

  final ConnectionsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Connection>> getConnections() async {
    AppLogger.debug('Repository: getConnections()', tag: 'REPOSITORY');
    final result = await _remoteDataSource.fetchConnections();
    AppLogger.debug('Repository: returning ${result.length} connections', tag: 'REPOSITORY');
    return result;
  }

  @override
  Future<List<City>> getCities() async {
    AppLogger.debug('Repository: getCities()', tag: 'REPOSITORY');
    final result = await _remoteDataSource.fetchCities();
    AppLogger.debug('Repository: returning ${result.length} cities', tag: 'REPOSITORY');
    return result;
  }
}
