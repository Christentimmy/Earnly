

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

Future<List<File>?> pickNoCompressedImages() async {
  try {
    final picker = ImagePicker();
    List<XFile> pickedFiles = await picker.pickMultiImage(
      limit: 5,
      imageQuality: 40,
    );

    if (pickedFiles.isNotEmpty) {
      List<File> files = [];

      for (var file in pickedFiles) {
        files.add(File(file.path));
      }

      return files;
    }
    return null;
  } catch (e) {
    debugPrint('Error picking multiple images: $e');
    return null;
  }
}
