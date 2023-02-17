import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/parameters/PublicTransportLeg.dart';
import 'package:wheelgo/src/parameters/PublicTransportRide.dart';
import 'package:wheelgo/src/parameters/TflWalkingLeg.dart';

import '../interfaces/TravelLeg.dart';

class TFLResult {
  final Duration duration;
  final TimeOfDay arrivalTime;
  final double? price;
  final List<TravelLeg> legs;

  const TFLResult({
    required this.duration,
    required this.arrivalTime,
    this.price,
    required this.legs,
  });

  factory TFLResult.fromJson(Map<String, dynamic> json) {
    List<TravelLeg> legs = [];

    int i = 0;
    while (i < json['journeys'][0]['legs'].length) {
      dynamic leg = json['journeys'][0]['legs'][i];
      if (leg['mode']['id'] == "walking") {
        legs.add(TflWalkingLeg(
            start: LatLng(leg['departurePoint']['lat'], leg['departurePoint']['lon']),
            finish: LatLng(leg['arrivalPoint']['lat'], leg['arrivalPoint']['lon']),
            duration: Duration(minutes: leg['duration']),
        ));
        i++;
      }

      else {
        List<PublicTransportRide> rides = [];
        List<LatLng> legPath = [];
        while (json['journeys'][0]['legs'][i]['mode']['id'] != "walking" && i < json['journeys'][0]['legs'].length) {
          List<String> stops = [];
          for (final stop in leg['path']['stopPoints']) {
            stops.add(stop['name']);
          }

          List<dynamic> legPathStrs = jsonDecode(leg['path']['lineString']);
          legPath.addAll(legPathStrs.map((e) => LatLng(e[0], e[1])).toList());
          debugPrint("LEG PATH: ${legPath.toString()}");
          debugPrint("LEG PATH LEN: ${legPath.length}");
          debugPrint("CURRENT LEN: ${legPathStrs.map((e) => LatLng(e[0], e[1])).toList().length}");

          rides.add(PublicTransportRide(
              startStation: leg['path']['stopPoints'][0]['name'],
              leavingTime: TimeOfDay.fromDateTime(DateTime.parse(leg['departureTime'])),
              line: leg['routeOptions'][0]['lineIdentifier']['name'],
              duration: Duration(minutes: leg['duration']),
              stops: stops
          ));
          i++;
          debugPrint("I process public transport");
        }

        legs.add(PublicTransportLeg(
            finalStation: leg['path']['stopPoints'].last['name'],
            arrivalTime: TimeOfDay.fromDateTime(DateTime.parse(leg['arrivalTime'])),
            duration: Duration(minutes: leg['duration']),
            rides: rides,
            path: legPath,
        ));
      }
    }

    return TFLResult(
        duration: Duration(minutes: json['journeys'][0]['duration']),
        arrivalTime: TimeOfDay.fromDateTime(DateTime.parse(json['journeys'][0]['arrivalDateTime'])),
        price: json['journeys'][0]['fare'] == null ? null : (json['journeys'][0]['fare']['totalCost'] / 100),
        legs: legs
    );
  }

  @override
  String toString() {
    return "TFLResult{duration: $duration, arrivalTime: $arrivalTime, price: $price, legs: $legs}";
  }

}