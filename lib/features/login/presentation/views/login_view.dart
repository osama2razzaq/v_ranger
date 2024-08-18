import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/common_widgets/custom_text_field.dart';
import 'package:v_ranger/core/common_widgets/single_button.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:v_ranger/core/values/values.dart';
import 'package:v_ranger/features/forgotPassword/presentation/views/forgot_password_view.dart';
import 'package:v_ranger/features/forgotPassword/presentation/views/opt_verification_view.dart';
import 'package:v_ranger/features/login/presentation/controllers/location_controller.dart';
import 'package:v_ranger/features/login/presentation/controllers/login_controller.dart';

class LoginView extends StatelessWidget with SnackBarHelper {
  LoginView({super.key});
  final LocationController locationController = Get.put(LocationController());
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildConntainer(context),
              _buildLoginButton(buttonName: "Login"),
              _buildForgotTextButton(
                () => Get.to(() => MobileOtpScreen()),
                'Forgot Password',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConntainer(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: deviceHeight / 1.2,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.loose,
        // alignment: AlignmentDirectional.topStart,
        children: [
          Container(
            height: deviceHeight / 2,
            width: deviceWidth,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                _buildLogo(),
                _buildSubLogo(),
                _buildImage(),
              ],
            ),
          ),
          Positioned(
            top: 270,
            left: 0,
            right: 0,
            child: Container(
              // height: deviceHeight / 2.5,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.primaryWithOpColor,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.2),

                    offset: const Offset(0, 0), // x and y offset
                    blurRadius: 10, // Blur radius
                    spreadRadius: 0, // Spread radius
                  ),
                ],
              ),

              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.colorWhite,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: _buildWelcome(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: _buildLoginFrom(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(AppStrings.appTtile, style: PromptStyle.mainLogoStyle),
        ),
      ],
    );
  }

  Widget _buildWelcome() {
    return const Column(
      // alignment: Alignment.centerRight,
      children: [
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome!',
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyPrompt,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  )),
              Text("Login to your account",
                  style: TextStyle(
                    fontFamily: AppStrings.fontFamilyPrompt,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryColor,
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubLogo() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text.rich(
            TextSpan(
              text: '', // Default text style
              children: <TextSpan>[
                TextSpan(
                    text: "${AppStrings.appSubTitle1} ",
                    style: PromptStyle.subLogoStyle1),
                TextSpan(
                    text: "${AppStrings.appSubTitle2} ",
                    style: PromptStyle.subLogoStyle2),
                TextSpan(
                    text: AppStrings.appSubTitle3,
                    style: PromptStyle.subLogoStyle3),
              ],
            ),
          ),
        ),

        //  Text(AppStrings.appSubTitle, style: PromptStyle.subLogoStyle),
      ],
    );
  }

  Widget _buildLoginButton({required String buttonName}) {
    return SingleButton(
        bgColor: AppColors.primaryColor,
        buttonName: buttonName,
        onTap: () => {
              controller.login()
            } // controller.login, //{Get.offAllNamed(Routes.dashboard)},
        );
  }

  Widget _buildForgotTextButton(VoidCallback onTap, String? buttonText) {
    return Padding(
      padding: const EdgeInsets.only(
          right: AppValues.margin_20,
          top: AppValues.margin_6,
          bottom: AppValues.margin_15),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          child: Text(
            buttonText ?? '',
            style: PromptStyle.buttonTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Align(
            alignment: Alignment.center,
            child: Container(
              //  height: 154,
              // width: 390,
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Image.asset(
                'assets/images/map.png', // Replace with your image asset
              ),
            )),

        //  Text(AppStrings.appSubTitle, style: PromptStyle.subLogoStyle),
      ],
    );
  }

  Widget _buildLoginFrom() {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    CustomTextField(
                        labelText: 'Login',
                        textEditingController: controller.emailController,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ]),
                    CustomTextField(
                      labelText: 'Password',
                      textEditingController: controller.passwordController,
                      isPassword: true,
                      hidePasswordIcon: false,
                    ),
                  ],
                )

                // width: 390,
                )),

        //  Text(AppStrings.appSubTitle, style: PromptStyle.subLogoStyle),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
