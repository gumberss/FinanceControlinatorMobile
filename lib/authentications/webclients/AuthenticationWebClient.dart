import 'dart:convert';
import 'dart:io';

import 'package:finance_controlinator_mobile/authentications/domain/SignUpUser.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthenticationWebClient {
  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL'].toString(), "/SignUp");

  Future<int> signup(SignUpUser user) async {
    debugPrint(baseUri.toString());
    final response = await client.post(baseUri,
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
          .map((e) => e.splitMapJoin(RegExp(r'^(.{25}.*?) '), onMatch: (m)=> '${m[0]}\n'))
          .reduce((value, element) => value += "\n$element")
          .toString();
      throw new HttpException(descriptions);
    }

    return response.statusCode;
  }
}
