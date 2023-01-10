import 'Tags.dart';

class OSMNode {
  final int id;
  final String type;
  final double lat;
  final double lon;
  final Tags tags;

  const OSMNode({
    required this.id,
    required this.type,
    required this.lat,
    required this.lon,
    required this.tags,
  });

  factory OSMNode.fromJson(Map<String, dynamic> json) {
    return OSMNode(
      id: json['id'],
      type: json['type'],
      lat: json['lat'],
      lon: json['lon'],
      tags: Tags.fromJson(json['tags']),
    );
  }

  @override
  String toString() {
    return "OSMNode{id: $id, type: $type, lat: $lat, long: $lon, tags: $tags}";
  }
}