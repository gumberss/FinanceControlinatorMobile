import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class LoggingInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint("Request: ${jsonEncode(options.data)}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      debugPrint("Response: ${jsonEncode(response.data)}");
      super.onResponse(response, handler);
    } catch (e) {
      debugPrint('I $e');
      rethrow;
    }
  }
}
