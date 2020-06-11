
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickUtils {

  final picker = ImagePicker();

  Future<File> getImageCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    return File(pickedFile.path);
  }

  Future<File> getImageGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

}