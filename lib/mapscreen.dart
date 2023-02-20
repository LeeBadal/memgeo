import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:memgeo/location.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:memgeo/db/db.dart';
import 'package:memgeo/memgeoTheme.dart';
import 'package:memgeo/models/post.dart';
import 'package:memgeo/randomHelpers.dart';
import 'package:memgeo/viewPostPage.dart';

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
    _populateMarkers();
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
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: '© OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),
              ],
              mapController: mapController,
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
                                color: mgSwatch2),
                            child: Center(
                              child: Text(
                                markers.length.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }))
              ],
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

  //populate the map with markers with the locations of the feed objects
  void _populateMarkers() async {
    final db = Db();
    List<PostObject> data = await db.retrievePosts();
    _markers = data
        .map((value) => Marker(
              point: string2latlng(value.coordinates),
              builder: (context) => IconButton(
                icon: Icon(Icons.whatshot_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewPostPage(post: value)),
                  );
                },
              ),
            ))
        .toList();
    setState(() => _markers);
  }
}
