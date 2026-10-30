import '../../domain/entities/connection.dart';
import 'geo_point_model.dart';

class ConnectionModel extends Connection {
  const ConnectionModel({
    required super.departure,
    required super.destination,
    required super.price,
    required super.departurePoint,
    required super.destinationPoint,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    final departure = _string(json, const [
      'departure',
      'departure_city',
      'from',
      'origin',
    ]);
    final destination = _string(json, const [
      'destination',
      'destination_city',
      'to',
    ]);
    final price = _number(json, const ['price', 'cost', 'fare']);

    final departurePoint = _point(
      json,
      directKeys: const [
        ['departure_latitude', 'departure_longitude'],
        ['departure_lat', 'departure_lng'],
        ['from_latitude', 'from_longitude'],
        ['from_lat', 'from_lng'],
        ['origin_latitude', 'origin_longitude'],
        ['origin_lat', 'origin_lng'],
      ],
      nestedKeys: const ['departure_coordinates', 'departure_coordinate', 'from_coordinates', 'origin_coordinates'],
    );
    final destinationPoint = _point(
      json,
      directKeys: const [
        ['destination_latitude', 'destination_longitude'],
        ['destination_lat', 'destination_lng'],
        ['to_latitude', 'to_longitude'],
        ['to_lat', 'to_lng'],
      ],
      nestedKeys: const ['destination_coordinates', 'destination_coordinate', 'to_coordinates'],
    );

    return ConnectionModel(
      departure: departure,
      destination: destination,
      price: price,
      departurePoint: departurePoint,
      destinationPoint: destinationPoint,
    );
  }

  static String _string(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    }
    throw const FormatException('Connection city is missing');
  }

  static double _number(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) return value.toDouble();
      final parsed = double.tryParse(value?.toString() ?? '');
      if (parsed != null) return parsed;
    }
    throw const FormatException('Connection price is missing');
  }

  static GeoPointModel _point(
    Map<String, dynamic> json, {
    required List<List<String>> directKeys,
    required List<String> nestedKeys,
  }) {
    for (final pair in directKeys) {
      final lat = json[pair[0]];
      final lng = json[pair[1]];
      if (lat != null && lng != null) {
        return GeoPointModel.fromJson({'lat': lat, 'lng': lng});
      }
    }
    for (final key in nestedKeys) {
      final value = json[key];
      if (value != null) return GeoPointModel.fromJson(value);
    }
    throw const FormatException('Connection coordinates are missing');
  }
}
