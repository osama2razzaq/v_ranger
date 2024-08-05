import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_strings.dart';

abstract class PromptStyle {
  PromptStyle._();

  static const TextStyle defaultStyle = TextStyle(
    fontFamily: AppStrings.fontFamilyPrompt,
    fontWeight: FontWeight.w400,
    color: AppColors.colorDark,
  );

  static TextStyle mainLogoStyle = defaultStyle.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    color: AppColors.colorWhite,
  );
  static TextStyle appBarLogoStyle = defaultStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.colorWhite,
  );
  static TextStyle appBarTitleStyle = defaultStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.colorWhite,
  );
  static TextStyle profileNameStyle = defaultStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );
  static TextStyle leaderboardProfileNameStyle = defaultStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.gradientEndColor,
  );
  static TextStyle subLogoStyle1 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.red,
  );

  static TextStyle subLogoStyle2 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.yellow,
  );

  static TextStyle subLogoStyle3 = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.green,
  );

  static TextStyle textfieldLabelStyle = defaultStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.colorDark,
  );

  static TextStyle buttonTitleTextStyle = defaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.colorWhite,
  );
  static TextStyle buttonSubTitleTextStyle = defaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.colorWhite,
  );
  static TextStyle buttonTextColor = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryColor,
  );
  static TextStyle textfieldErrorStyle = defaultStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.red600,
  );
  static TextStyle textfieldHintStyle = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textColorGreyDark,
  );
  static TextStyle textfieldStyle = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.colorDark,
  );

  static TextStyle cardTitle = defaultStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.colorWhite,
  );
  static TextStyle cardSubTitle = defaultStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.colorWhite,
  );
  static TextStyle leaderboardHeaderTitle = defaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.scoreHeader,
  );

  static TextStyle profileTitle = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.scoreHeader,
  );
  static TextStyle profileSubTitle = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle locationAddress = defaultStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle tabbarTitile = defaultStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle greyDarkTextStyle = defaultStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.textColorGreyDark,
      height: 1.45);
}
