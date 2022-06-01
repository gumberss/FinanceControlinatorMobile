import 'package:collection/collection.dart';
import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';

import 'package:flutter/material.dart';
import '../domain/sync/InvoiceSync.dart';
import 'InvoiceDataScreen.dart';

class InvoiceMonthDatasScreen extends StatelessWidget {
  List<InvoiceMonthData> invoiceMonthData;
  late PageController pageController;

  InvoiceMonthDatasScreen(this.invoiceMonthData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var initialMonthData =
    invoiceMonthData.where((element) => element.overview.status == 0);

    if (initialMonthData.isEmpty) {
      initialMonthData =
          invoiceMonthData.where((element) => element.overview.status == 2);
    }

    if (initialMonthData.isEmpty) {
      initialMonthData =
          invoiceMonthData.where((element) => element.overview.status == 4);
    }

    if (initialMonthData.isEmpty) {
      initialMonthData =
          invoiceMonthData.where((element) => element.overview.status == 3);
    }

    pageController = PageController(
      initialPage: invoiceMonthData.firstOrNull?.overview.status ??
          invoiceMonthData.length - 1,
    );
    PageView pageView = PageView(
      controller: pageController,
      children: invoiceMonthData
          .map((e) => Column(
        children: [Expanded(child: InvoiceDataScreen(e))],
      ))
          .toList(),
    );

    return pageView;
  }
}

