import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import 'PublicTransportRide.dart';

class PublicTransportLeg implements TravelLeg {
  const PublicTransportLeg({
    required this.finalStation,
    required this.rides,
  });

  final String finalStation;
  final List<PublicTransportRide> rides;

  @override
  TravelLegType getType() {
    return TravelLegType.publicTransport;
  }
}