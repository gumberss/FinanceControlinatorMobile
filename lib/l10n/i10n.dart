import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:intl/number_symbols_data.dart';

class i10n {
  static String toConcurrency(BuildContext context, number){
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    return format.format(number);
  }
  static String getCurrentLocale() {
    final locale = ui.window.locale;
    final joined = "${locale.languageCode}_${locale.countryCode}";
    if (numberFormatSymbols.keys.contains(joined)) {
      return joined;
    }
    return locale.languageCode;
  }

  static String currentLanguageDecimalSeparator() {
    return numberFormatSymbols[getCurrentLocale()]?.DECIMAL_SEP ?? "";
  }

  static String currentLanguageGroupSeparator() {
    return numberFormatSymbols[getCurrentLocale()]?.GROUP_SEP ?? "";
  }

  static String currentLanguageCurrencyCode() {
    return numberFormatSymbols[getCurrentLocale()]?.DEF_CURRENCY_CODE ?? "";
  }
}