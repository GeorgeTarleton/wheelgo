class RouteNotFoundException implements Exception {
  String cause;
  RouteNotFoundException(this.cause);
}