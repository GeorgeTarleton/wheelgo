import 'package:latlong2/latlong.dart';

import 'MarkerInfo.dart';

class DestinationCardParams {
  const DestinationCardParams({
    required this.name,
    required this.address,
    required this.distance,
    required this.markerInfo,
    required this.pos,
  });

  final String name;
  final String address;
  final String distance;
  final MarkerInfo markerInfo;
  final LatLng pos;
}