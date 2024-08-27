import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/login/presentation/controllers/fingerprint_auth_controller.dart';

class FingerprintAuthPage extends StatelessWidget {
  FingerprintAuthPage({super.key});

  final FingerprintAuthController controller =
      Get.put(FingerprintAuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 25,
            ),
            onPressed: () {
              // Close the app
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor,
                ),
                alignment: Alignment.center,
                child: Text(
                  controller.name.value.isEmpty
                      ? ''
                      : controller.name.value.substring(0, 2).toUpperCase(),
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "***${formatPhoneLikeString(controller.phoneNo.value)}",
                // '**0325',
                style: TextStyle(fontSize: 24, color: AppColors.colorDark),
              ),
              const SizedBox(height: 20),
              if (!controller.isFingerprintEnabled.value)
                const Text(
                  'Fingerprint operation canceled by user.',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  controller.verifyFingerprint();
                },
                child: const Icon(
                  Icons.fingerprint,
                  size: 60,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Touch-ID',
                style: TextStyle(fontSize: 20, color: AppColors.primaryColor),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.login);
                },
                child: Text(
                  'Log In with Password',
                  style: PromptStyle.buttonTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatPhoneLikeString(String input) {
    if (input.length > 4) {
      return input.substring(input.length - 4);
    } else {
      return input; // If the input has 4 or fewer characters, return it as is.
    }
  }
}
