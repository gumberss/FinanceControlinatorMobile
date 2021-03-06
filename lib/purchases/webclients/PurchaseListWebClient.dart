import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/PurchaseList.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PurchaseListWebClient {
  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString(),
      "/api/purchases/lists");

  Future<PurchaseList> save(PurchaseList purchaseList) async {
    final response = await client.postUri(baseUri,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: purchaseList.toJson());

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \ncreate the purchase list :(");
    }

    if (response.statusCode == 401) {
      throw const HttpException("Not Authorized :(");
    }

    return purchaseList;
  }

  Future<HttpResponseData<List<PurchaseList>>> getAll() async {
    final response;
    try {
      response = await client.getUri(baseUri,
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          }));
    } catch (Exception) {
      return HttpResponseData(500, null);
    }
    if (response.statusCode == 500) {
      return HttpResponseData(response.statusCode!, null);
    }

    if (response.statusCode == 401) {
      return HttpResponseData(response.statusCode!, null);
    }

    Iterable decodedData = response.data;

    return HttpResponseData(
        response.statusCode!,
        List<PurchaseList>.from(
            decodedData.map((e) => PurchaseList.fromJson(e))));
  }
}
