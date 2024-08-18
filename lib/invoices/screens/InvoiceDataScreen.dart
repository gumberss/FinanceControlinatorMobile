import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';

import 'package:flutter/material.dart';
import 'InvoiceItemsComponent.dart';
import 'InvoiceOverview.dart';

import 'package:flutter/cupertino.dart';

class InvoiceDataScreen extends StatelessWidget {
  InvoiceMonthData invoiceMonthData;

  InvoiceDataScreen(this.invoiceMonthData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 40,
          child: InvoiceOverviewScreen(invoiceMonthData.overview),
        ),
        Expanded(
            flex: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InvoiceItemsComponent(invoiceMonthData.invoice.items!),
            ))
      ],
    );
  }
}
