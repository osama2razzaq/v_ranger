import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  var currentLocation = Rxn<LocationData>();
  final Location _location = Location();

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Ensure location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    while (!serviceEnabled) {
      await showServiceAlert();
      serviceEnabled = await _location.requestService();
    }

    // Ensure location permissions are granted
    permissionGranted = await _location.hasPermission();
    while (permissionGranted != PermissionStatus.granted) {
      await showPermissionAlert();
      permissionGranted = await _location.requestPermission();
    }

    // Get the current location
    try {
      currentLocation.value = await _location.getLocation();
    } catch (e) {
      showErrorAlert(e.toString());
    }
  }

  Future<void> showServiceAlert() async {
    await Get.dialog(
      AlertDialog(
        title: Text('Location Service'),
        content: Text('Location services are required. Please enable them.'),
        actions: [
          TextButton(
            onPressed: () async {
              // Open the location settings
              await Geolocator.openLocationSettings();
            },
            child: Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
    );
  }

  Future<void> showPermissionAlert() async {
    await Get.dialog(
      AlertDialog(
        title: Text('Location Permission'),
        content: Text('Location permissions are required. Please grant them.'),
        actions: [
          TextButton(
            onPressed: () async {
              // Open the app settings
              await Geolocator.openAppSettings();
            },
            child: Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: Text('Cancel'),
          ),
        ],
      ),
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
    );
  }

  Future<void> showErrorAlert(String message) async {
    await Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text('Failed to get location: $message'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
