import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trip_planner/presentation/pages/splash_screen.dart';

import 'core/logging/app_logger.dart';
import '../../l10n/app_localizations.dart';
import 'presentation/pages/home_page.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('Trip Planner starting', tag: 'APP');
  AppLogger.info(
    'Flutter debug logging enabled=${AppLogger.enabled}',
    tag: 'APP',
  );

  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}

// class TripPlannerApp extends StatelessWidget {
//   const TripPlannerApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Trip Planner',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: const Color(0xFF2563EB),
//         scaffoldBackgroundColor: const Color(0xFFF8FAFC),
//         inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
//         cardTheme: const CardThemeData(margin: EdgeInsets.zero, elevation: 1),
//       ),
//       home: const HomePage(),
//     ); 
//   }
// }


class TripPlannerApp extends StatelessWidget {
  const TripPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.zero,
          elevation: 1,
        ),
      ),
      locale: null,
      localizationsDelegates:
          AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}