import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wheelgo/src/dtos/NominatimElement.dart';
import 'package:wheelgo/src/widgets/MainMap.dart';
import 'package:geolocator/geolocator.dart';

import '../parameters/DestinationCardParams.dart';
import '../parameters/MarkerInfo.dart';
import 'SearchBar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key,
    required this.panelController,
    required this.onCardSelect,
  });
  final PanelController panelController;
  final Function(LatLng, MarkerInfo) onCardSelect;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<DestinationCardParams> results = [];
  bool searching = false;

  Future<void> findSearchResults(String term) async {
    const Distance distance = Distance();

    setState(() => searching = true);
    List<NominatimElement> elements = await queryService.searchForPlace(term);
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    LatLng currentLocation = LatLng(currentPosition.latitude, currentPosition.longitude);
    List<DestinationCardParams> params = elements.map((e) {
      final double km = distance.as(LengthUnit.Kilometer, currentLocation, e.latlng);

      return DestinationCardParams(
        name: e.basicName,
        address: e.address.toString(), distance: km.toStringAsFixed(1),
        markerInfo: MarkerInfo(id: e.id, type: e.type),
        pos: e.latlng,
      );
    }).toList();

    setState(() {
      results = params;
      searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, top: 4, right: 20, bottom: 8),
          child: SearchBar(
            prompt: "Search here",
            onSubmit: findSearchResults,
            panelController: widget.panelController,
          ),
        ),
        searching ? Container(
          width: 50,
          height: 50,
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: CircularProgressIndicator(),
        ) :
        ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (BuildContext context, int i) {
              return DestinationCard(
                name: results[i].name,
                address: results[i].address,
                distance: results[i].distance,
                pos: results[i].pos,
                markerInfo: results[i].markerInfo,
                onCardSelect: widget.onCardSelect,
              );
            }),
      ],
    );
  }
}

class DestinationCard extends StatelessWidget {
  const DestinationCard({super.key,
    required this.name,
    required this.address,
    required this.distance,
    required this.pos,
    required this.markerInfo,
    required this.onCardSelect,
  });

  final String name;
  final String address;
  final String distance;
  final LatLng pos;
  final MarkerInfo markerInfo;
  final Function(LatLng, MarkerInfo) onCardSelect;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => onCardSelect(pos, markerInfo),
        child: Container(
            padding: const EdgeInsets.only(left: 20, right: 40, top: 8, bottom: 8),
            child: Row(
              children: [
                Expanded(flex: 1, child: Column(
                  children: [
                    Icon(Icons.map),
                    SizedBox(height: 4.0),
                    Text(distance + " km", textAlign: TextAlign.center),
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
            ),
        ),
      ),
    );
  }
}