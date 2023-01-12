import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wheelgo/src/enums/WheelchairRating.dart';
import 'package:wheelgo/src/parameters/PlaceDetailParams.dart';

class PlaceDetail extends StatelessWidget {
  const PlaceDetail({super.key, required this.params});

  final PlaceDetailParams params;

  final String accessibleDescriptionFull = "Wheelchairs have full, unrestricted access.\nEntrance and rooms are accessible without steps.";
  final String accessibleDescriptionLimited = "Wheelchairs have partial access.\nThe entrance has a step no higher than 7cm.\nThe most important rooms are stepless.";
  final String accessibleDescriptionNone = "Wheelchairs have no unrestricted access.\nThe entrance has a high or step, or several steps.\nThe most important rooms are not accessible.";
  final String accessibleDescriptionUnknown = "Unknown wheelchair accessibility information.";

  Color determineRatingColour() {
    switch (params.wheelchairRating) {
      case WheelchairRating.yes:
        return Colors.green;
      case WheelchairRating.limited:
        return Colors.orange;
      case WheelchairRating.no:
        return Colors.red;
      case WheelchairRating.unknown:
        return Colors.grey;
    }
  }

  String? determineAccessibleDescription() {
    if (params.wheelchairDescription != null) {
      return params.wheelchairDescription;
    }

    switch (params.wheelchairRating) {
      case WheelchairRating.yes:
        return accessibleDescriptionFull;
      case WheelchairRating.limited:
        return accessibleDescriptionLimited;
      case WheelchairRating.no:
        return accessibleDescriptionNone;
      case WheelchairRating.unknown:
        return accessibleDescriptionUnknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color ratingColor = determineRatingColour();
    String? accessibleDescription = determineAccessibleDescription();

    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
                params.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)
            ),
          ),
          SizedBox(height: 4.0),
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(params.category, style: TextStyle(fontSize: 20)),
          ),
          SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(child: Card(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            child: Text(
                                params.wheelchairRating.displayTitle,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24, color: ratingColor,
                                )
                            )
                        ),
                        SizedBox(height: 6.0),
                        Container(
                          child: Text(accessibleDescription!, style: TextStyle(fontSize: 18)),
                        ),
                      ]
                  ),
                )
              ))
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.only(left: 4),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  textStyle: const TextStyle(fontSize: 20)
              ),
              child: const Text("Directions"),
            ),
          ),
          SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              children: [
                Text(params.address, style: TextStyle(fontSize: 20)),
                Text(params.website ?? "", style: TextStyle(fontSize: 20))
              ],
            ),
          )
        ],
      ),
    );
  }
}