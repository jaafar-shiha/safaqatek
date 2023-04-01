import 'package:safaqtek/models/base_error_response.dart';

abstract class ResponseState<T> {
  factory ResponseState.success(T data) = SuccessState<T>;

  factory ResponseState.error(BaseErrorResponse error) = ErrorState<T>;

  factory ResponseState.loading() = LoadingState<T>;

}

class SuccessState<T> implements ResponseState<T> {
  final T data;

  const SuccessState(this.data);
}

class ErrorState<T> implements ResponseState<T> {
  final BaseErrorResponse error;

  ErrorState(this.error);
}

class LoadingState<T> implements ResponseState<T> {
  const LoadingState();
}