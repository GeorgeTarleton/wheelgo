import 'package:wheelgo/src/enums/AttractionType.dart';

import 'Tags.dart';

class OSMElement {
  final int id;
  final AttractionType type;
  final double? lat;
  final double? lon;
  final Tags? tags;
  final List<int>? nodeChildren;

  const OSMElement({
    required this.id,
    required this.type,
    this.lat,
    this.lon,
    required this.tags,
    this.nodeChildren,
  });

  factory OSMElement.fromJson(Map<String, dynamic> json) {
    return OSMElement(
      id: json['id'],
      type: AttractionType.values.firstWhere((e) => e.toString() == "AttractionType.${json['type']}"),
      lat: json['lat'],
      lon: json['lon'],
      tags: json['tags'] != null ? Tags.fromJson(json['tags']) : null,
      nodeChildren: json['nodes'] != null ? List<int>.from(json['nodes']) : null,
    );
  }

  @override
  String toString() {
    return "OSMElement{id: $id, type: $type, lat: $lat, long: $lon, tags: $tags, nodeChildren: $nodeChildren}";
  }
}