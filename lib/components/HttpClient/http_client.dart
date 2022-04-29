import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/Interceptors/AuthenticationInterceptor.dart';

import 'Interceptors/logging_interceptor.dart';

final Dio client = _DioClient.client();

class _DioClient {
  static Dio client() {
    var dio = Dio();
    dio.options.validateStatus = (status) {
      return true;
    };
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return dio;
  }
}

final Dio clientWithoutInterceptor = Dio();
