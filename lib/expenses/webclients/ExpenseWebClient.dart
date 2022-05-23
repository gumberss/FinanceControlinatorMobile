import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/HttpResponseData.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/http_client.dart';
import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpenseOverview.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ExpenseWebClient {
  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_EXPENSE'].toString(),
      "/api/expenses");

  Future<Expense> save(Expense expense) async {
    final response = await client.postUri(baseUri,
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }),
        data: expense.toJson());

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \ncreate the expense :(");
    }

    if (response.statusCode == 401) {
      throw const HttpException(
          "Not Authorized :(");
    }

    return expense;
  }

  Future<List<Expense>> getPage(int page, int count) async {
    final response =
        await client.getUri(baseUri.replace(path: "api/expenses/$page/$count"),
            options: Options(headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            }));

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \nGet the expense list :(");
    }

    if (response.statusCode == 401) {
      return List.empty();
    }

    Iterable expenseDecoded = response.data;

    return List<Expense>.from(expenseDecoded.map((e) => Expense.fromJson(e)));
  }
}

class ExpenseOverviewWebClient {
  Uri baseUri = Uri.http(
      dotenv.env['FINANCE_CONTROLINATOR_API_URL_EXPENSE'].toString(),
      "/api/expenses/overview");

  Future<HttpResponseData<ExpenseOverview>> GetOverview() async {
    final response = await client.getUri(baseUri);

    if (response.statusCode == 500) {
      throw const HttpException(
          "It was not possible to \nfind the overview :(");
    }

    if (response.statusCode == 401) {
      return HttpResponseData(response.statusCode!, null);
    }
    var expenseOverview = ExpenseOverview.fromJson(response.data);
    return HttpResponseData(response.statusCode!, expenseOverview);
  }
}
