import 'package:bloc/bloc.dart';
import 'package:langkara/Services/reading_service.dart';

part 'reading_event.dart';
part 'reading_state.dart';

class ReadingBloc extends Bloc<ReadingEvent, ReadingState> {
  final ReadingService readingService;

  ReadingBloc(this.readingService) : super(ReadingInitial()) {

    on<LoadLastRead>((event, emit) async {
  emit(ReadingLoading());

  try {
    final data = await readingService.getLastRead();

    print("BLOC DATA: $data");

    if (data.isEmpty) {
      emit(ReadingEmpty());
      return;
    }

    final materiList = data.map((item) => item['materi']).toList();

    print("MATERI LIST: $materiList");

    emit(ReadingLoaded(materiList));
  } catch (e) {
    print("READING ERROR: $e");
    emit(ReadingError(e.toString()));
  }
});
  }
}