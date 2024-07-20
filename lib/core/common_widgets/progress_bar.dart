import 'package:flutter/material.dart';
import '../values/app_colors.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key, required this.count, required this.totalCount})
      : super(key: key);
  final num count;
  final String totalCount;

  @override
  Widget build(BuildContext context) {
    final double _barWidth = MediaQuery.of(context).size.width * 0.4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 20.0),
              height: 20.0,
              width: _barWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: const Color.fromRGBO(234, 234, 234, 1.0)),
            ),
            Container(
              height: 20.0,
              width: _barWidth * count / int.parse(totalCount),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: <Color>[
                      AppColors.gradientMiddleColor,
                      AppColors.gradientEndColor,
                      AppColors.gradientEndColor,
                      AppColors.gradientMiddleColor,
                    ],
                    stops: [0.25, 0.5, 0.75, 1.0],
                  )),
            ),
          ],
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.w600),
            children: <InlineSpan>[
              TextSpan(
                text: count.roundToDouble().toString().substring(0, 1),
                style: const TextStyle(
                    color: AppColors.gradientMiddleColor, fontSize: 24.0),
              ),
              TextSpan(text: "  /  $totalCount")
            ],
          ),
        ),
      ],
    );
  }
}
