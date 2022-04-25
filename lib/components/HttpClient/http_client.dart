import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'Interceptors/logging_interceptor.dart';

final Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
], requestTimeout: Duration(seconds: 10));

final Client clientWithoutInterceptor = Client();