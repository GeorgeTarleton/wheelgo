import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/enums/AttractionType.dart';

class AttractionMarker extends Marker {
  final int id;
  final AttractionType type;

  AttractionMarker({
    required LatLng point,
    required WidgetBuilder builder,
    width,
    height,
    required this.id,
    required this.type,
  }) : super(point: point, builder: builder, width: width, height: height);
}