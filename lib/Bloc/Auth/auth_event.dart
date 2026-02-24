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
  RegisterSubmited(this.email, this.password);
}

class Logout extends AuthEvent {}
class CekAuth extends AuthEvent{}