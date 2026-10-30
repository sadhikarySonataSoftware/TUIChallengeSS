import 'package:flutter/material.dart';

import '../../domain/entities/connection.dart';
import '../../domain/entities/route_result.dart';
import 'route_map.dart';

class RouteResultCard extends StatelessWidget {
  const RouteResultCard({required this.route, super.key});

  final RouteResult route;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(radius: 24, child: Icon(Icons.savings_outlined)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cheapest route', style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        _formatPrice(route.totalPrice),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
                Chip(label: Text('${route.legs.length} ${route.legs.length == 1 ? 'leg' : 'legs'}')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (var i = 0; i < route.legs.length; i++) ...[
                  _LegTile(index: i + 1, connection: route.legs[i]),
                  if (i != route.legs.length - 1) const Divider(height: 24),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        RouteMap(route: route),
      ],
    );
  }

  static String _formatPrice(double value) => '\$${value.toStringAsFixed(2)}';
}

class _LegTile extends StatelessWidget {
  const _LegTile({required this.index, required this.connection});

  final int index;
  final Connection connection;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 14, child: Text('$index')),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${connection.departure}  →  ${connection.destination}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('Leg price: ${RouteResultCard._formatPrice(connection.price)}'),
            ],
          ),
        ),
      ],
    );
  }
}
