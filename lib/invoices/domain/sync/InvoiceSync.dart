import 'package:flutter/cupertino.dart';

class InvoiceSync {
  String syncName;
  num syncDate;
  List<InvoiceMonthData> monthDataSyncs;

  InvoiceSync.fromJson(Map<String, dynamic> json)
      : syncName = json['syncName'],
        syncDate = json['syncDate'],
        monthDataSyncs = (json['monthDataSyncs'] as List)
            .map((e) => InvoiceMonthData.fromJson(e))
            .toList(growable: true);

  Map<String, dynamic> toJson() => {
        'syncName': syncName,
        'syncDate': syncDate,
        'monthDataSyncs': monthDataSyncs.map((e) => e.toJson()).toList(),
      };
}

class InvoiceMonthData {
  InvoiceOverview overview;
  Invoice invoice;

  InvoiceMonthData.fromJson(Map<String, dynamic> json)
      : overview = InvoiceOverview.fromJson(json['overview']),
        invoice = Invoice.fromJson(json['invoice']);

  Map<String, dynamic> toJson() =>
      {'overview': overview.toJson(), 'invoice': invoice.toJson()};
}

class InvoiceOverview {
  String date;
  String statusText;
  int status;
  String totalCost;
  List<InvoiceBrief> briefs;
  List<InvoicePartition> partitions;

  InvoiceOverview.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        statusText = json['statusText'],
        status = json['status'],
        totalCost = json['totalCost'],
        briefs = (json['briefs'] as List)
            .map((e) => InvoiceBrief.fromJson(e))
            .toList(growable: false),
        partitions = (json['partitions'] as List)
            .map((e) => InvoicePartition.fromJson(e))
            .toList(growable: false);

  Map<String, dynamic> toJson() => {
        'date': date,
        'statusText': statusText,
        'status': status,
        'totalCost': totalCost,
        'briefs': briefs.map((e) => e.toJson()).toList(),
        'partitions': partitions.map((e) => e.toJson()).toList(),
      };
}

class Invoice {
  String id;

  Invoice.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class InvoicePartition {
  int type;
  double percent;
  String typeText;
  num totalValue;

  InvoicePartition.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        percent = json['percent'],
        typeText = json['typeText'],
        totalValue = json['totalValue'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'percent': percent,
        'typeText': typeText,
        'totalValue': totalValue
      };
}

class InvoiceBrief {
  String text;
  int status;

  InvoiceBrief.fromJson(Map<String, dynamic> json)
      : text = json['text'],
        status = json['status'];

  Map<String, dynamic> toJson() => {'text': text, 'status': status};
}
