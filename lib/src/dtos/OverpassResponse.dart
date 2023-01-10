import 'OSMNode.dart';

class OverpassResponse {
  final List<OSMNode> elements;

  const OverpassResponse({
    required this.elements,
  });

  factory OverpassResponse.fromJson(Map<String, dynamic> json) {
    List<OSMNode> nodes = [];
    for (dynamic element in json['elements']) {
      nodes.add(OSMNode.fromJson(element));
    }

    return OverpassResponse(elements: nodes);
  }
}