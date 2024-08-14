import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyCircularPercentIndicator extends StatelessWidget {
  final int totalValue;
  final int leftValue;
  final Color color;

  const MyCircularPercentIndicator({
    required this.totalValue,
    required this.leftValue,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the percentage of completion
    double percentage = (leftValue / totalValue);

    // Clamp the percentage to ensure it remains within the range of 0.0 to 1.0
    double displayPercent = percentage.clamp(0.0, 1.0);

    return CircularPercentIndicator(
      backgroundColor: color.withOpacity(0.2),
      radius: 20.0,
      lineWidth: 5.0,
      animation: true,
      percent: displayPercent,
      center: Text(
        "${(displayPercent * 100).toStringAsFixed(1)}%",
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 8.0),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: color,
    );
  }
}
