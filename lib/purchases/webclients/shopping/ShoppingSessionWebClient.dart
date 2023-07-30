import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/Shopping.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShoppingSessionWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/shopping/active";
  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  ExistentShoppingWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<List<Shopping>?>> active(String listId) async {
    return await tryRequest(
        client.getUri(Uri.http(baseUrl, "$basePath/$listId"),
            options: defaultOptions),
        (response) => HttpResponseData(response.statusCode!,
            (response.data as List).map((e) => Shopping.fromJson(e)).toList()));
  }
}
