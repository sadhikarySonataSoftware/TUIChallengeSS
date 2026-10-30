import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Central application logger.
///
/// Debug builds log by default. Profile/release builds can explicitly enable
/// verbose logs with --dart-define=ENABLE_VERBOSE_LOGS=true.
class AppLogger {
  const AppLogger._();

  static const bool _compileTimeEnabled = bool.fromEnvironment(
    'ENABLE_VERBOSE_LOGS',
    defaultValue: false,
  );

  static bool get enabled => kDebugMode || _compileTimeEnabled;

  static void debug(String message, {String tag = 'APP'}) {
    _write(message, tag: tag, level: 700);
  }

  static void info(String message, {String tag = 'APP'}) {
    _write(message, tag: tag, level: 800);
  }

  static void warning(String message, {String tag = 'APP'}) {
    _write(message, tag: tag, level: 900);
  }

  static void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String tag = 'APP',
  }) {
    if (!enabled) return;

    final line = '[TripPlanner.$tag] $message';
    // debugPrint makes logs visible in the terminal/Flutter console, while
    // developer.log keeps them structured and filterable in DevTools.
    debugPrint(line);
    developer.log(
      message,
      name: 'TripPlanner.$tag',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _write(
    String message, {
    required String tag,
    required int level,
  }) {
    if (!enabled) return;

    final line = '[TripPlanner.$tag] $message';
    debugPrint(line);
    developer.log(message, name: 'TripPlanner.$tag', level: level);
  }
}
