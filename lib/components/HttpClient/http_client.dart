import 'package:dio/dio.dart';
import 'package:finance_controlinator_mobile/components/HttpClient/Interceptors/AuthenticationInterceptor.dart';

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

  static Dio addInterceptors(Dio dio){
    dio.interceptors.add(LoggingInterceptor());
    dio.interceptors.add(AuthenticationInterceptor());
    return dio;
  }
}

final Dio clientWithoutInterceptor = _DioClient.client();
