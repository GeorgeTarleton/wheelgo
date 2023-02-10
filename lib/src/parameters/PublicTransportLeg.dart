import 'package:flutter/material.dart';
import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import 'PublicTransportRide.dart';

class PublicTransportLeg implements TravelLeg {
  const PublicTransportLeg({
    required this.finalStation,
    required this.arrivalTime,
    required this.rides,
  });

  final String finalStation;
  final TimeOfDay arrivalTime;
  final List<PublicTransportRide> rides;

  @override
  TravelLegType getType() {
    return TravelLegType.publicTransport;
  }

  @override
  String toString() {
    return "PublicTransportLeg{finalStation: $finalStation, arrivalTime: $arrivalTime, rides: ${rides.toString()}";
  }
}