import 'package:latlong2/latlong.dart';

import 'MarkerInfo.dart';

class DestinationCardParams {
  const DestinationCardParams({
    required this.name,
    this.address,
    this.distance,
    this.markerInfo,
    required this.pos,
  });

  final String name;
  final String? address;
  final String? distance;
  final MarkerInfo? markerInfo;
  final LatLng pos;

  @override
  String toString() {
    return "DestinationCardParams{name: $name, address: $address, distance: $distance, markerInfo: $markerInfo, pos: $pos}";
  }
}