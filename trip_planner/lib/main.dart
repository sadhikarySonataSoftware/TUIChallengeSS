import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/presentation/app/trip_planner_app.dart';

import 'core/logging/app_logger.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('Trip Planner starting', tag: 'APP');
  AppLogger.info(
    'Flutter debug logging enabled=${AppLogger.enabled}',
    tag: 'APP',
  );

  runApp(
    const ProviderScope(
      child: TripPlannerApp(),
    ),
  );
}




