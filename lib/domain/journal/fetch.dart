sealed class Fetch<T> {
  const Fetch();

  static Future<Fetch<T>> of<T>(Future<Fetched<T>> read) =>
      read.then<Fetch<T>>((fetched) => fetched, onError: FetchFailed<T>.new);
}

final class Fetched<T> extends Fetch<T> {
  const Fetched(this.value, {required this.readAt});

  final T value;
  final DateTime readAt;
}

final class FetchFailed<T> extends Fetch<T> {
  const FetchFailed(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}
