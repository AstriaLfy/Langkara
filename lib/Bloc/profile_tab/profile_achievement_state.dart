part of 'profile_achievement_bloc.dart';

abstract class ProfileAchievementState {}

/// state awal
class ProfileAchievementInitial extends  ProfileAchievementState {}

/// loading 
class ProfileAchievementLoading extends ProfileAchievementState {}

//sukses
class ProfileAchievementLoaded extends ProfileAchievementState {
  final List<Map<String, dynamic>> achievement;

  ProfileAchievementLoaded(this.achievement);
}
//gaada achievement
class ProfileAchievementEmpty extends ProfileAchievementState {}

/// error
class ProfileAchievementError extends ProfileAchievementState {
  final String message;

  ProfileAchievementError(this.message);
}