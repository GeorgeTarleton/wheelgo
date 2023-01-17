import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/enums/AttractionType.dart';

import '../interfaces/Address.dart';
import 'OSMElement.dart';

class NominatimElement {
  final int id;
  final AttractionType type;
  final LatLng latlng;
  final String fullName;
  final String basicName;
  final Address address;
  
  const NominatimElement({
    required this.id,
    required this.type,
    required this.latlng,
    required this.fullName,
    required this.basicName,
    required this.address,
  });
  
  factory NominatimElement.fromJson(Map<String, dynamic> json) {
    AttractionType type = OSMElement.getAttractionType(json['osm_type']);

    return NominatimElement(
        id: json['osm_id'],
        type: type,
        latlng: LatLng(double.parse(json['lat']), double.parse(json['lon'])),
        fullName: json['display_name'],
        basicName: json['namedetails']['name'],
        address: Address(
          houseNumber: json['address']['house_number'],
          street: json['address']['road'],
          postcode: json['address']['postcode'],
        ),
    );
  }

  @override
  String toString() {
    return "NominatimElement{id: $id, type: $type, latlng: $latlng, fullName: $fullName, basicName: $basicName, address: ${address.toString()}";
  }
}