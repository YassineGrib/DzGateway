import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'utils/create_admin_auth.dart';

/// Standalone script to create admin user in Supabase Auth
/// Run this once to set up the admin authentication user
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await AuthService.initialize();
  
  print('Setting up admin user...');
  
  // Create admin auth user and link to database
  final success = await CreateAdminAuth.linkExistingAdminToAuth();
  
  if (success) {
    print('✅ Admin user setup completed successfully!');
    print('You can now login with:');
    print('Email: admin@dzgateway.com');
    print('Password: DzGateway2024!Admin#Secure');
    print('\n⚠️  Please change the password after first login!');
  } else {
    print('❌ Failed to setup admin user');
    print('Please check the console for error details.');
  }
}