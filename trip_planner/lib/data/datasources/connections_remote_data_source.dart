import 'package:dio/dio.dart';

import '../../core/logging/app_logger.dart';
import '../models/city_model.dart';
import '../models/connection_model.dart';

abstract interface class ConnectionsRemoteDataSource {
  Future<List<ConnectionModel>> fetchConnections();
  Future<List<CityModel>> fetchCities();
}

class DioConnectionsRemoteDataSource implements ConnectionsRemoteDataSource {
  const DioConnectionsRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<ConnectionModel>> fetchConnections() async {
    AppLogger.info('Fetching flight connections', tag: 'DATA');
    final response = await _dio.get<Object?>('/connections');
    final raw = response.data;
    final list = _extractList(raw);
    final connections = list
        .map((item) => ConnectionModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(growable: false);
    AppLogger.info('Parsed ${connections.length} connections', tag: 'DATA');
    return connections;
  }

  @override
  Future<List<CityModel>> fetchCities() async {
    AppLogger.info('Fetching city carousel data', tag: 'DATA');
    final response = await _dio.get<Object?>('/cities');
    final raw = response.data;
    final list = _extractList(raw);
    final cities = list.map(CityModel.fromJson).toList(growable: false);
    AppLogger.info('Parsed ${cities.length} cities', tag: 'DATA');
    return cities;
  }

  static List<dynamic> _extractList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map<String, dynamic>) {
      for (final key in const ['connections', 'cities', 'data', 'items', 'results']) {
        final value = raw[key];
        if (value is List) return value;
      }
    }
    AppLogger.error('Unexpected API response shape: ${raw.runtimeType}', tag: 'DATA');
    throw const FormatException('Expected a JSON list response');
  }
}
