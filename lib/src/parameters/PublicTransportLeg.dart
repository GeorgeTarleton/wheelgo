import 'package:flutter/material.dart';
import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import 'PublicTransportRide.dart';

class PublicTransportLeg implements TravelLeg {
  const PublicTransportLeg({
    required this.finalStation,
    required this.arrivalTime,
    required this.duration,
    required this.rides,
  });

  final String finalStation;
  final TimeOfDay arrivalTime;
  final Duration duration;
  final List<PublicTransportRide> rides;

  @override
  TravelLegType getType() {
    return TravelLegType.publicTransport;
  }

  @override
  String toString() {
    return "PublicTransportLeg{finalStation: $finalStation, arrivalTime: $arrivalTime, duration: $duration, rides: ${rides.toString()}";
  }
}