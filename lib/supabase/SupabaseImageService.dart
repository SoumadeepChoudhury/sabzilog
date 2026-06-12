import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseImageService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Uint8List?> compressTo200KB(String path) async {
    int quality = 80;

    Uint8List? result;

    do {
      result = await FlutterImageCompress.compressWithFile(
        path,
        quality: quality,
        minWidth: 720,
        minHeight: 720,
      );

      if (result == null) return null;

      print(
        'Quality: $quality | Size: ${(result.lengthInBytes / 1024).toStringAsFixed(2)} KB',
      );

      quality -= 10;
    } while (result.lengthInBytes > 200 * 1024 && quality >= 10);

    return result;
  }

  Future<String?> pickCompressAndUpload(File imageFile) async {
    try {
      // Compress image
      Uint8List? compressedBytes = await compressTo200KB(imageFile.path);

      if (compressedBytes == null) {
        throw Exception("Image compression failed");
      }

      // Unique filename
      final String fileName = '${Uuid().v4()}.jpg';

      // Upload
      await supabase.storage
          .from('images')
          .uploadBinary(
            fileName,
            compressedBytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: false,
            ),
          );

      // Get public URL
      final String publicUrl = supabase.storage
          .from('images')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}
