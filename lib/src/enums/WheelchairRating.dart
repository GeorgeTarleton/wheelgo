enum WheelchairRating {
  yes,
  limited,
  no,
  unknown,
}

extension WheelchairRatingExtension on WheelchairRating {
  String get displayTitle {
    switch (this) {
      case WheelchairRating.yes:
        return "Fully Wheelchair Accessible";
      case WheelchairRating.limited:
        return "Partially Wheelchair Accessible";
      case WheelchairRating.no:
        return "Not Wheelchair Accessible";
      default:
        return "Unknown Wheelchair Accessibility Status";
    }
  }
}