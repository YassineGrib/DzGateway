import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class ImageUploadService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _bucketName = 'restaurant-images';

  /// Upload image to Supabase Storage
  static Future<String?> uploadImage(XFile imageFile, String folder) async {
    try {
      // Ensure bucket exists before uploading
      await createBucketIfNotExists();
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(imageFile.path)}';
      final filePath = '$folder/$fileName';
      final file = File(imageFile.path);

      final response = await _supabase.storage
          .from(_bucketName)
          .upload(filePath, file);

      if (response.isNotEmpty) {
        // Get public URL
        final publicUrl = _supabase.storage
            .from(_bucketName)
            .getPublicUrl(filePath);
        
        return publicUrl;
      }
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  /// Upload multiple images
  static Future<List<String>> uploadMultipleImages(List<XFile> imageFiles, String folder) async {
    List<String> uploadedUrls = [];
    
    for (XFile imageFile in imageFiles) {
      final url = await uploadImage(imageFile, folder);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }

  /// Delete image from storage
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract file path from URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final bucketIndex = pathSegments.indexOf(_bucketName);
      
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        
        await _supabase.storage
            .from(_bucketName)
            .remove([filePath]);
        
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  /// Create bucket if it doesn't exist
  static Future<void> createBucketIfNotExists() async {
    try {
      await _supabase.storage.createBucket(
        _bucketName,
        const BucketOptions(
          public: true,
          allowedMimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
          fileSizeLimit: '5MB',
        ),
      );
    } catch (e) {
      // Bucket might already exist, ignore error
      print('Bucket creation info: $e');
    }
  }
}