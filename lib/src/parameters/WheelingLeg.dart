import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import 'WheelingDirection.dart';

class WheelingLeg implements TravelLeg {
  const WheelingLeg({
    required this.duration,
    required this.distance,
    required this.directions,
  });

  final Duration duration;
  final double distance;
  final List<WheelingDirection> directions;

  @override
  TravelLegType getType() {
    return TravelLegType.wheeling;
  }

  @override
  String toString() {
    return "WheelingLeg{duration: ${duration.inSeconds}, distance: $distance, directions: ${directions.toString()}}";
  }

}
