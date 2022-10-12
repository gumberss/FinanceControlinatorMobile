import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/Shopping.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/ShoppingInitiation.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/ShoppingInitiationDataRequest.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../domain/shopping/ShoppingInitiationDataResponse.dart';

class ShoppingInitiationWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/shopping/init";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  ItemWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<Shopping?>> init(ShoppingInitiation item) async {
    return await tryRequest(
        client.postUri(Uri.http(baseUrl, basePath),
            options: defaultOptions, data: item.toJson()),
        (response) => HttpResponseData(
            response.statusCode!, Shopping.fromJson(response.data)));
  }

  Future<HttpResponseData<ShoppingInitiationDataResponse?>> initData(
      ShoppingInitiationDataRequest dataRequest) async {
    return await tryRequest(
        client.get(Uri.http(baseUrl, basePath).toString(),
            options: defaultOptions, queryParameters: dataRequest.toJson()),
        (response) => HttpResponseData(response.statusCode!,
            ShoppingInitiationDataResponse.fromJson(response.data)));
  }
}
