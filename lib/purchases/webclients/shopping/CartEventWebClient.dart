import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/ReorderItemEvent.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/shopping/cart/events/ChangeItemEvent.dart';
import '../../domain/shopping/cart/events/ReorderCategoryEvent.dart';

class CartEventWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/shopping-cart";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  CartEventWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<bool?>> sendReorderItemEvent(
      ReorderItemEvent itemEvent) async =>
      _sendEvent(itemEvent.toJson());

  Future<HttpResponseData<bool?>> sendReorderCategoryEvent(
          ReorderCategoryEvent categoryEvent) async =>
      _sendEvent(categoryEvent.toJson());

  Future<HttpResponseData<bool?>> sendChangeItemEvent(
      ChangeItemEvent itemEvent) async =>
      _sendEvent(itemEvent.toJson());

  Future<HttpResponseData<bool?>> _sendEvent(Map<String, dynamic> event) async {
    return await tryRequest(
        client.postUri(Uri.http(baseUrl, basePath + "/events"),
            options: defaultOptions, data: event),
        (response) => HttpResponseData(response.statusCode!, true));
  }
}
