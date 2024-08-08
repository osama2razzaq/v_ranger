import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:v_ranger/core/values/app_colors.dart';

class DashedLinePainter extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    double dashWidth = 9, dashSpace = 5;
    final paint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double radius = 20;
    Path path = Path()
      ..moveTo(radius, 0) // Start at top-left corner with radius offset
      ..lineTo(size.width - radius, 0) // Top side
      ..arcToPoint(Offset(size.width, radius),
          radius: Radius.circular(radius)) // Top-right corner
      ..lineTo(size.width, size.height - radius) // Right side
      ..arcToPoint(Offset(size.width - radius, size.height),
          radius: Radius.circular(radius)) // Bottom-right corner
      ..lineTo(radius, size.height) // Bottom side
      ..arcToPoint(Offset(0, size.height - radius),
          radius: Radius.circular(radius)) // Bottom-left corner
      ..lineTo(0, radius) // Left side
      ..arcToPoint(Offset(radius, 0),
          radius: Radius.circular(radius)); // Top-left corner

    // Create a dashed effect by breaking the path into segments
    Path dashPath = Path();
    // ignore: unused_local_variable
    double totalLength =
        path.computeMetrics().fold(0, (prev, metric) => prev + metric.length);
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final segmentLength = dashWidth + dashSpace;
        final nextDistance = distance + segmentLength;
        final isFullSegment = nextDistance < pathMetric.length;
        final pathSegment = pathMetric.extractPath(
          distance,
          isFullSegment ? distance + dashWidth : pathMetric.length,
        );
        dashPath.addPath(pathSegment, Offset.zero);
        distance = nextDistance;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
