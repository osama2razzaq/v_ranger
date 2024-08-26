import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

  // TextEditingController for the input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final LocationController locationController = Get.put(LocationController());

  // Instance of ApiService
  final ApiService apiService =
      ApiService(); // Replace with your actual base URL

  // Device token (for demonstration purposes, this should be retrieved from your device)
  final String deviceToken = '131131';

  // Method to handle login
  void logout() async {
    try {
      final response = await apiService.logout();

      if (response.statusCode == 200) {
        // Parse successful response

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        await prefs.remove('driveId');
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

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
