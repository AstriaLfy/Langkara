part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class LoginSubmited extends AuthEvent {
  final String email;
  final String password;
  LoginSubmited(this.email, this.password);
}

class RegisterSubmited extends AuthEvent {
  final String email;
  final String password;
  final String nama;
  RegisterSubmited(this.email, this.password, this.nama);
}

class GoogleSignInRequest extends AuthEvent{}

class Logout extends AuthEvent {}
class CekAuth extends AuthEvent{}