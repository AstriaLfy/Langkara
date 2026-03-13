import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:langkara/services/achievement_service.dart';

part 'achievement_event.dart';
part 'achievement_state.dart';

class AchievementBloc extends Bloc<AchievementEvent, AchievementState> {
  final AchievementService service;

  AchievementBloc(this.service) : super(AchievementInitial()) {
    on<UploadAchievementRequested>((event, emit) async {
      try {
        emit(AchievementUploading());
        await service.uploadAchievement(
          title: event.title,
          description: event.description,
          category: event.category,
          imagePath: event.imagePath,
          achievedAt: event.achievedAt,
        );
        emit(AchievementUploadSuccess());
      } catch (e) {
        emit(AchievementError("Upload gagal: ${e.toString()}"));
      }
    });
  }
}
