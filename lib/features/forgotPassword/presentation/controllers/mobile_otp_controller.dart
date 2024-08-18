import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/features/forgotPassword/presentation/views/forgot_password_view.dart';

class MobileOtpController extends GetxController {
  var isOtpSent = false.obs;

  void sendOtp() {
    // Simulate sending OTP
    isOtpSent.value = true;
    Get.snackbar('OTP Sent', 'OTP has been sent to your mobile number.',
        colorText: AppColors.colorWhite, backgroundColor: AppColors.green);
  }

  void verifyOtp() {
    // Simulate OTP verification
    Get.snackbar(
        'OTP Verified', 'You have successfully verified your mobile number.');
    Get.to(() => const ForgotPasswordView());
  }
}

class MobileOtpScreen extends StatelessWidget {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final MobileOtpController controller = Get.put(MobileOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Mobile Number'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.sendOtp,
              child: Text('Send OTP'),
            ),
            SizedBox(height: 40),
            Obx(() {
              return controller.isOtpSent.value
                  ? Column(
                      children: [
                        TextField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter OTP',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: controller.verifyOtp,
                          child: Text('Verify OTP'),
                        ),
                      ],
                    )
                  : SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: MobileOtpScreen(),
  ));
}
