import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:collection/collection.dart';

class InvoiceSyncService {
  InvoiceSync updateSync(InvoiceSync? current, InvoiceSync newer) {
    if (current == null || current.monthDataSyncs == null) return newer;

    current.syncDate = newer.syncDate;
    current.syncName = newer.syncName;

    if (newer.monthDataSyncs == null) return current;

    var newData = newer.monthDataSyncs!.where((x) {
      return current.monthDataSyncs!
          .map((e) => e.invoice.id)
          .contains(x.invoice.id);
    });

    for (var cur in current.monthDataSyncs!) {
      var updated = newer.monthDataSyncs!
          .firstWhereOrNull((e) => e.invoice.id == cur.invoice.id);

      if (updated == null) continue;

      cur.invoice = updated.invoice;
      cur.overview = updated.overview;
    }

    current.monthDataSyncs!.addAll(newData);

    return current;
  }
}
