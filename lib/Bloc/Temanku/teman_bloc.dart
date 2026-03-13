import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:langkara/repository/teman_repository.dart';
import 'package:langkara/models/teman_profile_model.dart';

part 'teman_event.dart';
part 'teman_state.dart';

class TemanBloc extends Bloc<TemanEvent, TemanState> {
  final TemanRepository repository;

  TemanBloc(this.repository) : super(TemanInitial()) {
    on<LoadTemanList>((event, emit) async {
      try {
        emit(TemanLoading());
        final temanList = await repository.getTemanList();
        emit(TemanLoaded(temanList));
      } catch (e) {
        emit(TemanError(e.toString()));
      }
    });
  }
}
