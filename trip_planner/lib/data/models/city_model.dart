import '../../domain/entities/city.dart';

class CityModel extends City {
  const CityModel({required super.name, super.imageUrl});

  factory CityModel.fromJson(dynamic raw) {
    if (raw is String) return CityModel(name: raw);
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Invalid city object');
    }
    final name = raw['name'] ?? raw['city'] ?? raw['city_name'];
    if (name == null || name.toString().trim().isEmpty) {
      throw const FormatException('City name is missing');
    }
    final image = raw['image_url'] ?? raw['imageUrl'] ?? raw['image'];
    return CityModel(
      name: name.toString().trim(),
      imageUrl: image?.toString(),
    );
  }
}
