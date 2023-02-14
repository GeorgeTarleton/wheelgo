import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';

List<dynamic> decodePolyline(String encodedPolyline, bool includeElevation) {
  // array that holds the points
  List<dynamic> points = [];
  int index = 0;
  int len = encodedPolyline.length;
  int lat = 0;
  int lng = 0;
  int ele = 0;
  while (index < len) {
    int b;
    int shift = 0;
    int result = 0;
    do {
      b = encodedPolyline[index++].codeUnitAt(0) - 63; // finds ascii
      // and subtract it by 63
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);

    lat += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    shift = 0;
    result = 0;
    do {
      b = encodedPolyline[index++].codeUnitAt(0) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    lng += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));

    if (includeElevation) {
      shift = 0;
      result = 0;
      do {
        b = encodedPolyline[index++].codeUnitAt(0) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      ele += ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    }
    try {
      var location = [(lat / 1E5), (lng / 1E5)];
      if (includeElevation) location.add((ele / 100));
      points.add(location);
    } on Exception catch(e) {
      debugPrint(e.toString());
    }
  }
  return points;
}

extension PolylineExt on List<dynamic> {
  List<LatLng> unpackPolyline() =>
      map((p) => LatLng(p[0].toDouble(), p[1].toDouble())).toList();
}