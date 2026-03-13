import 'package:bloc/bloc.dart';
import 'package:langkara/repository/materi_repository.dart';
import 'package:langkara/models/materi_model.dart';
import 'package:meta/meta.dart';

part 'materi_event.dart';
part 'materi_state.dart';

class MateriBloc extends Bloc<MateriEvent, MateriState> {
  final MateriRepository repository;
  MateriBloc(this.repository) : super(MateriInitial()) {

    on<LoadMateriFeed>((event, emit) async {
      try {
        emit(MateriLoading());
        final materiList = await repository.getMateriFeed();
        emit(MateriLoaded(materiList));
      } catch (e) {
        emit(MateriError(e.toString()));
      }
    });

    on<UploadMateriRequested>((event, emit) async {
      try {
        print("TEST UPLOAD");
      emit(MateriUploading());

       await repository.uploadMateri(
          judul: event.judul,
          deskripsi: event.deskripsi,
          kategori: event.kategori,
          imagePaths: event.imagePaths,
        );
        emit(MateriUploadSuccess());
        add(LoadMateriFeed());
      } catch (e) {
        emit(MateriError("Upload gagal: ${e.toString()}"));
      }
    });

    on<LoadMateriDetail>((event, emit) async {
      try {
        emit(MateriLoading());
        final materi = await repository.getMateriById(event.id);
        emit(MateriDetailLoaded(materi));
      } catch (e) {
        emit(MateriError(e.toString()));
      }
    });
  }

  }
