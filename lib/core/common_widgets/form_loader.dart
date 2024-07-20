import 'package:flutter/material.dart';
import 'package:v_ranger/core/values/app_colors.dart';
import 'package:v_ranger/core/values/app_values.dart';

class FormLoader extends StatelessWidget {
  final Color circularColor;
  const FormLoader({this.circularColor = AppColors.colorWhite, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppValues.margin_10),
      height: AppValues.margin_40,
      width: AppValues.margin_40,
      child: CircularProgressIndicator(color: circularColor, strokeWidth: 2),
    );
  }
}
