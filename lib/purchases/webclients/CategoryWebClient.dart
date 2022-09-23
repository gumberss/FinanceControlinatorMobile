import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/PurchaseList.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/PurchaseCategory.dart';
import '../domain/PurchaseItem.dart';
import '../domain/PurchaseListManagementData.dart';

class CategoryWebClient {

  String baseUrl =
  dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/purchases/categories";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  CategoryWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<PurchaseCategory?>> addCategory(PurchaseCategory category) async {
    return await tryRequest(
        client.postUri(
            Uri.http(baseUrl, basePath),
            options: defaultOptions,
            data: category.toJson()),
            (response) => HttpResponseData(
            response.statusCode!, PurchaseCategory.fromJson(response.data)));
  }

  Future<HttpResponseData<PurchaseCategory?>> changeCategoryOrder(
      String categoryId, int newPosition) async {
    return await tryRequest(
        client.putUri(
            Uri.http(
                baseUrl,
                basePath +
                    "/$categoryId/changeOrder/$newPosition"),
            options: defaultOptions),
            (response) => HttpResponseData(response.statusCode!, null));
  }
}
