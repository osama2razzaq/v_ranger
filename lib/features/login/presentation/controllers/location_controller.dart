import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/core/values/app_text_style.dart';

class LocationController extends GetxController {
  var currentLocation = Rxn<LocationData>();
  final Location _location = Location();
  final ApiService apiService = ApiService();
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
      updateLocation();
    } catch (e) {
      showErrorAlert(e.toString());
    }
  }

  Future<void> updateLocation() async {
    try {
      final result = await apiService.postUpdateLocation(
          currentLocation.value!.latitude!, currentLocation.value!.longitude!);
      print(result);
    } catch (e) {}
  }

  Future<void> showServiceAlert() async {
    await Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text('Location Service',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 18,
              )),
        ),
        content:
            const Text('Location services are required. Please enable them.',
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyPrompt,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                  fontSize: 12,
                )),
        actions: [
          TextButton(
            onPressed: () async {
              // Open the location settings
              await Geolocator.openLocationSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
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
        title: const Center(
          child: Text('Location Permission',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 18,
              )),
        ),
        content:
            const Text('Location permissions are required. Please grant them.',
                style: TextStyle(
                  fontFamily: AppStrings.fontFamilyPrompt,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                  fontSize: 12,
                )),
        actions: [
          TextButton(
            onPressed: () async {
              // Open the app settings
              await Geolocator.openAppSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
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
        title: const Center(child: const Text('Error')),
        content: Text('Failed to get location: $message'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Dismiss the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
