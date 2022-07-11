import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class i10n {
  String toConcurrency(BuildContext context, number){
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    return format.format(number);
  }
}