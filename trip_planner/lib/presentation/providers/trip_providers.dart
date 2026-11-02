import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/network/dio_provider.dart';
import '../../data/datasources/connections_remote_data_source.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../domain/entities/city.dart';
import '../../domain/entities/connection.dart';
import '../../domain/entities/route_result.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/usecases/find_cheapest_route.dart';

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  return TripRepositoryImpl(
    DioConnectionsRemoteDataSource(ref.watch(dioProvider)),
  );
});

final connectionsProvider = FutureProvider<List<Connection>>((ref) {
  return ref.watch(tripRepositoryProvider).getConnections();
});

final citiesProvider = FutureProvider<List<City>>((ref) async {
  try {
    return await ref.watch(tripRepositoryProvider).getCities();
  } catch (_) {
    // /cities is supplementary to the route graph. The carousel can still
    // derive city names from /connections if this endpoint is unavailable.
    return const <City>[];
  }
});

final selectedDepartureProvider = StateProvider<String?>((ref) => null);
final selectedDestinationProvider = StateProvider<String?>((ref) => null);



final availableCitiesProvider = Provider<List<String>>((ref) {
  final connections =
      ref.watch(connectionsProvider).asData?.value ??
          const <Connection>[];

  final apiCities =
      ref.watch(citiesProvider).asData?.value ??
          const <City>[];

  final cities = <String>{};

  for (final connection in connections) {
    cities.add(connection.departure);
    cities.add(connection.destination);
  }

  for (final city in apiCities) {
    cities.add(city.name);
  }

  return cities.toList()..sort();
});

final cheapestRouteProvider = Provider<RouteResult?>((ref) {
  final connections =
      ref.watch(connectionsProvider).asData?.value;

  final departure = ref.watch(selectedDepartureProvider);
  final destination = ref.watch(selectedDestinationProvider);

  if (connections == null ||
      departure == null ||
      destination == null) {
    return null;
  }

  return const FindCheapestRoute().call(
    connections: connections,
    departure: departure,
    destination: destination,
  );
});
