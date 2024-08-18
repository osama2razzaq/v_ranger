import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/forgotPassword/presentation/controllers/mobile_otp_controller.dart';

class MobileOtpScreen extends StatelessWidget {
  final TextEditingController mobileTextController = TextEditingController();
  final TextEditingController otpTextController = TextEditingController();
  final MobileOtpController otpController = Get.put(MobileOtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorWhite,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "OTP Verification",
          style: PromptStyle.appBarTitleStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                customTextField(
                    context: context,
                    labelText: 'Mobile Number',
                    hintText: 'Enter mobile number',
                    controller: mobileTextController,
                    isOTP: true),
                const SizedBox(height: 20),
                Obx(() {
                  return otpController.isOtpSent.value
                      ? Column(
                          children: [
                            customTextField(
                                context: context,
                                labelText: 'OTP Number',
                                hintText: 'Enter otp',
                                controller: otpTextController,
                                isOTP: false),
                            const SizedBox(height: 20),
                          ],
                        )
                      : const SizedBox.shrink();
                }),
              ],
            ),
            Obx(() {
              return otpController.isOtpSent.value
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleButton(
                          buttonName: 'Verify OTP',
                          onTap: () {
                            otpController.verifyOtp();
                          }),
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }

  Widget customTextField(
      {String? labelText,
      bool? isOTP,
      String? hintText,
      required TextEditingController controller,
      Function(String)? onChanged,
      BuildContext? context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(labelText, style: PromptStyle.profileSubTitle),
            ),
          SizedBox(
            //    height: 50,
            child: TextField(
              textInputAction: TextInputAction.send,
              onChanged: onChanged,

              keyboardType: TextInputType.number, // Ensures t
              textAlign: TextAlign.start,
              cursorColor: AppColors.primaryColor,
              style: PromptStyle.dropDownInerText,

              decoration: InputDecoration(
                suffixIcon: isOTP == true
                    ? IconButton(
                        icon: Icon(
                          Icons.send,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          otpController.sendOtp();
                        },
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                hintText: hintText,
                hintStyle: PromptStyle.hintTextStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      12.0), // Adjust the radius as needed
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: AppColors.primaryColor,
                      width:
                          2.0), // Adjust the border color and width as needed
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                      color: AppColors.boaderColor,
                      width:
                          2.0), // Adjust the border color and width as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
