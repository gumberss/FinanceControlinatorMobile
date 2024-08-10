class Result<T, E> {
  late bool isFailure;
  bool get isSuccess => !isFailure;
  E? _error;
  T? _value;
  T? get value =>
      isSuccess
          ? _value
          : throw Exception(
          "Result.Value can't be used when an error happened, please, check IsSuccess or IsFailure property before use Value property");

  E? get error => _error;

  Result(T value) {
    isFailure = false;
    _value = value;
    _error = null;
  }

  Result.fromError(E error) {
    isFailure = error != null;
    _value = null;
    _error = error;
  }
}
