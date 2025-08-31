import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class UserService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Get current user profile from database
  static Future<UserModel?> getCurrentUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        // User profile doesn't exist, create it
        final success = await createUserProfile(
          userId: user.id,
          email: user.email ?? '',
          fullName: user.userMetadata?['full_name'] as String?,
        );
        
        if (success) {
          // Try to get the profile again
          final newResponse = await _supabase
              .from('users')
              .select()
              .eq('id', user.id)
              .single();
          return UserModel.fromJson(newResponse);
        }
        return null;
      }

      return UserModel.fromJson(response);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Update user profile in database
  static Future<bool> updateUserProfile({
    String? fullName,
    String? phone,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final updateData = <String, dynamic>{};
      if (fullName != null) updateData['full_name'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      updateData['updated_at'] = DateTime.now().toIso8601String();

      await _supabase
          .from('users')
          .update(updateData)
          .eq('id', user.id);

      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  /// Create user profile after signup
  static Future<bool> createUserProfile({
    required String userId,
    required String email,
    String? fullName,
    String? phone,
    String role = 'user',
  }) async {
    try {
      await _supabase.from('users').insert({
        'id': userId,
        'email': email,
        'full_name': fullName,
        'phone': phone,
        'role': role,
        'is_active': true,
      });

      return true;
    } catch (e) {
      print('Error creating user profile: $e');
      return false;
    }
  }

  /// Delete user profile
  static Future<bool> deleteUserProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase
          .from('users')
          .delete()
          .eq('id', user.id);

      return true;
    } catch (e) {
      print('Error deleting user profile: $e');
      return false;
    }
  }

  /// Check if user profile exists
  static Future<bool> userProfileExists() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response = await _supabase
          .from('users')
          .select('id')
          .eq('id', user.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking user profile existence: $e');
      return false;
    }
  }

  /// Get user statistics (for profile page)
  static Future<Map<String, int>> getUserStats() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        return {
          'services': 0,
          'reviews': 0,
          'bookings': 0,
        };
      }

      // For now, return mock data
      // In a real app, you would query related tables
      return {
        'services': 12,
        'reviews': 45,
        'bookings': 8,
      };
    } catch (e) {
      print('Error getting user stats: $e');
      return {
        'services': 0,
        'reviews': 0,
        'bookings': 0,
      };
    }
  }
}