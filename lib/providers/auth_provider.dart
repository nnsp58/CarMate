import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
// Auth State Provider - listens to Supabase auth changes
final authStateProvider = StreamProvider<AuthState>((ref) {
  return AuthService.onAuthStateChange();
});

// Specific User Profile Provider
final userProfileProvider = FutureProvider.family<UserModel?, String>((ref, userId) async {
  return await AuthService.getUserProfile(userId);
});

// Current User Profile Provider
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (authState) async {
      if (authState.session != null) {
        return await AuthService.getCurrentUserProfile();
      }
      return null;
    },
    orElse: () => null,
  );
});

// Auth Actions Provider - handles auth operations
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref);
});

class AuthActions {
  AuthActions(Ref ref);

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    await AuthService.signUpWithEmail(
      email: email,
      password: password,
      fullName: fullName,
      phone: phone,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await AuthService.signInWithEmail(
      email: email,
      password: password,
    );
  }

  Future<void> signInWithOTP({
    required String phone,
  }) async {
    await AuthService.sendOTP(phone: phone);
  }

  Future<void> verifyOTP({
    required String phone,
    required String token,
  }) async {
    await AuthService.verifyOTP(phone: phone, token: token);
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await AuthService.resetPassword(email: email);
  }

  Future<void> signOut() async {
    await AuthService.signOut();
  }

  Future<void> updateProfile({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await AuthService.updateProfile(userId: userId, data: data);
  }

  // Get current user directly from Database bypassing cache if needed
  Future<UserModel?> getCurrentUserDirectly() async {
    return await AuthService.getCurrentUserProfile();
  }
}
