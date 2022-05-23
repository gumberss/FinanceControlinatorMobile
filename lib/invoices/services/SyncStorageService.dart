import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/sync/InvoiceSync.dart';

class SyncStorageService {
  Future<InvoiceSync?> stored() async {
    const storage = FlutterSecureStorage();
    var syncString = await storage.read(key: 'invoiceSync');

    if(syncString == null) return (null as InvoiceSync);
    return InvoiceSync.fromJson(jsonDecode(syncString));
  }

  Future store(InvoiceSync syncData) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'invoiceSync', value: jsonEncode(syncData.toJson()));
  }
}
