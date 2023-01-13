import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:wheelgo/src/enums/WheelchairRating.dart';
import 'package:recase/recase.dart';

import '../interfaces/Address.dart';

class PlaceDetailParams {
  const PlaceDetailParams({
    required this.name,
    required this.category,
    required this.wheelchairRating,
    this.wheelchairDescription,
    required this.address,
    this.website,
  });

  final String name;
  final String category;
  final WheelchairRating wheelchairRating;
  final String? wheelchairDescription;
  final Address address;
  final String? website;

  factory PlaceDetailParams.fromJson(Map<String, dynamic> json) {
    String category = "";
    if (json['shop'] != null) {
      category = "Shop";
    } else if (json['amenity'] != null) {
      category = new ReCase(json['amenity']).titleCase;
    } else if (json['public_transport'] != null) {
      category = new ReCase(json['public_transport']).titleCase;
    } else if (json['tourism'] != null) {
      category = new ReCase(json['tourism']).titleCase;
    } else if (json['leisure'] != null) {
      category = new ReCase(json['leisure']).titleCase;
    } else if (json['sport'] != null) {
      category = new ReCase(json['sport']).titleCase;
    }

    return PlaceDetailParams(
      name: json['name'],
      category: category,
      wheelchairRating: json['wheelchair'] != null ? PlaceDetailParams.getWheelchairRating(json['wheelchair']) : WheelchairRating.unknown,
      wheelchairDescription: json['wheelchair:description'],
      address: Address(houseNumber: json['addr:housenumber'], street: json['addr:street'], postcode: json['addr:postcode']),
      website: json['website'],
    );
  }

  static WheelchairRating getWheelchairRating(String value) {
    return WheelchairRating.values.firstWhere((e) => e.toString() == "WheelchairRating.$value");
  }

  @override
  String toString() {
    return "PlaceDetailParams{name: $name, category: $category, wheelchairRating: ${describeEnum(wheelchairRating)}, wheelchairDescription: $wheelchairDescription, address: ${address.toString()}, website: $website}";
  }
}