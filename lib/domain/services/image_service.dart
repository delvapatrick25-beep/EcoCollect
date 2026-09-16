import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

abstract class ImageService {
  Future<XFile?> pickImage(ImageSource source);

  Future<Uint8List> compressImage(Uint8List bytes);
}