part of 'achievement_bloc.dart';

@immutable
sealed class AchievementEvent {}

class UploadAchievementRequested extends AchievementEvent {
  final String title;
  final String description;
  final String category;
  final String imagePath;
  final String achievedAt;

  UploadAchievementRequested({
    required this.title,
    required this.description,
    required this.category,
    required this.imagePath,
    required this.achievedAt,
  });
}
