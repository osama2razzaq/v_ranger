import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_strings.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/core/values/app_values.dart';

mixin SnackBarHelper {
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  void removeSnackBar(BuildContext context) {
    snackbarKey.currentState?.removeCurrentSnackBar();
  }

  Widget showErrorSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((__) {
      Get.snackbar(
        AppStrings.error.tr,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        borderRadius: AppValues.radius_15,
        margin: const EdgeInsets.all(15),
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    });

    return Container();
  }

  Widget showNormalSnackBar(String message) {
    WidgetsBinding.instance.addPostFrameCallback((__) {
      Get.snackbar(
        'Alert',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        borderRadius: AppValues.radius_15,
        margin: const EdgeInsets.all(15),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    });

    return Container();
  }

  void removeErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  void showWarningSnackBar(BuildContext context, {String? message}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ''),
        backgroundColor: Colors.orange,
        duration: const Duration(
          seconds: 18,
        ),
      ),
    );
  }

  void showNoInternetSnackBar({String? message}) {
    ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        margin: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message ?? AppStrings.noInternetConnection.tr,
          style: PromptStyle.greyDarkTextStyle.copyWith(
              fontWeight: FontWeight.w600, color: AppColors.colorWhite),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.red400,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void removeShowNoInternetSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
