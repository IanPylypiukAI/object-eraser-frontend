import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../constants/colors.dart';

class BeforeAfterSlider extends StatefulWidget {
  final File beforeFile;
  final String? afterBase64;

  const BeforeAfterSlider({
    super.key,
    required this.beforeFile,
    required this.afterBase64,
  });

  @override
  State<BeforeAfterSlider> createState() => _BeforeAfterSliderState();
}

class _BeforeAfterSliderState extends State<BeforeAfterSlider> {
  double _dividerPosition = 0.5;
  ui.Image? _beforeUiImage;
  Image? _afterImage;

  @override
  void initState() {
    super.initState();
    _loadBeforeImage();
    if(widget.afterBase64 != null) {
      _afterImage = Image.memory(
        base64Decode(widget.afterBase64!.split(',').last),
        fit: BoxFit.contain,
      );
    }
  }

  Future<void> _loadBeforeImage() async {
    final bytes = await widget.beforeFile.readAsBytes();
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (img) => completer.complete(img));
    final uiImg = await completer.future;
    setState(() {
      _beforeUiImage = uiImg;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_beforeUiImage == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final imgAspect = _beforeUiImage!.width / _beforeUiImage!.height;

    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final maxHeight = constraints.maxHeight;

      double displayWidth, displayHeight;
      if(maxWidth / maxHeight > imgAspect) {
        displayHeight = maxHeight;
        displayWidth = displayHeight * imgAspect;
      } else {
        displayWidth = maxWidth;
        displayHeight = displayWidth / imgAspect;
      }

      final widthDivider = displayWidth * _dividerPosition;

      return Center(
        child: SizedBox(
          width: displayWidth,
          height: displayHeight,
          child: Stack(
            children: [
              Image.file(
                widget.beforeFile,
                fit: BoxFit.contain,
                width: displayWidth,
                height: displayHeight,
              ),
              if(_afterImage != null)
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: _dividerPosition,
                    child: SizedBox(
                      width: displayWidth,
                      height: displayHeight,
                      child: _afterImage,
                    ),
                  ),
                ),
              // Vertical divider
              Positioned(
                left: widthDivider - 1,
                top: 0,
                height: displayHeight,
                child: Container(
                  width: 3,
                  color: AppColors.dividerWhite,
                ),
              ),
              // Scroll thumb
              Positioned(
                left: widthDivider - 24,
                top: displayHeight / 2 - 24,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dividerPosition = (_dividerPosition +
                              details.delta.dx / displayWidth)
                          .clamp(0.0, 1.0);
                    });
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.sliderBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.compare_arrows,
                      color: AppColors.sliderIcon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}