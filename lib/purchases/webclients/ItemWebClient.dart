
import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/PurchaseItem.dart';

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

  Future<HttpResponseData<PurchaseItem?>> changeItemOrder(
      String itemId, String newCategoryId, int newPosition) async {
    return await tryRequest(
        client.putUri(
            Uri.http(baseUrl,
                "$basePath/$itemId/changeOrder/$newCategoryId/$newPosition"),
            options: defaultOptions),
        (response) => HttpResponseData(response.statusCode!, null));
  }

  Future<HttpResponseData<PurchaseItem?>> changeItemQuantity(
      String itemId, int newQuantity) async {
    return await tryRequest(
        client.putUri(
            Uri.http(
                baseUrl, "$basePath/$itemId/changeQuantity/$newQuantity"),
            options: defaultOptions),
        (response) => HttpResponseData(response.statusCode!, null));
  }

  Future<HttpResponseData<PurchaseItem?>> removeItem(
      String itemId) async {
    return await tryRequest(
        client.deleteUri(Uri.http(baseUrl, "$basePath/$itemId"),
            options: defaultOptions),
        (response) => HttpResponseData(response.statusCode!, null));
  }

  Future<HttpResponseData<PurchaseItem?>> editItemName(
      String itemId, String newName) async {
    return await tryRequest(
        client.putUri(Uri.http(baseUrl, "$basePath/$itemId/changeName/$newName"),
            options: defaultOptions),
            (response) => HttpResponseData(response.statusCode!, null));
  }
}
