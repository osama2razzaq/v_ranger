import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/common_widgets/step_Indicator.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/core/values/app_text_style.dart';

class SurveyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Survey",
          style: PromptStyle.appBarTitleStyle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: StepIndicator(
                  number1: 1,
                  number2: 2,
                  number3: 3,
                  isActive1: true,
                  isActive2: false,
                  isActive3: false,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: SizedBox(
                        child: Text('Details',
                            style: TextStyle(
                              fontFamily: AppStrings.fontFamilyPrompt,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            )),
                      ),
                    ),
                    _userInfoForm(context)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _userInfoForm(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailItem('Account ID', '5914141241'),
        _detailItem('Account No', '88866033'),
        _detailItem('Name', 'THINESH'),
        _detailItem('IC Number', '************'),
        _detailItem('Address',
            'B-17-4 Level 17, Tower B (Plaza Pantai Persian Pantai Baru, Off, Jalan Pantai Baharu 59200, Kuala Lumpur'),
        _detailItem('Total Outstanding', 'RM 140.00'),
        _detailItem('Latitude', 'THINESH'),
        _detailItem('Longitude', 'THINESH'),
        _detailItem('Distance', '30.0 KM'),
        _buildMapsButtons(context),
        _buildNextButton(context, buttonName: 'Next')
      ],
    ),
  );
}

Widget _buildMapsButtons(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomButton(
          label: 'View In Maps',
          icon: Icons.map,
          onTap: () {
            Get.to(MapScreen());
          },
          colors: [Colors.white, Colors.white!],
          borderColor: AppColors.primaryColor,
          textColor: Colors.blue[900]!,
        ),
        const SizedBox(width: 10),
        CustomButton(
          label: 'Direction',
          icon: Icons.directions,
          onTap: () {
            print('Direction tapped');
            navigateTo(1.3333, 0.33);
          },
          colors: [
            AppColors.gradientStartColor, // Start color
            AppColors.gradientMiddleColor,
            AppColors.gradientEndColor, // End color
          ],
          borderColor: AppColors.primaryColor,
          textColor: Colors.white,
        ),
      ],
    ),
  );
}

Widget _buildNextButton(BuildContext context, {required String buttonName}) {
  return Center(
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: SingleButton(
        bgColor: AppColors.primaryColor,
        buttonName: buttonName,
        onTap: () => {},
      ),
    ),
  );
}

void navigateTo(double lat, double lng) async {
  var uri = Uri.parse("google.navigation:q=$lat,$lng&mode=d");
  if (await canLaunch(uri.toString())) {
    await launch(uri.toString());
  } else {
    throw 'Could not launch ${uri.toString()}';
  }
}

Widget _detailItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4.0),
        Text(
          label,
          style: PromptStyle.profileSubTitle,
        ),
        Text(
          value,
          style: PromptStyle.profileTitle,
        ),
        const Divider(),
      ],
    ),
  );
}

class CustomButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final List<Color> colors;
  final Color? borderColor;
  final Color textColor;

  CustomButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.colors,
    this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
          ),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  final Location location = Location();

  final LatLng _center =
      const LatLng(3.1390, 101.6869); // Kuala Lumpur coordinates
  final LatLng _start =
      const LatLng(3.2016, 101.6507); // Starting point coordinates
  final LatLng _end =
      const LatLng(3.140853, 101.693207); // Ending point coordinates

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getLocation();
  }

  Future<void> _getLocation() async {
    final LocationData locationResult = await location.getLocation();
    setState(() {
      currentLocation = locationResult;
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: 15,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "MapView",
          style: PromptStyle.appBarTitleStyle,
        ),
      ),
      body: Stack(
        children: <Widget>[
          currentLocation == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 11.0,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId('currentLocation'),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!),
                      infoWindow: InfoWindow(
                        title: 'My Location',
                      ),
                    ),
                    Marker(
                      markerId: const MarkerId('end'),
                      position: _end,
                      infoWindow: const InfoWindow(
                        title: 'Destination',
                      ),
                    ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('route'),
                      points: [_start, _end],
                      color: AppColors.green,
                      width: 5,
                    ),
                  },
                ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: [
                            const Icon(
                              Icons.directions,
                              color: AppColors.primaryColor,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(5, (index) {
                                return Container(
                                  width: 2,
                                  height: 4,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  color: AppColors.primaryColor,
                                );
                              }),
                            ),
                            const Icon(
                              Icons.location_pin,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'My Location',
                                style: PromptStyle.locationAddress,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'B-17-4, Level 17, Tower B (Plaza Pantai\nPersiaran Pantai Baru, Off, Jalan Pantai\nBaharu, 59200 Kuala Lumpur',
                                style: PromptStyle.locationAddress,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'TIME',
                              style: PromptStyle.profileTitle,
                            ),
                            Text(
                              '20 mins',
                              style: PromptStyle.buttonTextColor,
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'DISTANCE',
                              style: PromptStyle.profileTitle,
                            ),
                            Text(
                              '14.1 km',
                              style: PromptStyle.buttonTextColor,
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Icon(
                            Icons.directions,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
