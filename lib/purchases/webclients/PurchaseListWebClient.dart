import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/purchases/domain/PurchaseList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PurchaseListWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/purchases/lists";
  late Uri baseUri;

  PurchaseListWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<PurchaseList>> create(String name) async {
    final response = await client.postUri(baseUri,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: {"name": name});

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \ncreate the purchase list :(");
    }

    if (response.statusCode == 401) {
      throw const HttpException("Not Authorized :(");
    }

    if (response.statusCode == 400) {
      return throw HttpException(response.data!.error.message);
    }

    return HttpResponseData(
        response.statusCode!, PurchaseList.fromJson(response.data!));
  }

  Future<HttpResponseData<PurchaseList>> edit(PurchaseList purchaseList) async {
    final response = await client.putUri(baseUri,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: purchaseList.toJson());

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \nedit the purchase list :(");
    }

    if (response.statusCode == 401) {
      throw const HttpException("Not Authorized :(");
    }

    if (response.statusCode == 400) {
      return throw HttpException(response.data!.error.message);
    }

    return HttpResponseData(
        response.statusCode!, PurchaseList.fromJson(response.data!));
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

  Future<HttpResponseData<String>> disable(String id) async {
    final response;
    try {
      response = await client.deleteUri(Uri.http(baseUrl, basePath + "/$id"),
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

    return HttpResponseData(
        response.statusCode!, response.data['id']);
  }
}
