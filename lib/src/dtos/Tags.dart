class Tags {
  final String? amenity;
  final String? building;
  final String? highway;
  final String? shop;
  final String? publicTransport;
  final String? tourism;
  final String? wheelchair;
  final String? wheelchairDescription;

  const Tags({
    this.amenity,
    this.building,
    this.highway,
    this.shop,
    this.publicTransport,
    this.tourism,
    this.wheelchair,
    this.wheelchairDescription,
  });

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      amenity: json['amenity'],
      building: json['building'],
      highway: json['highway'],
      shop: json['shop'],
      publicTransport: json['public_transport'],
      tourism: json['tourism'],
      wheelchair: json['wheelchair'],
      wheelchairDescription: json['wheelchair:description'],
    );
  }

  @override
  String toString() {
    return "Tags{amenity: $amenity, building: $building, highway: $highway, shop: $shop, publicTransport: $publicTransport, tourism: $tourism, wheelchair: $wheelchair, wheelchairDescription: $wheelchairDescription}";
  }

}