import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../constants/colors.dart';

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> points;

  ImagePainter(this.image, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paintImage = Paint();

    // Calculate proportions in order not to stretch
    final imgAspect = image.width / image.height;
    final boxAspect = size.width / size.height;

    double drawWidth, drawHeight, dx, dy;

    if(imgAspect > boxAspect) {
      // The image is wider than the container - adjust by width
      drawWidth = size.width;
      drawHeight = size.width / imgAspect;
      dx = 0;
      dy = (size.height - drawHeight) / 2;
    } else {
      // The image is higher than the container - adjust by height
      drawHeight = size.height;
      drawWidth = size.height * imgAspect;
      dy = 0;
      dx = (size.width - drawWidth) / 2;
    }

    final dstRect = Rect.fromLTWH(dx, dy, drawWidth, drawHeight);
    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

    // Draw an image without distortion
    canvas.drawImageRect(image, srcRect, dstRect, paintImage);

    // Draw lines (mask)
    final paintMask = Paint()
      ..color = AppColors.maskRed
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 30.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      if(points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paintMask);
      }
    }
  }

  @override
  bool shouldRepaint(ImagePainter oldDelegate) =>
      oldDelegate.points != points;
}