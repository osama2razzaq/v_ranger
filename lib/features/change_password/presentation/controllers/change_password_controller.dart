import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/features/profile/data/model/profile_model.dart';

class ChangePasswordController extends GetxController with SnackBarHelper {
  final Rx<ProfileModel?> data = Rx<ProfileModel?>(null);
  final TextEditingController oldPasswordTextController =
      TextEditingController();
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
  void submit() {
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

    postChangePassword(
        oldPasswordTextController.text, confirmPasswordTextController.text);
  }

  Future<void> postChangePassword(
      String oldPassword, String newPassword) async {
    try {
      final result =
          await apiService.postChangePassword(oldPassword, newPassword);

      final responseData = jsonDecode(result!.body);
      final message = responseData['message'] ?? 'Unknown error';

      Get.back();
      showNormalSnackBar(message);
    } catch (e) {
      showNormalSnackBar('Failed to load data: $e');
      data.value = null; // Clear data on error
    }
  }
}
