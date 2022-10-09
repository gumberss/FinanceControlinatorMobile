class HttpResponseData<T> {
  int statusCode;
  String? errorMessage;
  T? data;

  HttpResponseData(this.statusCode, this.data);

  withErrorMessage(String errMes) {
    errorMessage = errMes;
    return this;
  }

  bool unauthorized() => statusCode == 401;
  bool notFound() => statusCode == 404;


  bool serverError() => statusCode >= 500;

  bool success() => statusCode >= 200 && statusCode < 300;
}
