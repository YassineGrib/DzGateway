import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'user_service.dart';

class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  // Get current user
  static User? get currentUser => _supabase.auth.currentUser;

  // Check if user is signed in
  static bool get isSignedIn => currentUser != null;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: fullName != null ? {'full_name': fullName} : null,
    );
    
    // Create user profile in database if signup successful
    if (response.user != null) {
      await UserService.createUserProfile(
        userId: response.user!.id,
        email: email,
        fullName: fullName,
      );
    }
    
    return response;
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign out
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Get user profile data
  static Map<String, dynamic>? get userMetadata => currentUser?.userMetadata;

  // Update user profile
  static Future<UserResponse> updateProfile({
    String? fullName,
    Map<String, dynamic>? data,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['full_name'] = fullName;
    if (data != null) updates.addAll(data);

    return await _supabase.auth.updateUser(
      UserAttributes(data: updates),
    );
  }
}