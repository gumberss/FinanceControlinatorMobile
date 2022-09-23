import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/PurchaseList.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/PurchaseCategory.dart';
import '../domain/PurchaseItem.dart';
import '../domain/PurchaseListManagementData.dart';

class ItemWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/purchases/items";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  ItemWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<PurchaseItem?>> addItem(PurchaseItem item) async {
    return await tryRequest(
        client.postUri(Uri.http(baseUrl, basePath),
            options: defaultOptions, data: item.toJson()),
        (response) => HttpResponseData(
            response.statusCode!, PurchaseItem.fromJson(response.data)));
  }
}
