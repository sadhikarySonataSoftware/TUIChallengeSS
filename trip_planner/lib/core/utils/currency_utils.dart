import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getDeviceCurrencyCode(BuildContext context) {
  final locale = Localizations.localeOf(context);

  return NumberFormat.simpleCurrency(
        locale: locale.toString(),
      ).currencyName ??
      'IND';
}