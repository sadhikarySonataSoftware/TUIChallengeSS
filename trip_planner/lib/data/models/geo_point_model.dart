import '../../domain/entities/geo_point.dart';

class GeoPointModel extends GeoPoint {
  const GeoPointModel({required super.latitude, required super.longitude});

  factory GeoPointModel.fromJson(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final lat = _number(raw['lat'] ?? raw['latitude']);
      final lng = _number(raw['lng'] ?? raw['lon'] ?? raw['longitude']);
      if (lat != null && lng != null) {
        return GeoPointModel(latitude: lat, longitude: lng);
      }
    }
    if (raw is List && raw.length >= 2) {
      final first = _number(raw[0]);
      final second = _number(raw[1]);
      if (first != null && second != null) {
        // Challenge datasets commonly use [latitude, longitude].
        return GeoPointModel(latitude: first, longitude: second);
      }
    }
    throw const FormatException('Invalid geographic coordinate object');
  }

  static double? _number(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
