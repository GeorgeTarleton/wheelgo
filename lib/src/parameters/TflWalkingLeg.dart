import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import '../enums/TravelLegType.dart';

class TflWalkingLeg implements TravelLeg {
  final LatLng start;
  final LatLng finish;
  final Duration duration;

  const TflWalkingLeg({
    required this.start,
    required this.finish,
    required this.duration,
  });

  @override
  TravelLegType getType() {
    return TravelLegType.walking;
  }

  @override
  String toString() {
    return "TflWalkingLeg{start: $start, finish: $finish, duration: $duration}";
  }
}