import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart'; // For local storage

class SettingsController extends GetxController with SnackBarHelper {
  // Observables for email and password
  var email = ''.obs;
  var password = ''.obs;
  final LocalAuthentication auth =
      LocalAuthentication(); // Initialize local auth
  var isFingerprintEnabled = false.obs;
  // TextEditingController for the input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final LocationController locationController = Get.put(LocationController());

  // Instance of ApiService
  final ApiService apiService =
      ApiService(); // Replace with your actual base URL

  // Device token (for demonstration purposes, this should be retrieved from your device)
  final String deviceToken = '';
  void onInit() {
    super.onInit();
    checkFingerprintStatus(); // Check initial fingerprint status on init
  }

// Check if fingerprint is enabled
  Future<void> checkFingerprintStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isFingerprintEnabled.value = prefs.getBool('isFingerprintEnabled') ?? false;
  }

  // Enable fingerprint authentication
  Future<void> enableFingerprint() async {
    try {
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to enable fingerprint login',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        isFingerprintEnabled.value = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isFingerprintEnabled', true);

        showNormalSnackBar("Fingerprint authentication enabled.");
      } else {
        showErrorSnackBar("Fingerprint authentication failed.");
      }
    } catch (e) {
      showErrorSnackBar("An error occurred: $e");
    }
  }

  // Disable fingerprint authentication
  Future<void> disableFingerprint() async {
    isFingerprintEnabled.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFingerprintEnabled', false);
    showNormalSnackBar("Fingerprint authentication disabled.");
  }

  Future<void> toggleFingerprint(bool isEnabled) async {
    if (isEnabled) {
      try {
        bool canCheckBiometrics = await auth.canCheckBiometrics;
        bool isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to enable fingerprint',
        );
        if (canCheckBiometrics && isAuthenticated) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFingerprintEnabled', true);
          showNormalSnackBar("Fingerprint authentication enabled sucessfully.");
          // Show confirmation dialog
        } else {
          showErrorSnackBar('Fingerprint authentication failed.');
        }
      } catch (e) {
        showErrorSnackBar('An error occurred: $e');
      }
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isFingerprintEnabled', false);
    }
    isFingerprintEnabled.value = isEnabled;
  }

  Future<void> verifyFingerprint() async {
    final prefs = await SharedPreferences.getInstance();
    bool fingerprintEnabled = prefs.getBool('isFingerprintEnabled') ?? false;

    if (fingerprintEnabled) {
      try {
        bool canCheckBiometrics = await auth.canCheckBiometrics;
        bool isAuthenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to access the app',
        );

        if (!canCheckBiometrics || !isAuthenticated) {
          Get.offAllNamed(Routes.login);
        } else {
          Get.offAllNamed(Routes.dashboard);
        }
      } catch (e) {
        showErrorSnackBar('An error occurred during authentication: $e');
        Get.offAllNamed(Routes.login);
      }
    }
  }

  // Method to handle login
  void logout() async {
    try {
      final response = await apiService.logout();

      if (response.statusCode == 200) {
        // Parse successful response

        final prefs = await SharedPreferences.getInstance();

        await prefs.remove('access_token');
        await prefs.remove('driveId');
        await prefs.remove('isFingerprintEnabled');
        await prefs.remove('name');
        await prefs.remove('username');
        await prefs.remove('phone_number');

        Get.delete<SettingsController>();
        Get.offAllNamed(Routes.login);
        locationController.stopLocationUpdates;
        showNormalSnackBar("Logged out successfully");
      } else {
        // Parse error response
        final responseData = jsonDecode(response.body);
        if (responseData['errors'] != null) {
          // Handle validation errors
          final validationErrors = responseData['errors'];
          final errorMessage = validationErrors.isNotEmpty
              ? validationErrors.values.first.join(', ')
              : 'Unknown error';
          showErrorSnackBar("Error: $errorMessage");
        } else {
          // Handle general error
          final errorMessage = responseData['message'] ?? 'Unknown error';
          showErrorSnackBar("Error: $errorMessage");
        }

        // Save error message and status code locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('error_status_code', response.statusCode);
        await prefs.setString(
            'error_message', responseData['message'] ?? 'Unknown error');

        await prefs.remove('access_token');
        await prefs.remove('driveId');
        Get.delete<SettingsController>();
        Get.offAllNamed(Routes.login);
        locationController.stopLocationUpdates;
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      showErrorSnackBar("An error occurred: $e");

      // Save error message and status code locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('error_status_code', -1); // -1 indicates an exception
      await prefs.setString('error_message', e.toString());
    }
  }

  Future<void> showLogoutAlert() async {
    await Get.dialog(
      AlertDialog(
        title: const Center(
          child: Text('Logout',
              style: TextStyle(
                fontFamily: AppStrings.fontFamilyPrompt,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
                fontSize: 18,
              )),
        ),
        content: const Text('Are you sure, do you want to logout?',
            style: TextStyle(
              fontFamily: AppStrings.fontFamilyPrompt,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              fontSize: 12,
            )),
        actions: [
          TextButton(
            onPressed: () async {
              logout();
            },
            child: const Text(
              'Yes',
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
              'No',
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
            onPressed: () async {},
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
