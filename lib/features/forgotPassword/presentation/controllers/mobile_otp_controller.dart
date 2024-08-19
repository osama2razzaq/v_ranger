import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';

import 'package:v_ranger/features/forgotPassword/presentation/views/forgot_password_view.dart';

class MobileOtpController extends GetxController with SnackBarHelper {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController otpTextController = TextEditingController();
  var isOtpSent = false.obs;
  final ApiService apiService = ApiService();

  Future<void> postSendOtp() async {
    if (mobileTextController.text.isNotEmpty) {
      try {
        final response =
            await apiService.postSendOTP(mobileTextController.text);

        if (response?.statusCode == 200) {
          // Parse successful response
          final responseData = jsonDecode(response!.body);
          final message = responseData['message'];
          isOtpSent.value = true;
          showNormalSnackBar(message);
        } else {
          // Parse error response
          final responseData = jsonDecode(response!.body);
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
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        showErrorSnackBar("An error occurred: $e");
      }
    } else {
      showErrorSnackBar("Mobile number cannot be empty");
    }
  }

  Future<void> postVerifyOTP() async {
    if (otpTextController.text.isNotEmpty) {
      try {
        final response = await apiService.postVerifyOTP(
            mobileTextController.text, otpTextController.text);

        if (response?.statusCode == 200) {
          // Parse successful response
          final responseData = jsonDecode(response!.body);
          final message = responseData['message'];
          Get.to(() => ForgotPasswordView(
                mobileNo: mobileTextController.text,
                otpCode: otpTextController.text,
              ));
          showNormalSnackBar(message);
        } else {
          // Parse error response
          final responseData = jsonDecode(response!.body);
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
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        showErrorSnackBar("An error occurred: $e");
      }
    } else {
      showErrorSnackBar("Mobile number cannot be empty");
    }
  }
}
