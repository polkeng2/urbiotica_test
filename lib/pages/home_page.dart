import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:urbiotica_project/classes/marker.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late Future<List<ApiMarker>> futureApiMarkers = ApiMarker.getMarkers();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (FutureBuilder<List<ApiMarker>>(
      future: futureApiMarkers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.385846, 2.138175),
              zoom: 15.0,
            ),
            markers: snapshot.data!
                .map(
                  (marker) => Marker(
                    infoWindow: InfoWindow(title: marker.name),
                    markerId: MarkerId(marker.name),
                    position: LatLng(double.parse(marker.latitude),
                        double.parse(marker.longitude)),
                  ),
                )
                .toSet(),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'On son els meus dispositius?',
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: const Map());
  }
}
