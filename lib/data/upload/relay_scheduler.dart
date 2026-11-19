abstract interface class RelayScheduler {
  Future<void> schedule(String messageId);

  Future<void> cancel(String messageId);
}
