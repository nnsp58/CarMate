import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthService {
  static User? get currentUser => SupabaseService.currentUser;

  /// Sign up with email and password
  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    try {
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
        data: fullName != null ? {'full_name': fullName} : null,
      );

      // Create user profile in users table
      // Using upsert to handle cases where auth succeeded previously
      // but users table insert failed (e.g., due to RLS issues)
      if (response.user != null) {
        await SupabaseService.client.from('users').upsert({
          'id': response.user!.id,
          'email': email,
          'full_name': fullName,
          'phone': phone,
        });
      }

      return response;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in with email and password
  static Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Send OTP to phone number
  static Future<void> sendOTP({
    required String phone,
  }) async {
    try {
      await SupabaseService.client.auth.signInWithOtp(
        phone: phone,
      );
    } catch (e) {
      throw Exception('Failed to send OTP: $e');
    }
  }

  /// Verify OTP (Supabase Original)
  static Future<AuthResponse> verifyOTP({
    required String phone,
    required String token,
  }) async {
    try {
      final response = await SupabaseService.client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );

      // Create user profile in users table if it doesn't exist
      if (response.user != null) {
        final existingUser = await SupabaseService.client
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (existingUser == null) {
          await SupabaseService.client.from('users').insert({
            'id': response.user!.id,
            'phone': phone,
          });
        }
      }

      return response;
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  // --- Firebase Phone Auth Integration ---
  static String? _verificationId;

  /// Send OTP to phone number using Firebase
  static Future<void> sendOTPFirebase({
    required String phone,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await fb.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (fb.PhoneAuthCredential credential) async {
          // Auto-resolution handling can be added here
        },
        verificationFailed: (fb.FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      throw Exception('Failed to send OTP via Firebase: $e');
    }
  }

  /// Verify OTP using Firebase and authenticate with Supabase
  static Future<AuthResponse> verifyOTPFirebase({
    required String phone,
    required String token,
  }) async {
    if (_verificationId == null) throw Exception('Please request OTP first');
    try {
      // 1. Verify OTP with Firebase
      final credential = fb.PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: token,
      );
      await fb.FirebaseAuth.instance.signInWithCredential(credential);

      // 2. Link/Login to Supabase using generated credentials
      final cleanPhone = phone.replaceAll('+', '');
      final fakeEmail = '$cleanPhone@rideon-auth.com';
      final fakePassword = 'RideOnAuth\$$cleanPhone';

      try {
        // Try sign in
        final response = await SupabaseService.client.auth.signInWithPassword(
          email: fakeEmail,
          password: fakePassword,
        );
        return response;
      } on AuthException catch (_) {
        // If sign in fails, try sign up
        final response = await SupabaseService.client.auth.signUp(
          email: fakeEmail,
          password: fakePassword,
        );

        if (response.user != null) {
          // Check if user exists in DB first
          final existingUser = await SupabaseService.client
              .from('users')
              .select()
              .eq('id', response.user!.id)
              .maybeSingle();

          if (existingUser == null) {
            await SupabaseService.client.from('users').insert({
              'id': response.user!.id,
              'phone': phone,
            });
          }
        }
        return response;
      }
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  /// Reset password
  static Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await SupabaseService.client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Listen to auth state changes
  static Stream<AuthState> onAuthStateChange() {
    return SupabaseService.client.auth.onAuthStateChange;
  }

  /// Get current user profile
  static Future<UserModel?> getCurrentUserProfile() async {
    return await getUserProfile(currentUser?.id ?? '');
  }

  /// Get user profile by ID
  static Future<UserModel?> getUserProfile(String userId) async {
    try {
      if (userId.isEmpty) return null;

      final response = await SupabaseService.client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response != null ? UserModel.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  static Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await SupabaseService.client
          .from('users')
          .update(data)
          .eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}
