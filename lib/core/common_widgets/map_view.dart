import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:v_ranger/core/common_widgets/form_loader.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/Survey/presentation/views/survey_details_view.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart';
import 'package:http/http.dart' as http; // For HTTP requests
import 'package:geocoding/geocoding.dart'; // Import the geocoding package

class MapScreen extends StatefulWidget {
  final double lat;
  final double long;
  MapScreen({super.key, required this.lat, required this.long});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LocationController locationController = Get.put(LocationController());

  List<LatLng> polylinePoints = [];
  String myAddress = '';
  String destinationAddress = '';

  @override
  void initState() {
    super.initState();
    _getAddress(widget.lat, widget.long, true);
    _getAddress(locationController.currentLocation.value!.latitude!,
        locationController.currentLocation.value!.longitude!, false);
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getPolyline();
  }

  double distance = 0.0;
  double duration = 0.0;
  _getPolyline() async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${locationController.currentLocation.value!.latitude},${locationController.currentLocation.value!.longitude}&destination=${widget.lat},${widget.long}&mode=driving&key=AIzaSyBfk2lf9GDygZA8S95qs4Q94pRYrEjls8M";
    Uri uri = Uri.parse(url);

    http.Response response = await http.get(uri);
    Map<String, dynamic> values = jsonDecode(response.body);

    List routes = values["routes"];
    if (routes.isNotEmpty) {
      Map<String, dynamic> route = routes[0];
      Map<String, dynamic> leg = route["legs"][0];

      double distance =
          leg["distance"]["value"] / 1000; // distance in kilometers
      double duration = leg["duration"]["value"] / 60; // duration in minutes

      List steps = leg["steps"];
      List<LatLng> polylinePoints = [];
      for (int k = 0; k < steps.length; k++) {
        String polyline = steps[k]["polyline"]["points"];
        List points = _convertToLatLng(_decodePoly(polyline));
        polylinePoints.addAll(points as Iterable<LatLng>);
      }

      setState(() {
        this.polylinePoints = polylinePoints;
        this.distance = distance;
        this.duration = duration;
      });
    }
  }

  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = [];
    int index = 0;
    int len = poly.length;
    int c = 0;
    do {
      var shift = 0;
      int result = 0;
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      if (result & 1 == 1) result = ~result;
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    return lList;
  }

  List<LatLng> _convertToLatLng(List points) {
    List<LatLng> result = <LatLng>[];
    for (int i = 0; i < points.length; i++) {
      if (i % 2 != 0) {
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> _getAddress(double lat, double lon, bool isDestination) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String address =
            '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
        setState(() {
          if (isDestination) {
            destinationAddress = address;
          } else {
            myAddress = address;
          }
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
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
      body: Obx(
        () => Stack(
          children: <Widget>[
            locationController.currentLocation.value == null
                ? const Center(child: FormLoader())
                : GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          locationController.currentLocation.value!.latitude!,
                          locationController.currentLocation.value!.longitude!),
                      zoom: 11.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentLocation'),
                        position: LatLng(
                            locationController.currentLocation.value!.latitude!,
                            locationController
                                .currentLocation.value!.longitude!),
                        infoWindow: InfoWindow(
                          title: 'My Location',
                          snippet: myAddress,
                        ),
                      ),
                      Marker(
                        markerId: const MarkerId('end'),
                        position: LatLng(widget.lat, widget.long),
                        infoWindow: InfoWindow(
                          title: 'Destination',
                          snippet: destinationAddress,
                        ),
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: polylinePoints,
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  myAddress,
                                  style: PromptStyle.locationAddress,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  destinationAddress,
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
                                '${duration.toStringAsFixed(0)} mins',
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
                                '${distance.toStringAsFixed(2)} km',
                                style: PromptStyle.buttonTextColor,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              navigateTo(widget.lat, widget.long);
                            },
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
      ),
    );
  }
}
