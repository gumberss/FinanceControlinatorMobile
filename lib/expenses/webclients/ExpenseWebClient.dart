import 'dart:convert';

import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExpenseWebClient {

  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL'].toString(), "/api/expenses");

  Future<Expense> save(Expense expense) async {
    final response = await client.post(baseUri,  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(expense.toJson()));
    return expense;
  }
}