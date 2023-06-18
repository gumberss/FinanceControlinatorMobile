import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/PurchaseCategory.dart';

class User {
  String? id;
  String? nickname;

  User(this.id);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nickname = json['nickname'];

  Map<String, dynamic> toJson() => {'id': id};
}

class UserWebClient {
  String baseUrl =
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_PURCHASE_LIST'].toString();
  String basePath = "/api/users";

  late Uri baseUri;

  Options defaultOptions = Options(headers: {
    'Content-Type': 'application/json; charset=UTF-8',
  });

  UserWebClient() {
    baseUri = Uri.http(baseUrl, basePath);
  }

  Future<HttpResponseData<User?>> register(String userExternalId) async {
    return await tryRequest(
        client.postUri(Uri.http(baseUrl, "$basePath/register"),
            data: {"userExternalId": userExternalId}, options: defaultOptions),
        (response) {
         return HttpResponseData(
              response.statusCode!, User.fromJson(response.data));
        });
  }

  Future<HttpResponseData<User?>> setNickname(String nickname) async {
    return await tryRequest(
        client.postUri(Uri.http(baseUrl, "$basePath/nickname"),
            options: defaultOptions, data: {"nickname": nickname}),
        (response) => HttpResponseData(
            response.statusCode!, User.fromJson(response.data)));
  }
}
