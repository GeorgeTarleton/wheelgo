class WheelingDirection {
  const WheelingDirection({
    required this.description,
    required this.distance,
    required this.duration,
  });

  final String description;
  final double distance;
  final Duration duration;

  @override
  String toString() {
    return "WheelingDirection{decription: $description, distance: $distance, duration: ${duration.inSeconds}}";
  }
}