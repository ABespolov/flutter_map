import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import '../pages/zoombuttons_plugin_option.dart';
import '../widgets/drawer.dart';

class WidgetsPage extends StatelessWidget {
  static const String route = 'widgets';

  const WidgetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widgets')),
      drawer: buildDrawer(context, WidgetsPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                  plugins: [
                    ZoomButtonsPlugin(),
                  ],
                ),
                nonRotatedLayers: [
                  ZoomButtonsPluginOption(
                    minZoom: 4,
                    maxZoom: 19,
                    mini: true,
                    padding: 10,
                    alignment: Alignment.bottomLeft,
                  )
                ],
                nonRotatedChildren: const <Widget>[
                  Text(
                    'Plugin is just Text widget',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.yellow),
                  )
                ],
                children: <Widget>[
                  TileLayerWidget(
                    options: TileLayerOptions(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                  ),
                  const MovingWithoutRefreshAllMapMarkers(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovingWithoutRefreshAllMapMarkers extends StatefulWidget {
  const MovingWithoutRefreshAllMapMarkers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _MovingWithoutRefreshAllMapMarkersState();
}

class _MovingWithoutRefreshAllMapMarkersState
    extends State<MovingWithoutRefreshAllMapMarkers> {
  Marker? _marker;
  Timer? _timer;
  int _markerIndex = 0;

  @override
  void initState() {
    super.initState();
    _marker = _markers[_markerIndex];
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _marker = _markers[_markerIndex];
        _markerIndex = (_markerIndex + 1) % _markers.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayerWidget(
      options: MarkerLayerOptions(markers: [_marker!]),
    );
  }
}

List<Marker> _markers = [
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(51.5, -0.09),
    builder: (ctx) => const FlutterLogo(),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(53.3498, -6.2603),
    builder: (ctx) => const FlutterLogo(),
  ),
  Marker(
    width: 80.0,
    height: 80.0,
    point: LatLng(48.8566, 2.3522),
    builder: (ctx) => const FlutterLogo(),
  ),
];
