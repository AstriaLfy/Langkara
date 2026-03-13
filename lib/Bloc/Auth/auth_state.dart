part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginSuccess extends AuthState{}
final class LoginFailure extends AuthState {
  final String message;
  LoginFailure(this.message);
}

final class RegisterSuccess extends AuthState{}
final class RegisterFailure extends AuthState{
  final String messege;
  RegisterFailure(this.messege);
}

final class Unauthenticated extends AuthState{}
class Authenticated extends AuthState {
  final String username;
  final String gmail;
  final String? avatarUrl;
  final String? jurusan;
  final String? universitas;

  Authenticated(
    this.username,
    this.gmail,
    this.avatarUrl, {
    this.jurusan,
    this.universitas,
  });
}