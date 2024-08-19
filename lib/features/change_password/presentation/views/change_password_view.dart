import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/values/app_colors.dart';

import 'package:v_ranger/core/values/app_text_style.dart';
import 'package:v_ranger/features/change_password/presentation/controllers/change_password_controller.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ChangePasswordController controller =
        Get.put(ChangePasswordController());

    return Scaffold(
        backgroundColor: AppColors.colorWhite,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          title: Text(
            "Change Password",
            style: PromptStyle.appBarTitleStyle,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    customTextField(
                        labelText: 'Old Password',
                        hintText: 'Enter old password',
                        context: context,
                        controller: controller.oldPasswordTextController),
                    customTextField(
                        labelText: 'New Password',
                        hintText: 'Enter new password',
                        context: context,
                        controller: controller.newPasswordTextController),
                    customTextField(
                        labelText: 'Confirm Password',
                        hintText: 'Enter confirm password',
                        context: context,
                        controller: controller.confirmPasswordTextController),
                  ],
                ),
                _buildSubmitButton(
                    buttonName: 'Submit',
                    context: context,
                    controller: controller),
              ],
            ),
          ),
        ));
  }

  Widget _buildSubmitButton(
      {required String buttonName,
      BuildContext? context,
      required ChangePasswordController controller}) {
    return SizedBox(
      width: MediaQuery.of(context!).size.width,
      child: SingleButton(
        bgColor: AppColors.primaryColor,
        buttonName: buttonName,
        onTap: () => controller.submit(),
      ),
    );
  }

  Widget customTextField(
      {String? labelText,
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
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              keyboardType: TextInputType.multiline, // Ensures t
              textAlign: TextAlign.start,
              cursorColor: AppColors.primaryColor,
              style: PromptStyle.dropDownInerText,
              obscureText: true, // Mask the password input
              decoration: InputDecoration(
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
