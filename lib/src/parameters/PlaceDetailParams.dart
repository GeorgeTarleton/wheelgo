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
    WheelchairRating rating = json['wheelchair'] != null ? PlaceDetailParams.getWheelchairRating(json['wheelchair']) : WheelchairRating.unknown;

    String category = "";
    if (json['shop'] != null) {
      category = "Shop";
    } else if (json['amenity'] != null) {
      category = new ReCase(json['amenity']).titleCase;
    } else if (json['public_transport'] != null) {
      if (json['highway'] != null && json['highway'] == "bus_stop") {
        category = "Bus Stop";
        rating = WheelchairRating.yes;
      } else {
        category = new ReCase(json['public_transport']).titleCase;
      }
    } else if (json['tourism'] != null) {
      if (json['tourism'] == "yes") {
        category = "Attraction";
      } else {
        category = new ReCase(json['tourism']).titleCase;
      }
    } else if (json['leisure'] != null) {
      category = new ReCase(json['leisure']).titleCase;
    } else if (json['sport'] != null) {
      category = new ReCase(json['sport']).titleCase;
    }

    String name = "";
    if (json['name'] != null) {
      name = json['name'];
    } else if (json['amenity'] == "toilets") {
      name = "Public Toilets";
    }

    return PlaceDetailParams(
      name: name,
      category: category,
      wheelchairRating: rating,
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