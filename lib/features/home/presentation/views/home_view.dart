import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v_ranger/core/values/values.dart';
import 'package:v_ranger/features/batches/presentation/views/batchesView_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LatLng _center = const LatLng(3.0951582, 101.5920018);

  List<Marker> markers = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(3.1390, 101.6869), // Kuala Lumpur city center
        infoWindow: InfoWindow(
          title: 'KL City Center',
          snippet: 'Location 1',
        )),
    const Marker(
        markerId: MarkerId('2'),
        position: LatLng(3.1654, 101.6786), // Near Batu Caves
        infoWindow: InfoWindow(
          title: 'Near Batu Caves',
          snippet: 'Location 2',
        )),
    const Marker(
        markerId: MarkerId('3'),
        position: LatLng(3.1579, 101.7005), // Near Gombak
        infoWindow: InfoWindow(
          title: 'Near Gombak',
          snippet: 'Location 3',
        )),
    const Marker(
        markerId: MarkerId('4'),
        position: LatLng(3.1168, 101.7290), // Near Ampang
        infoWindow: InfoWindow(
          title: 'Near Ampang',
          snippet: 'Location 4',
        )),
    const Marker(
        markerId: MarkerId('5'),
        position: LatLng(3.1126, 101.6384), // Near Petaling Jaya
        infoWindow: InfoWindow(
          title: 'Near Petaling Jaya',
          snippet: 'Location 5',
        )),
    const Marker(
        markerId: MarkerId('6'),
        position: LatLng(3.2101, 101.7182), // Near Kepong
        infoWindow: InfoWindow(
          title: 'Near Kepong',
          snippet: 'Location 6',
        )),
    const Marker(
        markerId: MarkerId('7'),
        position: LatLng(3.1442, 101.6890), // Bangsar
        infoWindow: InfoWindow(
          title: 'Bangsar',
          snippet: 'Location 7',
        )),
    const Marker(
        markerId: MarkerId('8'),
        position: LatLng(3.1458, 101.6639), // Near Setapak
        infoWindow: InfoWindow(
          title: 'Near Setapak',
          snippet: 'Location 8',
        )),
    const Marker(
        markerId: MarkerId('9'),
        position: LatLng(3.1105, 101.6654), // Near Cheras
        infoWindow: InfoWindow(
          title: 'Near Cheras',
          snippet: 'Location 9',
        )),
    const Marker(
        markerId: MarkerId('10'),
        position: LatLng(3.1141, 101.6750), // Near Pudu
        infoWindow: InfoWindow(
          title: 'Near Pudu',
          snippet: 'Location 10',
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          title: Center(
            child: Text(
              "V-RANGER",
              style: PromptStyle.appBarLogoStyle,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [_buildGoogleMap(), _buildBottomContainer()],
          ),
        ));
  }

  Widget _buildGoogleMap() {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
        child: GoogleMap(
            scrollGesturesEnabled: true,
            //    zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {},
            initialCameraPosition: const CameraPosition(
              target: LatLng(
                  3.1458, 101.6639), // Set the initial position of the camera
              zoom: 12, // Set the initial zoom level
            ),
            markers: markers.toSet(),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            }
            // Pass the markers to the map
            ),
      ),
    );
  }

  Widget _buildBottomContainer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCard('Batch', '02', Icons.layers, AppColors.batchBlue),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCard(
                'Total Files', '09', Icons.folder, AppColors.fileRed),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCard(
                'Completed', '07', Icons.check_circle, AppColors.fileYellow),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, String count, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        print(":");
        Get.to(const BatchesView());
      },
      child: Container(
        //width: 100,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: PromptStyle.cardTitle,
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: PromptStyle.cardSubTitle,
            ),
            const SizedBox(height: 10),
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
