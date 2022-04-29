import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/authentications/domain/SignUpUser.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/SignInUser.dart';

class AuthenticationWebClient {
  String baseUrl = dotenv.env['FINANCE_CONTROLINATOR_API_URL'].toString();

  Future<int> signUp(SignUpUser user) async {
    final response = await client.postUri(Uri.http(baseUrl, "/SignUp"),
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: user.toJson());

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to \ncreate the user :(");

    if (response.statusCode == 400) {
      var descriptions = (response.data as List)
          .map((e) => e["description"].toString())
          .map((e) => e.splitMapJoin(RegExp(r'^(.{25}.*?) '),
              onMatch: (m) => '${m[0]}\n'))
          .reduce((value, element) => value += "\n$element")
          .toString();
      throw new HttpException(descriptions);
    }

    return response.statusCode!;
  }

  Future<String?> signIn(SignInUser user) async {
    final response =
        await clientWithoutInterceptor.postUri(Uri.http(baseUrl, "/SignIn"),
            options: Options(headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            }),
            data: user.toJson());

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to sign in :(");

    if (response.statusCode == 401) {
      throw new HttpException("User name or password is invalid");
    }

    if (response.statusCode == 200) return response.data["token"];

    return null;
  }
}
