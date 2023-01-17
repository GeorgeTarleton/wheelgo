import 'OSMElement.dart';

class OverpassResponse {
  final List<OSMElement> elements;

  const OverpassResponse({
    required this.elements,
  });

  factory OverpassResponse.fromJson(Map<String, dynamic> json) {
    List<OSMElement> nodes = [];
    for (dynamic element in json['elements']) {
      nodes.add(OSMElement.fromJson(element));
    }

    return OverpassResponse(elements: nodes);
  }
}