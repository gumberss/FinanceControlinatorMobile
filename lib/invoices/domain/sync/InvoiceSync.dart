import 'dart:core';

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
  String totalCost;
  String closeDate;
  String dueDate;
  String paymentDate;
  int paymentStatus;

  List<InvoiceItem>? items;

  Invoice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        totalCost = json['totalCost'],
        closeDate = json['closeDate'],
        dueDate = json['dueDate'],
        paymentDate = json['paymentDate'],
        paymentStatus = json['paymentStatus'],
        items = (json['items'] as List?)
            ?.map((e) => InvoiceItem.fromJson(e))
            .toList();

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items?.map((e) => e.toJson()).toList(),
        'totalCost': totalCost,
        'closeDate': closeDate,
        'dueDate': dueDate,
        'paymentDate': paymentDate,
        'paymentStatus': paymentStatus,
      };
}

class InvoiceItem {
  String id;
  String installmentNumber;
  String installmentCost;
  int type;
  String purchaseDay;
  String title;

  InvoiceItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        installmentNumber = json['installmentNumber'],
        installmentCost = json['installmentCost'],
        type = json['type'],
        purchaseDay = json['purchaseDay'],
        title = json['title'];

  toJson() => {
        'id': id,
        'installmentNumber': installmentNumber,
        'installmentCost': installmentCost,
        'type': type,
        'purchaseDay': purchaseDay,
        'title': title,
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
