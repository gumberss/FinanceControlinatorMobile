import 'dart:convert';
import 'dart:io';

import 'package:finance_controlinator_mobile/authentications/domain/SignUpUser.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../domain/SignInUser.dart';

class AuthenticationWebClient {
  String baseUrl = dotenv.env['FINANCE_CONTROLINATOR_API_URL'].toString();

  Future<int> signUp(SignUpUser user) async {
    final response = await client.post(Uri.http(baseUrl, "/SignUp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to \ncreate the user :(");

    if (response.statusCode == 400) {
      var decodedJson = jsonDecode(response.body);
      var descriptions = (decodedJson as List)
          .map((e) => e["description"].toString())
          .map((e) => e.splitMapJoin(RegExp(r'^(.{25}.*?) '),
              onMatch: (m) => '${m[0]}\n'))
          .reduce((value, element) => value += "\n$element")
          .toString();
      throw new HttpException(descriptions);
    }

    return response.statusCode;
  }

  Future<String?> signIn(SignInUser user) async {
    final response = await clientWithoutInterceptor.post(Uri.http(baseUrl, "/SignIn"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()));

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to sign in :(");

    if (response.statusCode == 401) {
      throw new HttpException("User name or password is invalid");
    }

    if(response.statusCode == 200)
      return jsonDecode(response.body)["token"];

    return null;
  }
}
