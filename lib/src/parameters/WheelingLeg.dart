import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import 'WheelingDirection.dart';

class WheelingLeg implements TravelLeg {
  const WheelingLeg({
    required this.duration,
    required this.distance,
    required this.destination,
    required this.directions,
  });

  final Duration duration;
  final double distance;
  final String destination;
  final List<WheelingDirection> directions;

  @override
  TravelLegType getType() {
    return TravelLegType.wheeling;
  }
}
