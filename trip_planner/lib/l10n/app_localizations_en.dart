// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Trip Planner';

  @override
  String get homeTitle => 'Where will you fly?';

  @override
  String get homeSubtitle =>
      'Pick a destination or build a route between any two cities.';

  @override
  String get exploreDestinations => 'Explore destinations';

  @override
  String get departureCity => 'Departure city';

  @override
  String get destinationCity => 'Destination city';

  @override
  String get chooseBothCities =>
      'Choose both cities to find the cheapest route.';

  @override
  String get chooseDifferentCities => 'Choose two different cities.';

  @override
  String get noRouteFound => 'No route found';

  @override
  String noRouteDescription(Object departure, Object destination) {
    return 'There is no available connection path from $departure to $destination.';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get retry => 'Retry';

  @override
  String get apiEmpty => 'The API returned no connections.';

  @override
  String get loadError => 'Unable to load connections.';

  @override
  String get networkError =>
      'Could not reach the local API. Make sure FastAPI is running on port 8000.';
}
