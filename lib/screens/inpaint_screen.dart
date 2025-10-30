import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import '../constants/colors.dart';
import '../services/inpaint_service.dart';
import '../utils/image_utils.dart';
import '../widgets/action_buttons.dart';
import '../widgets/progress_dialog.dart';
import '../widgets/image_painter.dart';
import '../widgets/before_after_slider.dart';

class InpaintScreen extends StatefulWidget {
  const InpaintScreen({super.key});

  @override
  InpaintScreenState createState() => InpaintScreenState();
}

class InpaintScreenState extends State<InpaintScreen> {
  File? _image;
  List<Offset> _points = [];
  String? _inpaintedBase64;
  Uint8List? _maskImage;
  final _paintKey = GlobalKey();
  BoxConstraints? _lastConstraints;
  bool _enableEraseAreaButton = false;

  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _points = [];
        _inpaintedBase64 = null;
        _enableEraseAreaButton = false;
      });
    }
  }

  Future<void> _sendInpaint() async {
    if(_image == null || _lastConstraints == null) return;

    ProgressDialog.show(
      context,
      [
        'Erasing the selected area...',
        'Detecting object boundaries...',
        'Working the magic...',
        'Finishing up — almost there...'
      ],
    );

    try {
      final uiImage = await ImageUtils.getImageSize(_image!);
      final maskBytes = await ImageUtils.generateMask(
        uiImage.width,
        uiImage.height,
        _lastConstraints!,
        _points,
      );

      final result = await InpaintService.inpaintImage(_image!, maskBytes);

      ProgressDialog.hide(context);

      if(result != null) {
        setState(() {
          _inpaintedBase64 = result;
        });
      }
    } catch (e) {
      ProgressDialog.hide(context);
      print('Error during inpaint: $e');
    }
  }

  void _clearMask() {
    setState(() {
      _points.clear();
      _inpaintedBase64 = null;
      _enableEraseAreaButton = false;
    });
  }

  void _downloadImage() {
    if(_inpaintedBase64 != null) {
      InpaintService.shareImage(_inpaintedBase64!, "inpainted.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        title: Text('Erase Object', style: AppTextStyles.appBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            
            // Action buttons (Erase Area / Clear Mask)
            ActionButtons(
              enableEraseButton: _enableEraseAreaButton,
              onErasePressed: _sendInpaint,
              onClearPressed: _clearMask,
            ),

            SizedBox(height: 16),

            // Debug mask display (optional)
            if(_maskImage != null)
              Image.memory(_maskImage!, fit: BoxFit.contain),

            // Main content area
            Expanded(
              child: _buildMainContent(),
            ),

            SizedBox(height: 16),

            // Bottom buttons
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if(_image == null) {
      return const Center(child: Text(
        'Image is not chosen',
        style: AppTextStyles.commonText,
      ));
    }

    if(_inpaintedBase64 != null) {
      return BeforeAfterSlider(
        beforeFile: _image!,
        afterBase64: _inpaintedBase64,
      );
    }

    return FutureBuilder<ui.Image>(
      future: ImageUtils.getImageSize(_image!),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final uiImage = snapshot.data!;
        return LayoutBuilder(
          builder: (context, constraints) {
            _lastConstraints = constraints;
            return GestureDetector(
              onPanUpdate: (details) {
                RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPos = box.globalToLocal(details.globalPosition);
                setState(() {
                  _points.add(localPos);
                  // Enable button after first stroke
                  if(!_enableEraseAreaButton && _points.length == 1) {
                    _enableEraseAreaButton = true;
                  }
                });
              },
              onPanEnd: (_) => _points.add(Offset.zero),
              child: CustomPaint(
                key: _paintKey,
                painter: ImagePainter(uiImage, _points),
                size: Size.infinite,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    if(_inpaintedBase64 != null) {
      return ResultButtons(
        onDownloadPressed: _downloadImage,
        onUploadPressed: _pickImage,
      );
    }

    return ElevatedButton.icon(
      onPressed: _pickImage,
      icon: Icon(Icons.photo_library, color: AppColors.textWhite, size: 20),
      label: Text('Upload Photo', style: AppTextStyles.buttonText),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}