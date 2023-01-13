class Address {
  final String? houseNumber;
  final String? street;
  final String? postcode;

  const Address({
    this.houseNumber,
    this.street,
    this.postcode,
  });

  @override
  String toString() {
    String address = "";
    if (houseNumber != null) {
      address += "${houseNumber!} ";
    }
    if (street != null) {
      address += "${street!} ";
    }
    if (postcode != null) {
      address += postcode!;
    }

    return address;
  }
}