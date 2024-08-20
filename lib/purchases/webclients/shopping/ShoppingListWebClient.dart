
import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/ShoppingList.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';

class ShoppingListWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/shopping";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  ShoppingListWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<ShoppingList?>> getById(String shoppingId) async {
    return await tryRequest(
        client.getUri(Uri.http(baseUrl, "$basePath/list/$shoppingId"),
            options: defaultOptions),
        (response) => HttpResponseData(
            response.statusCode!, ShoppingList.fromJson(response.data)));
  }

  Future<HttpResponseData<ShoppingList?>> markItemsWithIA(
      String shoppingId, String image64) async {
    return await tryRequest(
        client.postUri(
            Uri.http(
                baseUrl, "$basePath/mark-items/$shoppingId"),
            options: defaultOptions,
            data: {"requestId": const Uuid().v4(), "image": image64}),
        (response) => HttpResponseData(
            response.statusCode!, ShoppingList.fromJson(response.data)));
  }
}
