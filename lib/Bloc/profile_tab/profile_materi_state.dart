part of 'profile_materi_bloc.dart';

abstract class ProfileMateriState {}

/// state awal
class ProfileMateriInitial extends ProfileMateriState {}

/// loading 
class ProfileMateriLoading extends ProfileMateriState {}

//sukses
class ProfileMateriLoaded extends ProfileMateriState {
  final List<Map<String, dynamic>> materi;

  ProfileMateriLoaded(this.materi);
}
//gaada materi
class ProfileMateriEmpty extends ProfileMateriState {}

/// error
class ProfileMateriError extends ProfileMateriState {
  final String message;

  ProfileMateriError(this.message);
}