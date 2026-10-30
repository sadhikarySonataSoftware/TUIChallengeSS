import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../core/logging/app_logger.dart';
import '../../domain/entities/route_result.dart';

class RouteMap extends StatelessWidget {
  const RouteMap({required this.route, super.key});

  final RouteResult route;

  @override
  Widget build(BuildContext context) {
    final points = <LatLng>[];
    for (final leg in route.legs) {
      final from = LatLng(leg.departurePoint.latitude, leg.departurePoint.longitude);
      final to = LatLng(leg.destinationPoint.latitude, leg.destinationPoint.longitude);
      if (points.isEmpty || points.last != from) points.add(from);
      if (points.last != to) points.add(to);
    }

    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    AppLogger.debug(
      'Rendering route map with ${points.length} coordinate points',
      tag: 'MAP',
    );

    final bounds = LatLngBounds.fromPoints(points);
    final center = bounds.center;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 300,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 4,
            initialCameraFit: CameraFit.bounds(
              bounds: bounds,
              padding: const EdgeInsets.all(48),
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.trip_planner',
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points,
                  strokeWidth: 5,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: points.first,
                  width: 42,
                  height: 42,
                  child: const Icon(Icons.trip_origin, size: 32),
                ),
                if (points.length > 1)
                  Marker(
                    point: points.last,
                    width: 42,
                    height: 42,
                    child: const Icon(Icons.location_on, size: 36),
                  ),
              ],
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
