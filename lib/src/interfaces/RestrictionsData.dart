class RestrictionsData {
  RestrictionsData({
    this.inclination = 6,
    this.maxKerbHeight = 0.06,
    this.routeSmoothness = "good",
    this.avoidSteps = true,
    this.usePublicTransport = true,
  });

  int inclination;
  double maxKerbHeight;
  String routeSmoothness;
  bool avoidSteps;
  bool usePublicTransport;

  @override
  String toString() {
    return "RestrictionsData{inclination: $inclination, maxKerbHeight: $maxKerbHeight, routeSmoothness: $routeSmoothness, avoidSteps: $avoidSteps, usePublicTransport: $usePublicTransport}";
  }
}