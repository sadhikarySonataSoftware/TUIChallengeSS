
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Manages the currently selected app language.
///
/// `null` means Flutter should use the device's preferred
/// language, falling back to a supported locale.
final localeProvider = StateProvider<Locale?>((ref) => null);
