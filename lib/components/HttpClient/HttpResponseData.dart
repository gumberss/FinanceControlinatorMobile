class HttpResponseData<T>{
  int statusCode;
  T? data;

  HttpResponseData(this.statusCode, this.data);

  bool unauthorized() => statusCode == 401;
}