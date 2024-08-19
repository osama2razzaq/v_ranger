import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/profile/data/model/profile_model.dart';

class ForgotPasswordController extends GetxController with SnackBarHelper {
  final Rx<ProfileModel?> data = Rx<ProfileModel?>(null);

  final TextEditingController newPasswordTextController =
      TextEditingController();
  final TextEditingController confirmPasswordTextController =
      TextEditingController();
  final RxBool lifeCardUpdateController = false.obs;
  final ApiService apiService = ApiService();

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  // Method to validate password format (contains letters and numbers)
  bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // Method to check if new password and confirm password match
  bool doPasswordsMatch() {
    return newPasswordTextController.text == confirmPasswordTextController.text;
  }

  // Method to handle form submission and validation
  void submit(
    String phoneNumber,
    String resetCode,
  ) {
    final newPassword = newPasswordTextController.text;
    final confirmPassword = confirmPasswordTextController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showErrorSnackBar('Please fill in both password fields.');
      return;
    }

    if (!isValidPassword(newPassword)) {
      showErrorSnackBar(
          'Password must contain at least 8 characters, including both letters and numbers.');
      return;
    }

    if (!doPasswordsMatch()) {
      showErrorSnackBar('New password and confirm password do not match.');
      return;
    }

    postVerifyOTP(phoneNumber, resetCode, confirmPasswordTextController.text);
  }

  Future<void> postVerifyOTP(
      String phoneNumber, String resetCode, String newPassword) async {
    try {
      final response = await apiService.postResetPassword(
          phoneNumber, resetCode, newPassword);

      if (response?.statusCode == 200) {
        // Parse successful response
        final responseData = jsonDecode(response!.body);
        final message = responseData['message'];
        Get.offAllNamed(Routes.login);
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
  }
}
