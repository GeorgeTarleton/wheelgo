import 'dart:math';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:wheelgo/src/enums/AttractionType.dart';
import 'package:wheelgo/src/enums/WheelchairRating.dart';
import 'package:wheelgo/src/parameters/Elevation.dart';
import 'package:wheelgo/src/parameters/PlaceDetailParams.dart';
import 'package:wheelgo/src/parameters/PublicTransportLeg.dart';
import 'package:wheelgo/src/parameters/PublicTransportRide.dart';
import 'package:wheelgo/src/parameters/RoutingResultsPageParams.dart';
import 'package:wheelgo/src/parameters/WheelingDirection.dart';
import 'package:wheelgo/src/parameters/WheelingLeg.dart';
import 'package:wheelgo/src/services/QueryService.dart';
import 'package:wheelgo/src/widgets/AttractionMarker.dart';
import 'package:wheelgo/src/widgets/PlaceDetail.dart';
import 'package:wheelgo/src/widgets/RoutingPage.dart';
import 'package:wheelgo/src/widgets/RoutingResultsPage.dart';
import 'package:wheelgo/src/widgets/SearchPage.dart';

import '../parameters/MarkerInfo.dart';

QueryService queryService = QueryService();
const double markerSize = 50;
const double selectedMarkerSize = markerSize*1.2;


class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  Widget currentPage = SearchPage();
  bool backButtonEnabled = false;
  List<Marker> markers = queryService.getMarkers();
  Marker? selectedMarker;


  void showRoutingResults() {
    // TODO Send off form info as params
    // TODO Do querying and passing (has example data for now)

    currentPage = RoutingResultsPage(params: exampleRRParams);
    backButtonEnabled = true;
    setState(() {});
  }

  void showPlaceDetailInfo(int id, AttractionType type) {
    // TODO Add identifying info as params
    // TODO Do the querying/passing etc. (has example data for now)
    PlaceDetailParams params = queryService.getPlaceDetail(id, type);

    currentPage = PlaceDetail(params: params);
    backButtonEnabled = true;
    setState(() {});
  }

  void showSearchPage() {
    if (selectedMarker != null) {
      MarkerInfo? markerInfo = queryService.markerInfoMap[selectedMarker];
      if (markerInfo != null) {
        markerInfo.selected = false;

        Marker newMarker = Marker(
          point: selectedMarker!.point,
          height: markerSize,
          width: markerSize,
          builder: (ctx) => const Icon(
            Icons.location_pin,
            size: markerSize,
            color: Colors.blue,
          ),
        );
        queryService.markerInfoMap[newMarker] = markerInfo;
        queryService.markerInfoMap.remove(selectedMarker);

        setState(() {
          markers.remove(selectedMarker);
          markers.add(newMarker);
          markers = markers.toList();
        });
      }

      selectedMarker = null;
    }

    currentPage = SearchPage();
    backButtonEnabled = false;
    setState(() {});
  }


  Widget _panel(ScrollController sc) {
    return ListView(
      controller: sc,
      shrinkWrap: true,
      children: [
        const SizedBox(
          height: 12.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 30,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ],
        ),
        const SizedBox(
          height: 6.0,
        ),
        currentPage,
      ],
    );
  }

  void removeMarker() {
    setState(() {
      markers.removeLast();
      markers = markers.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return BackdropScaffold(
      appBar: BackdropAppBar(
        title: const Text("Wheelgo", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: const <Widget>[
          BackdropToggleButton(
            icon: AnimatedIcons.list_view,
          )
        ],
      ),
      backLayer: RoutingPage(),
      frontLayer: SlidingUpPanel(
        panelBuilder: (ScrollController sc) => _panel(sc),
        borderRadius: radius,
        collapsed: null,

        body: FlutterMap(
          options: MapOptions(
            center: LatLng(51.509364, -0.128928),
            zoom: 12,
            maxZoom: 18.0,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            CurrentLocationLayer(),
            MarkerClusterLayerWidget(
              options: MarkerClusterLayerOptions(
                maxClusterRadius: 120,
                size: const Size(40, 40),
                fitBoundsOptions: const FitBoundsOptions(
                  padding: EdgeInsets.all(50),
                ),
                markers: markers,
                onMarkerTap: (marker) {
                  MarkerInfo? markerInfo = queryService.markerInfoMap[marker];
                  if (markerInfo != null && selectedMarker == null) {
                    markerInfo.selected = true;

                    Marker newMarker = Marker(
                      point: marker.point,
                      height: selectedMarkerSize,
                      width: selectedMarkerSize,
                      builder: (ctx) => const Icon(
                        Icons.location_pin,
                        size: selectedMarkerSize,
                        color: Colors.red,
                      ),
                    );
                    selectedMarker = newMarker;

                    queryService.markerInfoMap[newMarker] = markerInfo;
                    queryService.markerInfoMap.remove(marker);

                    setState(() {
                      markers.remove(marker);
                      markers.add(newMarker);
                      markers = markers.toList();
                    });

                    showPlaceDetailInfo(markerInfo.id, markerInfo.type);
                  }
                },
                polygonOptions: const PolygonOptions(
                    borderColor: Colors.blueAccent,
                    color: Colors.black12,
                    borderStrokeWidth: 3),
                builder: (context, markers) {
                  return FloatingActionButton(
                    onPressed: null,
                    child: Text(markers.length.toString()),
                  );
                },
              ),
            ),
            backButtonEnabled ? Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => showSearchPage(),
                child: Icon(Icons.arrow_back_outlined, size: 40),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                ),
              ),
            ) : Container(),
            // ElevatedButton(onPressed: showRoutingResults,
            //   child: Icon(Icons.arrow_circle_right))
          ],
        ),
      ),
    );
  }
}