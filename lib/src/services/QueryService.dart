import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:wheelgo/src/dtos/NominatimElement.dart';
import 'package:wheelgo/src/dtos/OverpassResponse.dart';
import 'package:wheelgo/src/enums/AttractionType.dart';
import 'package:wheelgo/src/exceptions/QueryFailedException.dart';
import 'package:wheelgo/src/interfaces/Address.dart';
import 'package:wheelgo/src/interfaces/RestrictionsData.dart';

import '../dtos/OSMElement.dart';
import '../enums/AttractionType.dart';
import '../enums/AttractionType.dart';
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
  final searchLimit = 10;
  final overpassUrl = "https://overpass.kumi.systems/api/interpreter";

  PlaceDetailParams getPlaceDetail(int id, AttractionType type) {
    return PlaceDetailParams(
      name: "Place Name $id",
      category: "Category",
      wheelchairRating: WheelchairRating.yes,
      address: Address(houseNumber: "5", street: "Street", postcode: "Postcode"),
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

  Future<List<Marker>> queryMarkers(LatLng sw, LatLng ne) async {
    debugPrint("Querying markers...");
    List<OSMElement> nodes = await queryNodes(sw, ne);

    // TODO Maybe find a more efficient way to do it
    Set<OSMElement> uniqueNodes = {};
    for (OSMElement node in nodes) {
      List<OSMElement> dupNodes = uniqueNodes.where((currentNode) =>
        // This is the smallest value I consider equal
       (currentNode.lat - node.lat).abs() < 0.0000004
            && (currentNode.lon - node.lon).abs() < 0.0000004).toList();

      if (dupNodes.isEmpty) {
        uniqueNodes.add(node);
      } else if (node.type == AttractionType.node) {
        uniqueNodes.removeAll(dupNodes);
        uniqueNodes.add(node);
      }
    }

    List<Marker> nodeMakers = uniqueNodes.map((node) {
        Marker nodeMarker = Marker(
          point: LatLng(node.lat, node.lon),
          width: markerSize,
          height: markerSize,
          builder: (context) => const Icon(
            Icons.location_pin,
            size: markerSize,
            color: Colors.blue,
          ),
        );
        markerInfoMap[nodeMarker] = MarkerInfo(id: node.id, type: node.type);

        return nodeMarker;
    }).toList();

    return nodeMakers;
  }

  Future<List<OSMElement>> queryNodes(LatLng southWest, LatLng northEast) async {
    String query = overpassUrl + "/api/interpreter?data=[out:json][bbox:${southWest.latitude}, ${southWest.longitude}, ${northEast.latitude}, ${northEast.longitude}];(node[\"amenity\"~\"bar|pub|biergarten|cafe|fast_food|food_court|ice_cream|restaurant|college|driving_school|kindergarten|language_school|library|toy_library|training|music_school|school|university|bank|bureau_de_change|clinic|dentist|doctors|hospital|nursing_home|pharmacy|social_facility|vetinary|arts_centre|casino|cinema|community_centre|conference_centre|events_venue|nightclub|planetarium|social_centre|studio|theatre|courthouse|police|post_office|prison|townhall|toilets|animal_shelter|childcare|crematorium|funeral_hall|internet_cafe|monastery|place_of_worship|public_bath\"][\"wheelchair\"];node[\"shop\"][\"wheelchair\"];node[\"public_transport\"~\"station|platform\"];node[\"tourism\"~\"aquarium|attraction|gallery|hostel|hotel|museum|theme_park|viewpoint|zoo|yes\"];node[\"tourism\"~\"information\"][\"information\"~\"office|visitor_centre\"];node[\"leisure\"~\"adult_gaming_centre|amusement_arcade|bowling_alley|dance|disc_golf_course|escape_game|fitness_centre|garden|golf_course|miniature_golf|resort|sports_centre|sports_hall|stadium|swimming_pool|track|tanning_salon|water_park\"][\"wheelchair\"];node[\"sport\"][\"wheelchair\"];);out body;(way[\"amenity\"~\"bar|pub|biergarten|cafe|fast_food|food_court|ice_cream|restaurant|college|driving_school|kindergarten|language_school|library|toy_library|training|music_school|school|university|bank|bureau_de_change|clinic|dentist|doctors|hospital|nursing_home|pharmacy|social_facility|vetinary|arts_centre|casino|cinema|community_centre|conference_centre|events_venue|nightclub|planetarium|social_centre|studio|theatre|courthouse|police|post_office|prison|townhall|toilets|animal_shelter|childcare|crematorium|funeral_hall|internet_cafe|monastery|place_of_worship|public_bath\"][\"wheelchair\"];way[\"shop\"][\"wheelchair\"];way[\"attraction\"];way[\"tourism\"~\"aquarium|attraction|gallery|hostel|hotel|museum|theme_park|viewpoint|zoo|yes\"][!\"highway\"];way[\"tourism\"~\"information\"][\"information\"~\"office|visitor_centre\"];way[\"leisure\"~\"adult_gaming_centre|amusement_arcade|bowling_alley|dance|disc_golf_course|escape_game|fitness_centre|garden|golf_course|miniature_golf|resort|sports_centre|sports_hall|stadium|swimming_pool|track|tanning_salon|water_park\"][\"wheelchair\"];way[\"sport\"][\"wheelchair\"];);out center;";
    final response = await http.get(Uri.parse(query));

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      OverpassResponse opResponse = OverpassResponse.fromJson(jsonDecode(response.body));
      return opResponse.elements;
    } else {
      throw QueryFailedException('Failed to load markers');
    }
  }

  Future<PlaceDetailParams> queryPlace(int id, AttractionType type) async {
    String query = overpassUrl + "/api/interpreter?data=[out:json];${describeEnum(type)}($id);out body;";
    final response = await http.get(Uri.parse(query));

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      PlaceDetailParams params = PlaceDetailParams.fromJson(jsonDecode(response.body)['elements'][0]['tags']);
      return params;
    } else {
      throw QueryFailedException('Failed to load place detail');
    }
  }

  Future<List<NominatimElement>> searchForPlace(String name) async {
    String query = "https://nominatim.openstreetmap.org/search?q=$name, Greater London&namedetails=1&addressdetails=1&limit=$searchLimit&format=json";
    final response = await http.get(Uri.parse(query));

    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      List<dynamic> results = jsonDecode(response.body);
      return results.map((r) => NominatimElement.fromJson(r)).toList();
    } else {
      throw QueryFailedException('Failed to search');
    }
  }

  Future<List<WheelingLeg>> queryORS(List<LatLng> coords, RestrictionsData restrictions) async {
    String query = "https://api.openrouteservice.org/v2/directions/wheelchair";
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
      'Authorization': "5b3ce3597851110001cf624826af508aff94406c98ec0eccd6725c15",
    };

    List<List<double>> parsedCoords = coords.map((e) => [e.longitude, e.latitude]).toList();

    List<int> skippedSegments = [];
    if (coords.length > 2) {
      for (int i=2; i < coords.length; i += 2) {
        skippedSegments.add(i);
      }
    }

    Map<String, dynamic> options = {
      'profile_params': {
        'allow_unsuitable': 'false',
        'restrictions': {
          'maximum_incline': '${restrictions.inclination}',
          'maximum_sloped_kerb': '${restrictions.maxKerbHeight}',
          'smoothness_type': '${restrictions.routeSmoothness}',
        }
      }
    };
    if (restrictions.avoidSteps) {
      options['avoid_features'] = ["steps"];
    }

    Map<String, dynamic> body = {
      'coordinates': parsedCoords,
      'elevation': 'true',
      'options': options,
    };
    if (skippedSegments.isNotEmpty) {
      body['skip_segments'] = json.encode(skippedSegments);
    }


    final response = await http.post(Uri.parse(query), headers: headers, body: json.encode(body));

    debugPrint(json.encode(body));
    debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return List.empty();
    } else {
      throw QueryFailedException('Failed to search');
    }
  }

}