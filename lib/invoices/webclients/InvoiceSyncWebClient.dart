import 'dart:io';

import 'package:dio/src/response.dart';
import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../components/HttpClient/HttpResponseData.dart';
import '../../components/HttpClient/http_client.dart';

class InvoiceSyncWebClient {
  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_INVOICE'].toString(),
      "/api/invoices/sync");

  Future<HttpResponseData<InvoiceSync?>> getSyncData(num lastSync) async {
    final Response response;

    try {
      response = await client.get(baseUri.toString(),
          queryParameters: {'timestamp': lastSync});
    } catch (Exception) {
      return HttpResponseData(500, null);
    }

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \nfind the overview :(");
    }

    if (response.statusCode == 401) {
      return HttpResponseData(response.statusCode!, null);
    }
    var invoiceSync = InvoiceSync.fromJson(response.data);
    return HttpResponseData(response.statusCode!, invoiceSync);
  }
}
