class Resource<T> {
  final T? _data;
  final String? _error;

  Resource(this._data, this._error);

  bool get isSuccess => _data != null ;

  bool get isFailure => _error != null;
}

class Success<T> extends Resource<T> {
  final T data;

  Success(this.data) : super(data, null);
}

class Failure<T> extends Resource<T> {
  final String error;

  Failure(this.error) : super(null, error);
}
