import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/requests.dart' as request_constants;

class InpaintService {

  // Send image and mask to inpainting API
  static Future<String?> inpaintImage(File imageFile, Uint8List maskBytes) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${request_constants.baseUrl}/inpaint'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      request.files.add(
        http.MultipartFile.fromBytes('mask', maskBytes, filename: 'mask.png'),
      );

      final response = await request.send();
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);

      return data['inpainted_base64'];
    } catch (e) {
      print('Error during inpainting: $e');
      return null;
    }
  }

  // Share/download inpainted image
  static Future<void> shareImage(String base64Data, String filename) async {
    try {
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/$filename';
      final file = File(filePath);

      final bytes = base64Decode(base64Data.split(',').last);
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Downloaded from Object Eraser',
          files: [XFile(file.path)],
        ),
      );
    } catch (e) {
      print('Error while downloading/sharing: $e');
    }
  }
}