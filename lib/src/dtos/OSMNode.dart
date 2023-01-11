import 'package:wheelgo/src/enums/AttractionType.dart';

import 'Tags.dart';

class OSMElement {
  final int id;
  final AttractionType type;
  final double lat;
  final double lon;
  final Tags? tags;

  const OSMElement({
    required this.id,
    required this.type,
    required this.lat,
    required this.lon,
    required this.tags,
  });

  factory OSMElement.fromJson(Map<String, dynamic> json) {
    AttractionType type = OSMElement.getAttractionType(json['type']);

    return OSMElement(
      id: json['id'],
      type: type,
      lat: type == AttractionType.node ? json['lat'] : json['center']['lat'],
      lon: type == AttractionType.node ? json['lon'] : json['center']['lon'],
      tags: json['tags'] != null ? Tags.fromJson(json['tags']) : null,
    );
  }

  static AttractionType getAttractionType(String value) {
    return AttractionType.values.firstWhere((e) => e.toString() == "AttractionType.$value");
  }

  @override
  String toString() {
    return "OSMElement{id: $id, type: $type, lat: $lat, long: $lon, tags: $tags}";
  }
}