class PublicTransportRide {
  const PublicTransportRide({
    required this.startStation,
    required this.line,
    required this.duration,
    required this.stops,
  });

  final String startStation;
  final String line;
  final Duration duration;
  final List<String> stops;
}