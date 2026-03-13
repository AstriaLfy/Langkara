import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:langkara/Services/profile_tab_services.dart';

part 'profile_materi_event.dart';
part 'profile_materi_state.dart';

class ProfileMateriBloc
    extends Bloc<ProfileMateriEvent, ProfileMateriState> {

  final ProfileTabService profileTabService;

  ProfileMateriBloc(this.profileTabService)
      : super(ProfileMateriInitial()) {

    /// LOAD MATERI
    on<LoadProfileMateri>((event, emit) async {
      emit(ProfileMateriLoading());

      try {
        final data = await profileTabService.getUserMateri();

        if (data.isEmpty) {
          emit(ProfileMateriEmpty());
        } else {
          emit(ProfileMateriLoaded(data));
        }
      } catch (e) {
        emit(ProfileMateriError(e.toString()));
      }
    });

    /// REFRESH
    on<RefreshProfileMateri>((event, emit) async {
      try {
        final data = await profileTabService.getUserMateri();

        if (data.isEmpty) {
          emit(ProfileMateriEmpty());
        } else {
          emit(ProfileMateriLoaded(data));
        }
      } catch (e) {
        emit(ProfileMateriError(e.toString()));
      }
    });
  }
}