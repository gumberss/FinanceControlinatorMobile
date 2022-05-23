import 'dart:async';

import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:finance_controlinator_mobile/invoices/services/InvoiceSyncService.dart';
import 'package:finance_controlinator_mobile/invoices/services/SyncStorageService.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../authentications/services/AuthorizationService.dart';
import '../../expenses/components/InfiniteList.dart';
import '../webclients/InvoiceSyncWebClient.dart';

class Invoices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invoices List"), //from dto
      ),
      body: Column(
        children: [
          InvoiceOverview()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
        onPressed: () => {
          //Navigator.of(context)
          //    .push(MaterialPageRoute(builder: (c) => ExpensesScreen()))
        },
      ),
    );
  }
}

class InvoiceOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue.shade100,
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
            future: syncInvoices(),
            builder: (context, AsyncSnapshot<InvoiceSync?> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: const CircularProgressIndicator(),
                );
              }
              var response = snapshot.data!;
              //if (response.unauthorized()) {
              //AuthorizationService.redirectToSignIn(context);
              // return Text("Unauthorized :(");
              //       } else {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(response.syncName),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(response.syncName),
                  ),
                ],
              );
            }
            // },
            ),
      ),
    );
  }

  Future<InvoiceSync?> syncInvoices() async {
    var syncStorage = SyncStorageService();

    var lastSync = await syncStorage.stored();
    var response =
        await InvoiceSyncWebClient().GetSyncData(lastSync?.syncDate ?? 0);

    if (response.unauthorized()) {
      return null;
    }
    if (response.data == null) {
      return null;
    }
    var updated = InvoiceSyncService().updateSync(lastSync, response.data!);
    await syncStorage.store(updated);

    return updated;
  }
}
