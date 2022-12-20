import '../interfaces/TravelLeg.dart';
import 'Elevation.dart';

class RoutingResultsPageParams {
  const RoutingResultsPageParams({
    required this.duration,
    required this.distance,
    required this.arrivalTime,
    this.price,
    required this.start,
    required this.destination,
    required this.legs,
    required this.elevation,
  });

  final Duration duration;
  final double distance;
  final DateTime arrivalTime;
  final double? price;
  final String start;
  final String destination;
  final List<TravelLeg> legs;
  final Elevation elevation;
}