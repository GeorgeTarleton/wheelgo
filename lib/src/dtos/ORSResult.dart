import 'package:wheelgo/src/parameters/Elevation.dart';
import 'package:wheelgo/src/parameters/WheelingDirection.dart';

import '../parameters/WheelingLeg.dart';

class ORSResult {
  final double distance;
  final Duration duration;
  final Elevation elevation;
  final List<WheelingLeg> legs;

  const ORSResult({
    required this.distance,
    required this.duration,
    required this.elevation,
    required this.legs,
  });

  factory ORSResult.fromJson(Map<String, dynamic> json) {
    List<dynamic> segments = json['routes'][0]['segments'];
    List<WheelingLeg> legs = [];
    for (int i=0; i < segments.length; i += 2) {
      List<WheelingDirection> directions = [];
      for (final direction in segments[i]['steps']) {
        directions.add(WheelingDirection(
            description: direction['instruction'],
            distance: direction['distance'],
            duration: Duration(seconds: direction['duration'].round())
        ));
      }

      legs.add(WheelingLeg(
          duration: Duration(seconds: segments[i]['duration'].round()),
          distance: segments[i]['distance'] / 1000,
          directions: directions,
      ));
    }

    double elevationUp = json['routes'][0]['summary']['ascent'] ?? 0;
    double elevationDown = json['routes'][0]['summary']['descent'] ?? 0;
    return ORSResult(
        elevation: Elevation(up: elevationUp.round(), down: elevationDown.round()),
        duration: Duration(seconds: json['routes'][0]['summary']['duration'].round()),
        distance: json['routes'][0]['summary']['distance'] / 1000,
        legs: legs,
    );
  }

  @override
  String toString() {
    return "ORSResult{distance: $distance, duration: ${duration.inSeconds}, elevation: $elevation, legs: $legs}";
  }
}