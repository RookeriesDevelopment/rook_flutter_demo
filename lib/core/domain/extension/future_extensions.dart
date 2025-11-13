extension FutureExtensions<T, R> on Future<T> {
  Future<R> fold(
    Future<R> Function(T value) onSuccess,
    Future<R> Function(dynamic error) onFailure,
  ) async {
    try {
      final value = await this;
      return onSuccess(value);
    } catch (error) {
      return onFailure(error);
    }
  }
}
