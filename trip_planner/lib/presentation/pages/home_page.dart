
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/city.dart';
import '../../l10n/app_localizations.dart';
import '../providers/trip_providers.dart';
import '../widgets/city_carousel.dart';
import '../widgets/route_result_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    final connections = ref.watch(connectionsProvider);
    final cities = ref.watch(citiesProvider);
    final availableCities = ref.watch(availableCitiesProvider);
    final selectedDeparture = ref.watch(selectedDepartureProvider);
    final selectedDestination = ref.watch(selectedDestinationProvider);
    final route = ref.watch(cheapestRouteProvider);

    final carouselCities = cities.value?.isNotEmpty == true
        ? cities.value!
        : availableCities
            .map((name) => City(name: name))
            .toList(growable: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: () => ref.invalidate(connectionsProvider),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: connections.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => _ErrorState(
          message: _friendlyError(error, l10n),
          retryLabel: l10n.retry,
          onRetry: () => ref.invalidate(connectionsProvider),
        ),
        data: (connectionData) {
          if (connectionData.isEmpty) {
            return _EmptyState(message: l10n.apiEmpty);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(connectionsProvider);
              await ref.read(connectionsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
              children: [
                Text(
                  l10n.homeTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(l10n.homeSubtitle),
                const SizedBox(height: 20),

                if (carouselCities.isNotEmpty) ...[
                  Text(
                    l10n.exploreDestinations,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  CityCarousel(
                    cities: carouselCities,
                    onSelected: (city) {
                      ref
                          .read(selectedDestinationProvider.notifier)
                          .state = city;
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                _CityDropdown(
                  label: l10n.departureCity,
                  value: selectedDeparture,
                  cities: availableCities,
                  onChanged: (value) {
                    ref
                        .read(selectedDepartureProvider.notifier)
                        .state = value;
                  },
                ),
                const SizedBox(height: 12),

                _CityDropdown(
                  label: l10n.destinationCity,
                  value: selectedDestination,
                  cities: availableCities,
                  onChanged: (value) {
                    ref
                        .read(selectedDestinationProvider.notifier)
                        .state = value;
                  },
                ),
                const SizedBox(height: 20),

                if (selectedDeparture == null ||
                    selectedDestination == null)
                  _HintState(
                    message: l10n.chooseBothCities,
                  )
                else if (selectedDeparture.trim().toLowerCase() ==
                    selectedDestination.trim().toLowerCase())
                  _HintState(
                    message: l10n.chooseDifferentCities,
                  )
                else if (route == null)
                  _NoRouteState(
                    departure: selectedDeparture,
                    destination: selectedDestination,
                    title: l10n.noRouteFound,
                    description: l10n.noRouteDescription(
                      selectedDeparture,
                      selectedDestination,
                    ),
                  )
                else
                  RouteResultCard(route: route),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _friendlyError(
    Object error,
    AppLocalizations l10n,
  ) {
    final text = error.toString().toLowerCase();

    if (text.contains('socketexception') ||
        text.contains('connection')) {
      return l10n.networkError;
    }

    return '${l10n.loadError} $error';
  }
}

class _CityDropdown extends StatelessWidget {
  const _CityDropdown({
    required this.label,
    required this.value,
    required this.cities,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> cities;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final safeValue = cities.contains(value) ? value : null;

    return DropdownButtonFormField<String>(
      initialValue: safeValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.flight_takeoff_rounded),
      ),
      items: [
        for (final city in cities)
          DropdownMenuItem(
            value: city,
            child: Text(city),
          ),
      ],
      onChanged: onChanged,
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 56),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _HintState extends StatelessWidget {
  const _HintState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(Icons.info_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _NoRouteState extends StatelessWidget {
  const _NoRouteState({
    required this.departure,
    required this.destination,
    required this.title,
    required this.description,
  });

  final String departure;
  final String destination;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.route_rounded, size: 42),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
