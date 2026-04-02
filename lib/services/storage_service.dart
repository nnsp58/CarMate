import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/supabase_constants.dart';
import 'supabase_service.dart';

class StorageService {
  /// Upload profile photo
  static Future<String> uploadProfilePhoto({
    required String userId,
    required File imageFile,
  }) async {
    try {
      const fileName = 'avatar.jpg';
      final filePath = '$userId/$fileName';

      // Upload file to storage
      await SupabaseService.client.storage
          .from(SupabaseConstants.profilePhotosBucket)
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get public URL
      final publicUrl = SupabaseService.client.storage
          .from(SupabaseConstants.profilePhotosBucket)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Failed to upload profile photo: $e');
    }
  }

  /// Upload document (driving license, vehicle RC)
  static Future<String> uploadDocument({
    required String userId,
    required File imageFile,
    required String docType,
  }) async {
    try {
      final fileName = '$docType.jpg';
      final filePath = '$userId/$fileName';

      // Upload file to storage
      await SupabaseService.client.storage
          .from(SupabaseConstants.documentsBucket)
          .upload(
            filePath,
            imageFile,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Get signed URL (for private documents)
      final signedUrlResponse = await SupabaseService.client.storage
          .from(SupabaseConstants.documentsBucket)
          .createSignedUrl(filePath, 3600); // 1 hour validity

      return signedUrlResponse;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  /// Get document URL (signed URL for private access)
  static Future<String?> getDocumentUrl({
    required String userId,
    required String docType,
  }) async {
    try {
      final filePath = '$userId/$docType.jpg';

      final signedUrlResponse = await SupabaseService.client.storage
          .from(SupabaseConstants.documentsBucket)
          .createSignedUrl(filePath, 3600); // 1 hour validity

      return signedUrlResponse;
    } catch (e) {
      // Document might not exist
      return null;
    }
  }

  /// Delete file from storage
  static Future<void> deleteFile({
    required String bucket,
    required String filePath,
  }) async {
    try {
      await SupabaseService.client.storage
          .from(bucket)
          .remove([filePath]);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick image from camera
  static Future<File?> pickImageFromCamera() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to capture image: $e');
    }
  }
}
