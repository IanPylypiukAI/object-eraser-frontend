import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ProgressDialog {
  static void show(
    BuildContext context,
    List<String> messages, {
    Duration durationPerStep = const Duration(seconds: 4),
  }) {
    showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.black38,
      transitionDuration: const Duration(milliseconds: 150),
      context: context,
      pageBuilder: (BuildContext ctx, Animation<double> anim1, Animation<double> anim2) {
        int currentIndex = 0;
        Timer? timer;

        return StatefulBuilder(
          builder: (context, setState) {
            // Start timer only once
            timer ??= Timer.periodic(durationPerStep, (t) {
              if(currentIndex < messages.length - 1) {
                setState(() => currentIndex++);
              } else {
                t.cancel();
              }
            });

            return Center(
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "AI is processing your image",
                        style: AppTextStyles.dialogTitle,
                      ),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, anim) =>
                            FadeTransition(opacity: anim, child: child),
                        child: Text(
                          messages[currentIndex],
                          key: ValueKey(messages[currentIndex]),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.commonText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}