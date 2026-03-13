part of 'achievement_bloc.dart';

@immutable
sealed class AchievementState {}

final class AchievementInitial extends AchievementState {}

class AchievementUploading extends AchievementState {}

class AchievementUploadSuccess extends AchievementState {}

class AchievementError extends AchievementState {
  final String message;
  AchievementError(this.message);
}
