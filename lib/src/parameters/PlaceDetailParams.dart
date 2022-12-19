import 'package:wheelgo/src/enums/WheelchairRating.dart';

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
  final String address;
  final String? website;
}