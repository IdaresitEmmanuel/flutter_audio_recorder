abstract class Usecase<T, Params> {
  Future<T> call({required Params params});
}
