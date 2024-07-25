import 'package:flutter/material.dart';
import 'package:v_ranger/core/values/app_colors.dart';

class StepIndicator extends StatelessWidget {
  final bool isActive1;
  final bool isActive2;
  final bool isActive3;
  final int number1;
  final int number2;
  final int number3;

  StepIndicator(
      {required this.isActive1,
      required this.isActive2,
      required this.isActive3,
      required this.number1,
      required this.number2,
      required this.number3});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.boaderColor, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          stepCircle(number1, isActive1, context),
          stepDivider(context, isActive2),
          stepCircle(number2, isActive2, context),
          stepDivider(context, isActive3),
          stepCircle(number3, isActive3, context),
        ],
      ),
    );
  }

  Widget stepCircle(
    int number,
    bool isActive,
    BuildContext context,
  ) {
    return Container(
      padding: EdgeInsets.all(4.0), // Adjust padding for border width
      decoration: isActive == true
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryColor,
                width: 2.0,
              ),
            )
          : null,
      child: CircleAvatar(
          radius: 12.0,
          backgroundColor: isActive ? AppColors.primaryColor : Colors.grey,
          child: Text(
            '$number',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          )),
    );
  }

  Widget stepDivider(
    BuildContext context,
    bool isActive,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        height: 5.0,
        decoration: BoxDecoration(
            color: isActive ? AppColors.primaryColor : Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
