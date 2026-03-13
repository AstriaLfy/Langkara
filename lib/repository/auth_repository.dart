import 'package:langkara/services/auth_services.dart';

class AuthRepository {
  final AuthService authService;

  AuthRepository(this.authService);

  Future<void> login(String email, String password) {
    return authService.login(email: email, password: password);
  }

  Future<void> register(String email, String password, String username) {
    return authService.register(email: email, password: password, username: username);
  }

  Future<void> signInWithGoogle() async{
    await authService.signInWithGoogle();
  }

  Future<void> logout() {
    return authService.logout();
  }
}