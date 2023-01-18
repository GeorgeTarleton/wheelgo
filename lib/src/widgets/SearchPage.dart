import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:wheelgo/src/dtos/NominatimElement.dart';
import 'package:wheelgo/src/widgets/MainMap.dart';
import 'package:geolocator/geolocator.dart';

import '../parameters/DestinationCardParams.dart';
import 'SearchBar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // TODO Change this to be generated from the queries, rather than static
  List<DestinationCardParams> results = [
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
    const DestinationCardParams(name: "Name 1", address: "Address 1", distance: "10"),
    const DestinationCardParams(name: "Name 2", address: "Address 2", distance: "20"),
  ];

  Future<void> findSearchResults(String term) async {
    final Distance distance = Distance();

    List<NominatimElement> elements = await queryService.searchForPlace(term);
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    LatLng currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
    List<DestinationCardParams> params = elements.map((e) {
      final double km = distance.as(LengthUnit.Kilometer, currentLocation, e.latlng);

      return DestinationCardParams(name: e.basicName, address: e.address.toString(), distance: km.toStringAsFixed(1));
    }).toList();

    setState(() {
      results = params;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 8),
          child: SearchBar(prompt: "Search here", onSubmit: findSearchResults),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (BuildContext context, int i) {
              return DestinationCard(
                name: results[i].name,
                address: results[i].address,
                distance: results[i].distance,
              );
            }),
      ],
    );
  }
}

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key, required this.name, required this.address, required this.distance});

  final String name;
  final String address;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, right: 40, top: 8, bottom: 8),
        child:
        Row(
          children: [
            Expanded(flex: 1, child: Column(
              children: [
                Icon(Icons.map),
                SizedBox(
                  height: 4.0,
                ),
                Text(distance + " km")
              ],
            )),
            SizedBox(width: 15),
            Expanded(flex: 4, child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 20)),
                SizedBox(
                  height: 4.0,
                ),
                Text(address),
                Divider(color: Colors.black)
              ],
            )),
          ],
        )
    );
  }
}