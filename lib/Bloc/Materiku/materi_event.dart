part of 'materi_bloc.dart';

@immutable
sealed class MateriEvent {}
class LoadMateriFeed extends MateriEvent {}

class UploadMateriRequested extends MateriEvent {
  final String judul;
  final String deskripsi;
  final String kategori;
  final List<String> imagePaths;

  UploadMateriRequested({
    required this.judul,
    required this.deskripsi,
    required this.kategori,
    required this.imagePaths,
  });
}

class DeleteMateriRequested extends MateriEvent{}

class LoadMateriDetail extends MateriEvent {
  final String id;
  LoadMateriDetail(this.id);
}