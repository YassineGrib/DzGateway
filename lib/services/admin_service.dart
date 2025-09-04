import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'user_service.dart';

class AdminService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Check if current user is admin
  static Future<bool> isCurrentUserAdmin() async {
    try {
      final userProfile = await UserService.getCurrentUserProfile();
      return userProfile?.role == 'admin';
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  /// Get current admin profile
  static Future<UserModel?> getCurrentAdminProfile() async {
    try {
      final userProfile = await UserService.getCurrentUserProfile();
      if (userProfile?.role == 'admin') {
        return userProfile;
      }
      return null;
    } catch (e) {
      print('Error getting admin profile: $e');
      return null;
    }
  }

  /// Create admin user (only for initial setup)
  static Future<bool> createAdminUser({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      // Sign up the user
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        // Create admin profile in database
        await UserService.createUserProfile(
          userId: response.user!.id,
          email: email,
          fullName: fullName,
          phone: phone,
          role: 'admin',
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating admin user: $e');
      return false;
    }
  }

  /// Promote user to admin
  static Future<bool> promoteUserToAdmin(String userId) async {
    try {
      await _supabase
          .from('users')
          .update({
            'role': 'admin',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error promoting user to admin: $e');
      return false;
    }
  }

  /// Demote admin to user
  static Future<bool> demoteAdminToUser(String userId) async {
    try {
      await _supabase
          .from('users')
          .update({
            'role': 'user',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId);
      return true;
    } catch (e) {
      print('Error demoting admin to user: $e');
      return false;
    }
  }

  /// Get all users (admin only)
  static Future<List<UserModel>> getAllUsers() async {
    try {
      final isAdmin = await isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Access denied: Admin privileges required');
      }

      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return response.map<UserModel>((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  /// Get admin statistics
  static Future<Map<String, int>> getAdminStats() async {
    try {
      final isAdmin = await isCurrentUserAdmin();
      if (!isAdmin) {
        throw Exception('Access denied: Admin privileges required');
      }

      // Get counts from different tables
      final restaurantsCount = await _supabase
          .from('restaurants')
          .select('id')
          .count(CountOption.exact);
      
      final hotelsCount = await _supabase
          .from('hotels')
          .select('id')
          .count(CountOption.exact);
      
      final transportCount = await _supabase
          .from('transport_companies')
          .select('id')
          .count(CountOption.exact);
      
      final deliveryCount = await _supabase
          .from('delivery_companies')
          .select('id')
          .count(CountOption.exact);
      
      final travelCount = await _supabase
          .from('travel_agencies')
          .select('id')
          .count(CountOption.exact);
      
      final touristAreasCount = await _supabase
          .from('tourist_areas')
          .select('id')
          .count(CountOption.exact);
      
      final usersCount = await _supabase
          .from('users')
          .select('id')
          .count(CountOption.exact);

      return {
        'restaurants': restaurantsCount.count ?? 0,
        'hotels': hotelsCount.count ?? 0,
        'transport': transportCount.count ?? 0,
        'delivery': deliveryCount.count ?? 0,
        'travel': travelCount.count ?? 0,
        'tourist_areas': touristAreasCount.count ?? 0,
        'users': usersCount.count ?? 0,
      };
    } catch (e) {
      print('Error getting admin stats: $e');
      return {
        'restaurants': 0,
        'hotels': 0,
        'transport': 0,
        'delivery': 0,
        'travel': 0,
        'tourist_areas': 0,
        'users': 0,
      };
    }
  }
}