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
  final String? avatarurl;

  RegisterSubmited(
    this.email,
    this.password,
    this.nama,
    this.avatarurl,
  );
}

class UpdateAvatarEvent extends AuthEvent {
  final String avatarUrl;

  UpdateAvatarEvent(this.avatarUrl);
}

  class GoogleSignInRequest extends AuthEvent{}
  class UpdateProfile extends AuthEvent {
  final String nama;
  final String username;
  final String email;
  final String jurusan;
  final String universitas;
  final String gender;
  final String kemampuan;

  UpdateProfile({
    required this.nama,
    required this.username,
    required this.email,
    required this.jurusan,
    required this.universitas,
    required this.gender,
    required this.kemampuan,
  });
}

  class Logout extends AuthEvent {}
  class CekAuth extends AuthEvent{}
