import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/enums/TravelLegType.dart';
import 'package:wheelgo/src/interfaces/TravelLeg.dart';

import 'PublicTransportRide.dart';

class PublicTransportLeg implements TravelLeg {
  const PublicTransportLeg({
    required this.finalStation,
    required this.arrivalTime,
    required this.duration,
    required this.rides,
    required this.path,
  });

  final String finalStation;
  final TimeOfDay arrivalTime;
  final Duration duration;
  final List<PublicTransportRide> rides;
  final List<LatLng> path;

  @override
  TravelLegType getType() {
    return TravelLegType.publicTransport;
  }

  @override
  String toString() {
    return "PublicTransportLeg{finalStation: $finalStation, arrivalTime: $arrivalTime, duration: $duration, rides: ${rides.toString()}";
  }
}