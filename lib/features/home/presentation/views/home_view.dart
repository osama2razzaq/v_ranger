import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v_ranger/core/values/values.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Marker> markers = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(3.0951582, 101.5920018),
        infoWindow: InfoWindow(
          title: 'Marker 1',
          snippet: 'Location 1',
        )),
    const Marker(
        markerId: MarkerId('2'),
        position: LatLng(3.0991582, 101.60),
        infoWindow: InfoWindow(
          title: 'Marker 2',
          snippet: 'Location 2',
        ))
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
              target: LatLng(3.0951582,
                  101.5920018), // Set the initial position of the camera
              zoom: 14, // Set the initial zoom level
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
    return Container(
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
    );
  }
}
