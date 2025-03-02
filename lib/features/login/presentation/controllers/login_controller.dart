import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginController extends GetxController with SnackBarHelper {
  // Observables for email and password
  var email = ''.obs;
  var password = ''.obs;
  RxBool isLoading = false.obs;
  // TextEditingController for the input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Instance of ApiService
  final ApiService apiService =
      ApiService(); // Replace with your actual base URL

  // Device token (for demonstration purposes, this should be retrieved from your device)
  String? fcmtoken = '';

  // Method to handle login

  @override
  void onInit() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Get the FCM token
    fcmtoken = await messaging.getToken();
    print("FCM Token: $fcmtoken");

    super.onInit();
  }

  void login() async {
    isLoading.value = true;
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        final response = await apiService.login(
            emailController.text, passwordController.text, fcmtoken!);

        if (response.statusCode == 200) {
          // Parse successful response
          final responseData = jsonDecode(response.body);

          await saveLoginData(responseData);
          Get.offAllNamed(Routes.dashboard);
          isLoading.value = false;
          showNormalSnackBar("Login successful");
        } else {
          // Parse error response
          isLoading.value = false;
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
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        showErrorSnackBar("An error occurred: $e");
        isLoading.value = false;
        // Save error message and status code locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt(
            'error_status_code', -1); // -1 indicates an exception
        await prefs.setString('error_message', e.toString());
      }
    } else {
      showErrorSnackBar("Email or password cannot be empty");
    }
  }

  Future<void> saveLoginData(Map<String, dynamic> jsonResponse) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save access_token and details
    prefs.setString('access_token', jsonResponse['access_token']);
    prefs.setString('token_type', jsonResponse['token_type']);
    prefs.setString('details', jsonEncode(jsonResponse['details']));
  }
}
