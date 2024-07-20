import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:v_ranger/core/values/app_values.dart';
import 'package:v_ranger/core/values/values.dart';

import 'form_loader.dart';

class SingleButton extends StatelessWidget {
  final String buttonName;
  final String? iconPath;
  final Color? bgColor;
  final Color? iconColor;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;
  final bool isEnabled;
  final bool isLoading;

  ///Default button customized with the design of our app
  const SingleButton({
    required this.buttonName,
    required this.onTap,
    Key? key,
    this.isEnabled = true,
    this.isLoading = false,
    this.bgColor = AppColors.primaryColor,
    this.iconColor,
    this.margin,
    this.iconPath,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      height: AppValues.maxButtonHeight,
      width: width ?? Get.width / 1.8,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [
                    AppColors.gradientStartColor, // Start color
                    AppColors.gradientMiddleColor,
                    AppColors.gradientEndColor, // End color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(20), // Adjust if needed
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: !isEnabled
                  ? AppColors.disabledButtonBgColor
                  : isLoading
                      ? bgColor
                      : null,
              shape: const StadiumBorder()),
          onPressed: isEnabled && !isLoading ? onTap : null,
          child: isLoading
              ? const FormLoader()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      buttonName,
                      style: PromptStyle.buttonSubTitleTextStyle,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
