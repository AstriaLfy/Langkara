import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Services/profile_tab_services.dart';

part 'profile_Bookmark_event.dart';
part 'profile_Bookmark_state.dart';

class ProfileBookmarkBloc
    extends Bloc<ProfileBookmarkEvent, ProfileBookmarkState> {

  final ProfileTabService profileTabService;

  ProfileBookmarkBloc(this.profileTabService)
      : super(ProfileBookmarkInitial()) {

    /// LOAD Bookmark
    on<LoadProfileBookmark>((event, emit) async {
      emit(ProfileBookmarkLoading());

      try {
        final data = await profileTabService.getUserBookmarks();

        if (data.isEmpty) {
          emit(ProfileBookmarkEmpty());
        } else {
          emit(ProfileBookmarkLoaded(data));
        }
      } catch (e) {
        emit(ProfileBookmarkError(e.toString()));
      }
    });

    /// REFRESH
    on<RefreshProfileBookmark>((event, emit) async {
      try {
        final data = await profileTabService.getUserBookmarks();

        if (data.isEmpty) {
          emit(ProfileBookmarkEmpty());
        } else {
          emit(ProfileBookmarkLoaded(data));
        }
      } catch (e) {
        emit(ProfileBookmarkError(e.toString()));
      }
    });
  }
}