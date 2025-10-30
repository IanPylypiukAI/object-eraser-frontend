import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ActionButtons extends StatelessWidget {
  final bool enableEraseButton;
  final VoidCallback onErasePressed;
  final VoidCallback onClearPressed;

  const ActionButtons({
    super.key,
    required this.enableEraseButton,
    required this.onErasePressed,
    required this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: enableEraseButton ? onErasePressed : null,
              icon: Icon(Icons.auto_fix_high, color: AppColors.textWhite, size: 20),
              label: Text('Erase Area', style: AppTextStyles.buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.eraseRed,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onClearPressed,
              icon: Icon(Icons.format_color_reset, color: AppColors.textDark, size: 20),
              label: Text('Clear Mask', style: AppTextStyles.buttonTextDark),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.clearYellow,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultButtons extends StatelessWidget {
  final VoidCallback onDownloadPressed;
  final VoidCallback onUploadPressed;

  const ResultButtons({
    Key? key,
    required this.onDownloadPressed,
    required this.onUploadPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onDownloadPressed,
              icon: Icon(Icons.download, color: AppColors.textWhite, size: 20),
              label: Text('Download', style: AppTextStyles.buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.downloadBlue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onUploadPressed,
              icon: Icon(Icons.photo_library, color: AppColors.textWhite, size: 20),
              label: Text('Upload', style: AppTextStyles.buttonText),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}