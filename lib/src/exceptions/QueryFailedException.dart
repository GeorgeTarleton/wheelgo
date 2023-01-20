class QueryFailedException implements Exception {
  String cause;
  QueryFailedException(this.cause);
}