import 'package:supabase_flutter/supabase_flutter.dart';

/// Utility class to create admin user in Supabase Auth
/// This should be run once to create the admin authentication user
class CreateAdminAuth {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Create admin user in Supabase Auth
  /// This will create the authentication user that corresponds to the admin user in the database
  static Future<bool> createAdminAuthUser() async {
    try {
      // Create the admin user in Supabase Auth
      final response = await _supabase.auth.signUp(
        email: 'admin@dzgateway.com',
        password: 'DzGateway2024!Admin#Secure',
        data: {
          'full_name': 'System Administrator',
        },
      );

      if (response.user != null) {
        print('Admin auth user created successfully');
        print('User ID: ${response.user!.id}');
        
        // Update the existing admin user record in the database with the correct auth ID
        await _supabase
            .from('users')
            .update({
              'id': response.user!.id,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('email', 'admin@dzgateway.com');
        
        print('Admin user record updated with auth ID');
        return true;
      } else {
        print('Failed to create admin auth user');
        return false;
      }
    } catch (e) {
      print('Error creating admin auth user: $e');
      return false;
    }
  }

  /// Alternative method: Update existing database record with new auth user ID
  static Future<bool> linkExistingAdminToAuth() async {
    try {
      // First, delete the old admin record (if exists)
      print('Deleting existing admin record...');
      await _supabase
          .from('users')
          .delete()
          .eq('email', 'admin@dzgateway.com');
      
      print('Creating auth user...');
      // Create the auth user
      final response = await _supabase.auth.signUp(
        email: 'admin@dzgateway.com',
        password: 'DzGateway2024!Admin#Secure',
        data: {
          'full_name': 'System Administrator',
        },
      );

      if (response.user != null) {
        print('Auth user created with ID: ${response.user!.id}');
        
        // Create new admin record with correct auth ID
        print('Creating admin database record...');
        await _supabase.from('users').insert({
          'id': response.user!.id,
          'email': 'admin@dzgateway.com',
          'full_name': 'System Administrator',
          'phone': '+213555000000',
          'role': 'admin',
          'is_active': true,
        });
        
        print('Admin user linked successfully');
        print('Auth User ID: ${response.user!.id}');
        return true;
      } else {
        print('Failed to create auth user');
        return false;
      }
    } catch (e) {
      print('Error linking admin to auth: $e');
      return false;
    }
  }
}