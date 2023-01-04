import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/enums/AttractionType.dart';

import '../enums/WheelchairRating.dart';
import '../parameters/Elevation.dart';
import '../parameters/MarkerInfo.dart';
import '../parameters/PlaceDetailParams.dart';
import '../parameters/PublicTransportLeg.dart';
import '../parameters/PublicTransportRide.dart';
import '../parameters/RoutingResultsPageParams.dart';
import '../parameters/WheelingDirection.dart';
import '../parameters/WheelingLeg.dart';
import '../widgets/MainMap.dart';

const exampleRRParams = RoutingResultsPageParams(
  duration: Duration(hours: 1, minutes: 5),
  distance: 20,
  arrivalTime: TimeOfDay(hour: 11, minute: 5),
  price: 5.20,
  start: "Start Location",
  destination: "Destination Location",
  elevation: Elevation(up: 10, down: 8),
  legs: [
    WheelingLeg(
      duration: Duration(minutes: 20),
      distance: 5,
      destination: "Partway Destination",
      directions: [
        WheelingDirection(description: "Direction1", distance: 2, duration: Duration(minutes: 8)),
        WheelingDirection(description: "Direction2", distance: 3, duration: Duration(minutes: 12)),
      ],
    ),
    PublicTransportLeg(finalStation: "Final Station", arrivalTime: TimeOfDay(hour: 11, minute: 5), rides: [
      PublicTransportRide(startStation: "Start Station", leavingTime: TimeOfDay(hour: 10, minute: 30), line: "Line1", duration: Duration(minutes: 10), stops: ["Stop 1", "Stop 2"]),
      PublicTransportRide(startStation: "Next Station", leavingTime: TimeOfDay(hour: 10, minute: 50), line: "Line2", duration: Duration(minutes: 10), stops: ["Stop 1", "Stop 2"]),
    ]),
    WheelingLeg(
      duration: Duration(minutes: 20),
      distance: 5,
      destination: "Partway Destination",
      directions: [
        WheelingDirection(description: "Direction1", distance: 2, duration: Duration(minutes: 8)),
        WheelingDirection(description: "Direction2", distance: 3, duration: Duration(minutes: 12)),
      ],
    ),
  ],
);


class QueryService {
  Map<Marker, MarkerInfo> markerInfoMap = {};

  PlaceDetailParams getPlaceDetail(int id, AttractionType type) {
    return PlaceDetailParams(
      name: "Place Name $id",
      category: "Category",
      wheelchairRating: WheelchairRating.yes,
      address: "Address",
      website: "Website",
    );
  }

  List<Marker> getMarkers() {
    debugPrint("Getting markers");

    Marker marker1 = Marker(
      point: LatLng(51.5013562, -0.1249302),
      width: markerSize,
      height: markerSize,
      builder: (ctx) => const Icon(
        Icons.location_pin,
        size: markerSize,
        color: Colors.blue,
      ),
    );
    markerInfoMap[marker1] = MarkerInfo(id: 1, type: AttractionType.node);

    Marker marker2 = Marker(
      point: LatLng(51.5032704, -0.1196257),
      width: markerSize,
      height: markerSize,
      builder: (context) => const Icon(
        Icons.location_pin,
        size: markerSize,
        color: Colors.blue,
      ),
    );
    markerInfoMap[marker2] = MarkerInfo(id: 2, type: AttractionType.way);

    return [marker1, marker2];
  }

}