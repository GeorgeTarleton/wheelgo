import 'package:flutter/material.dart';

class PublicTransportRide {
  const PublicTransportRide({
    required this.startStation,
    required this.leavingTime,
    required this.line,
    required this.duration,
    required this.stops,
  });

  final String startStation;
  final TimeOfDay leavingTime;
  final String line;
  final Duration duration;
  final List<String> stops;
}