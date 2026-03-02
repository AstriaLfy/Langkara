import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'materi_event.dart';
part 'materi_state.dart';

class MateriBloc extends Bloc<MateriEvent, MateriState> {
  MateriBloc() : super(MateriInitial()) {
    on<MateriEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
