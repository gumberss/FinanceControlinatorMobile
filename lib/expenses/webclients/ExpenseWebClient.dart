import 'dart:convert';
import 'dart:io';

import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExpenseWebClient {
  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL'].toString(), "/api/expenses");

  Future<Expense> save(Expense expense) async {
    final response = await client.post(baseUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expense.toJson()));

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to \ncreate the expense :(");

    return expense;
  }

  Future<List<Expense>> getPage(int page, int count) async {
    final response = await client.get(
        baseUri.replace(path: "api/expenses/$page/$count"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    debugPrint(response.body);

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to \nGet the expense list :(");

    Iterable expenseDecoded = json.decode(response.body);

    return  List<Expense>.from(expenseDecoded.map((e) => Expense.fromJson(e))) ;
  }
}

class ExpenseOverviewWebClient {
  Uri baseUri = Uri.http(dotenv.env['FINANCE_CONTROLINATOR_API_URL'].toString(),
      "/api/expenses/overview");

  Future<ExpenseOverview> GetOverview() async {
    final response = await client.get(baseUri);

    if (response.statusCode == 500)
      throw new HttpException("It was not possible to \nfind the overview :(");

    var expenseOverview = ExpenseOverview.fromJson(jsonDecode(response.body));

    return expenseOverview;
  }
}
