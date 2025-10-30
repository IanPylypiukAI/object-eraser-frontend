import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageUtils {
  // Get image size from file
  static Future<ui.Image> getImageSize(File file) async {
    final bytes = await file.readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (img) => completer.complete(img));
    return completer.future;
  }

  // Generate mask image from drawn points
  static Future<Uint8List> generateMask(
    int imgWidth,
    int imgHeight,
    BoxConstraints constraints,
    List<Offset> points,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Black background (not removed)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, imgWidth.toDouble(), imgHeight.toDouble()),
      Paint()..color = Colors.black,
    );

    // Calculate the scale and indents exactly the same as in Painter
    final imgAspect = imgWidth / imgHeight;
    final boxAspect = constraints.maxWidth / constraints.maxHeight;

    double drawWidth, drawHeight, dx, dy;

    if(imgAspect > boxAspect) {
      drawWidth = constraints.maxWidth;
      drawHeight = constraints.maxWidth / imgAspect;
      dx = 0;
      dy = (constraints.maxHeight - drawHeight) / 2;
    } else {
      drawHeight = constraints.maxHeight;
      drawWidth = constraints.maxHeight * imgAspect;
      dy = 0;
      dx = (constraints.maxWidth - drawWidth) / 2;
    }

    final scaleX = imgWidth / drawWidth;
    final scaleY = imgHeight / drawHeight;

    // Draw lines in image coordinates
    final paint = Paint()
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 50.0 * ((scaleX + scaleY) / 2) * 0.7
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      if(p1 != Offset.zero && p2 != Offset.zero) {
        final x1 = (p1.dx - dx) * scaleX;
        final y1 = (p1.dy - dy) * scaleY;
        final x2 = (p2.dx - dx) * scaleX;
        final y2 = (p2.dy - dy) * scaleY;
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(imgWidth, imgHeight);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}