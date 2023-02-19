import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:memgeo/location.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController mapController = MapController();
  LatLng _initialPosition = LatLng(0, 0); // set initial position to (0, 0)
  List<Marker> _markers = [];
  bool _locationLoaded = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    print(_initialPosition);
  }

  void _getUserLocation() async {
    final position = await determinePosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _addMarker(_initialPosition);
      _locationLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: _locationLoaded
          ? FlutterMap(
              options: MapOptions(
                center: _initialPosition,
                zoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                        maxClusterRadius: 45,
                        size: const Size(40, 40),
                        anchor: AnchorPos.align(AnchorAlign.center),
                        fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                          maxZoom: 15,
                        ),
                        markers: _markers,
                        builder: (context, markers) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue),
                            child: Center(
                              child: Text(
                                markers.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }))
              ],
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: '© OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),
              ],
              mapController: mapController,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  void _addMarker(LatLng latLng) {
    final marker = Marker(
      point: latLng,
      builder: (context) => IconButton(
        icon: Icon(Icons.location_on),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Scaffold()),
          );
        },
      ),
    );
    setState(() => _markers.add(marker));
  }
}
