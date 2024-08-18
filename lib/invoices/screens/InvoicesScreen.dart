import 'dart:async';
import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:finance_controlinator_mobile/invoices/services/InvoiceSyncService.dart';
import 'package:finance_controlinator_mobile/invoices/services/SyncStorageService.dart';

import 'package:flutter/material.dart';
import '../webclients/InvoiceSyncWebClient.dart';
import 'InvoiceMonthDatasScreen.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: syncInvoices(),
        builder: (context, AsyncSnapshot<InvoiceSync?> snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Loading"), //from dto
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          }

          var response = snapshot.data!;
          //if (response.unauthorized()) {
          //AuthorizationService.redirectToSignIn(context);
          // return Text("Unauthorized :(");
          //       } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(response.syncName), //from dto
            ),
            body: InvoiceMonthDatasScreen(response.monthDataSyncs),
          );
        }
        // },
        );
  }

  Future<InvoiceSync?> syncInvoices() async {
    var syncStorage = SyncStorageService();

    var lastSync = await syncStorage.stored();
    var response =
        await InvoiceSyncWebClient().getSyncData(lastSync?.syncDate ?? 0);

    //todo: if timeout happen, show a toast
    if (response.unauthorized()) {
      return null;
    }
    if (response.data == null) {
      return lastSync;
    }
    var updated = InvoiceSyncService().updateSync(lastSync, response.data!);
    await syncStorage.store(updated);

    return updated;
  }
}
