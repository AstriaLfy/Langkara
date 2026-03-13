import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Services/profile_tab_services.dart';

part 'profile_Achievement_event.dart';
part 'profile_Achievement_state.dart';

class ProfileAchievementBloc
    extends Bloc<ProfileAchievementEvent, ProfileAchievementState> {

  final ProfileTabService profileTabService;

  ProfileAchievementBloc(this.profileTabService)
      : super(ProfileAchievementInitial()) {

    /// LOAD Achievement
    on<LoadProfileAchievement>((event, emit) async {
      emit(ProfileAchievementLoading());

      try {
        final data = await profileTabService.getUserAchievements();

        if (data.isEmpty) {
          emit(ProfileAchievementEmpty());
        } else {
          emit(ProfileAchievementLoaded(data));
        }
      } catch (e) {
        emit(ProfileAchievementError(e.toString()));
      }
    });

    /// REFRESH
    on<RefreshProfileAchievement>((event, emit) async {
      try {
        final data = await profileTabService.getUserAchievements();

        if (data.isEmpty) {
          emit(ProfileAchievementEmpty());
        } else {
          emit(ProfileAchievementLoaded(data));
        }
      } catch (e) {
        emit(ProfileAchievementError(e.toString()));
      }
    });
  }
}