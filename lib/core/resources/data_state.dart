import 'package:audiorecorder/core/resources/data_error.dart';

abstract class DataState<T> {
  final T? data;
  final DataError? error;
  const DataState({this.data, this.error});
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data: data);
}

class DataFailure<T> extends DataState<T> {
  const DataFailure(DataError error) : super(error: error);
}
