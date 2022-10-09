import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/Interceptors/AuthenticationInterceptor.dart';
import 'package:flutter/material.dart';
import 'HttpResponseData.dart';

import 'Interceptors/logging_interceptor.dart';

final Dio client = _DioClient.addInterceptors(_DioClient.client());

class _DioClient {
  static Dio client() {
    var dio = Dio();
    dio.options.validateStatus = (status) {
      return true;
    };
    dio.options.connectTimeout = 5000;

    return dio;
  }

  static Dio addInterceptors(Dio dio) {
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return dio;
  }
}

final Dio clientWithoutInterceptor = _DioClient.client();

Future<HttpResponseData<T?>> tryRequest<T>(Future<Response> request,
    HttpResponseData<T?> Function(Response) onSuccess) async {
  final Response response;
  try {
    response = await request;
  } on Exception {
    return HttpResponseData(500, null);
  }
  if (response.statusCode == 500) {
    return HttpResponseData(response.statusCode!, null);
  }

  if (response.statusCode == 400) {
    return HttpResponseData(response.statusCode!, null)
        .withErrorMessage(response.data!["message"]);
  }

  if (response.statusCode == 401) {
    return HttpResponseData(response.statusCode!, null);
  }

  if (response.statusCode == 404) {
    return HttpResponseData(response.statusCode!, null);
  }
  debugPrint(response.data?.toString());
  return onSuccess(response);
}
