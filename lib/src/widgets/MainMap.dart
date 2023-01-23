import 'dart:math';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:collection/collection.dart';
import 'package:wheelgo/src/enums/AttractionType.dart';
import 'package:wheelgo/src/enums/WheelchairRating.dart';
import 'package:wheelgo/src/exceptions/QueryFailedException.dart';
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
import 'RetryRequestPage.dart';

QueryService queryService = QueryService();
const double markerSize = 30;
const double selectedMarkerSize = markerSize*1.2;
const double queryZoomThreshold = 15;
const int maxClusterRadius = 150;
const double boxBufferScale = 1;
LatLngBounds initBounds = LatLngBounds(
    LatLng(51.493136, -0.127109),
    LatLng(51.50586, -0.117402)
);
const double maxServerZoom = 18.49999999999999; // This is the max zoom for the server


class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final MapController mapController = MapController();
  final PanelController panelController = PanelController();

  Widget currentPage = Container(
    width: 50,
    height: 50,
    margin: EdgeInsets.all(10),
    padding: EdgeInsets.all(10),
    child: CircularProgressIndicator(),
  );
  bool backButtonEnabled = false;
  bool loadingMarkers = false;
  bool isLoadingSlideable = false;
  List<Marker> markers = [];
  Marker? selectedMarker;
  LatLngBounds lastBounds = initBounds;

  final BorderRadiusGeometry radius = const BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  void showRoutingResults() {
    // TODO Send off form info as params
    // TODO Do querying and passing (has example data for now)

    currentPage = RoutingResultsPage(params: exampleRRParams);
    backButtonEnabled = true;
    setState(() {});
  }

  Future<void> showPlaceDetailInfo(int id, AttractionType type) async {
    setState(() {
      isLoadingSlideable = true;
      backButtonEnabled = true;
    });
    try {
      PlaceDetailParams params = await queryService.queryPlace(id, type);

      currentPage = PlaceDetail(params: params);
      isLoadingSlideable = false;
      setState(() {});
    } on QueryFailedException {
      // Show retry menu
      panelController.open();
      currentPage = RetryPlaceRequestPage(
        text: "An error occurred getting the information!",
        onRetry: () => showPlaceDetailInfo(id, type),
      );
      isLoadingSlideable = false;
      setState(() {});
    }
  }

  bool locationsAreEqual(LatLng pos1, LatLng pos2) {
    return (pos1.latitude - pos2.latitude).abs() < 0.0000004
        && (pos1.longitude - pos2.longitude).abs() < 0.0000004;
  }

  Future<void> goToSearchResult(LatLng pos, MarkerInfo markerInfo) async {
    // Offset so the marker is displayed properly on the screen if selected
    mapController.move(LatLng(pos.latitude - 0.0006, pos.longitude), maxServerZoom);
    if (!lastBounds.containsBounds(mapController.bounds!)) {
      await queryNewMarkers();
    }

    Marker? markedLocation = markers.firstWhereOrNull((marker) => locationsAreEqual(marker.point, pos));
    if (markedLocation != null) {
      selectMarker(markedLocation);
    }
  }

  void removeSelectedMarker(MarkerInfo markerInfo) {
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
    panelController.close();
  }

  void showSearchPage() {
    if (selectedMarker != null) {
      MarkerInfo? markerInfo = queryService.markerInfoMap[selectedMarker];
      if (markerInfo != null) {
        markerInfo.selected = false;
        removeSelectedMarker(markerInfo);
      }

      selectedMarker = null;
    }


    currentPage = SearchPage(panelController: panelController, onCardSelect: goToSearchResult);
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
         isLoadingSlideable ? Center(
             child: Container(
               width: 50,
               height: 50,
               margin: EdgeInsets.all(10),
               padding: EdgeInsets.all(10),
               child: CircularProgressIndicator(),
             )
         ) : currentPage,
      ],
    );
  }

  void removeMarker() {
    setState(() {
      markers.removeLast();
      markers = markers.toList();
    });
  }

  void selectMarker(Marker marker) {
    MarkerInfo? markerInfo = queryService.markerInfoMap[marker];
    if (markerInfo != null)  {
      if (selectedMarker == null) {
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
      } else {
        removeSelectedMarker(markerInfo);

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
    }
  }

  void resetBounds() {
    setState(() {
      double heightLat = mapController.bounds!.north - mapController.bounds!.south;
      double widthLon = mapController.bounds!.east - mapController.bounds!.west;

      lastBounds = LatLngBounds(
          LatLng(
            mapController.bounds!.southWest!.latitude - boxBufferScale * heightLat,
            mapController.bounds!.southWest!.longitude - boxBufferScale * widthLon,
          ),
          LatLng(
            mapController.bounds!.northEast!.latitude + boxBufferScale * heightLat,
            mapController.bounds!.northEast!.longitude + boxBufferScale * widthLon,
          )
      );
    });
  }


  Future<bool> _onWillPop() {
    if (currentPage is! SearchPage) {
      showSearchPage();
      return Future.value(false);
    }

    return Future.value(true);
  }

  Future<void> queryNewMarkers() async {
    try {
      setState(() => loadingMarkers = true);
      debugPrint("Setting loading to $loadingMarkers");
      resetBounds();
      await setMarkers(lastBounds.southWest!, lastBounds.northEast!);
    } on QueryFailedException {
      // Show retry menu
      panelController.open();
      setState(() => loadingMarkers = false);
      currentPage = RetryPlaceRequestPage(
        text: "An error occurred getting markers!",
        onRetry: () {
          queryNewMarkers();
          showSearchPage();
        },
      );
    }
  }

  Future<void> setMarkers(LatLng sw, LatLng ne) async {
    markers = await queryService.queryMarkers(sw, ne);
    setState(() {
      markers = markers.toList();
      loadingMarkers = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentPage = SearchPage(panelController: panelController, onCardSelect: goToSearchResult);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("Initial querying...");
      queryNewMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onWillPop,
      child: BackdropScaffold(
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
          controller: panelController,
          panelBuilder: (ScrollController sc) => _panel(sc),
          borderRadius: radius,
          collapsed: null,
          maxHeight: MediaQuery.of(context).size.height * 0.52,
          body: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              bounds: initBounds,
              maxZoom: maxServerZoom,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              onMapEvent: (event) {
                if (mapController.zoom > queryZoomThreshold &&
                    !lastBounds.containsBounds(mapController.bounds!) &&
                    (event is MapEventMoveEnd || event is MapEventFlingAnimationEnd || event is MapEventScrollWheelZoom)) {
                  queryNewMarkers();
                }
              },
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
                  maxClusterRadius: maxClusterRadius,
                  disableClusteringAtZoom: 17,
                  size: const Size(40, 40),
                  fitBoundsOptions: const FitBoundsOptions(
                    padding: EdgeInsets.all(50),
                  ),
                  markers: markers,
                  onMarkerTap: (marker) => selectMarker(marker),
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
              loadingMarkers ? Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                  ),
                  child: CircularProgressIndicator(),
                ),
              ) : Container(),
              // Align(
              //   alignment: Alignment.topRight,
              //   child: ElevatedButton(onPressed: showRoutingResults,
              //       child: Icon(Icons.arrow_circle_right)),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

