import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainMap()
    );
  }
}

class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(51.509364, -0.128928),
          zoom: 9.2,
        ),
        nonRotatedChildren: [
          AttributionWidget.defaultWidget(
            source: 'OpenStreetMap contributors',
            onSourceTapped: null,
          ),
        ],
        children: <Widget>[
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerClusterLayerWidget(
            options: MarkerClusterLayerOptions(
              maxClusterRadius: 120,
              size: const Size(40, 40),
              fitBoundsOptions: const FitBoundsOptions(
                padding: EdgeInsets.all(50),
              ),
              markers: [
                Marker(
                  point: LatLng(51.5013562, -0.1249302),
                  width: 50,
                  height: 50,
                  builder: (context) => const Icon(
                    Icons.pin_drop,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                Marker(
                  point: LatLng(51.5032704, -0.1196257),
                  width: 50,
                  height: 50,
                  builder: (context) => const Icon(
                    Icons.pin_drop,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
              polygonOptions: const PolygonOptions(
                  borderColor: Colors.blueAccent,
                  color: Colors.black12,
                  borderStrokeWidth: 3),
              popupOptions: PopupOptions(
                  popupState: PopupState(),
                  popupSnap: PopupSnap.markerTop,
                  popupController: PopupController(),
                  popupBuilder: (_, marker) => Container(
                    width: 200,
                    height: 100,
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () => debugPrint('Popup tap!'),
                      child: Text(
                        'Container popup for marker at ${marker.point}',
                      ),
                    ),
                  )),
              builder: (context, markers) {
                return FloatingActionButton(
                  onPressed: null,
                  child: Text(markers.length.toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
