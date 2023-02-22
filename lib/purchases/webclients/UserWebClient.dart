import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/PurchaseCategory.dart';

class User {
  String? id;

  User(this.id);

  User.fromJson(Map<String, dynamic> json) : id = json['id'];

  Map<String, dynamic> toJson() => {'id': id};
}

class UserWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/users/register";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  UserWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<String?>> register() async {
    return await tryRequest(
        client.postUri(Uri.http(baseUrl, basePath), options: defaultOptions),
        (response) => HttpResponseData(
            response.statusCode!, User.fromJson(response.data).id));
  }
}
