import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/ShoppingList.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/shopping/cart/events/ReorderCategoryEvent.dart';

class ShoppingListWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/shopping/list";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  ShoppingListWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<ShoppingList?>> getById(String shoppingId) async {
    return await tryRequest(
        client.getUri(Uri.http(baseUrl, basePath + "/$shoppingId"),
            options: defaultOptions),
        (response) => HttpResponseData(
            response.statusCode!, ShoppingList.fromJson(response.data)));
  }
}
