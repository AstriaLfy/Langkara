import 'package:langkara/Services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  Future<void> login(String email, String password) {
    return authService.login(email: email, password: password);
  }

  Future<AuthResponse> register(
  String email,
  String password,
  String username,
  String? avatarUrl,
) {
  return authService.register(
    email: email,
    password: password,
    username: username,
    avatarUrl: avatarUrl,
  );
}

  Future<void> signInWithGoogle() async{
    await authService.signInWithGoogle();
  }

  Future<void> logout() {
    return authService.logout();
  }
}