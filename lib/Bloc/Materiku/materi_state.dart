part of 'materi_bloc.dart';

@immutable
sealed class MateriState {}

final class MateriInitial extends MateriState {}
class MateriLoading extends MateriState {}

class MateriLoaded extends MateriState {
  final List<MateriFeedModel> materi;

  MateriLoaded(this.materi);
}

class MateriError extends MateriState {
  final String message;

  MateriError(this.message);
}

class MateriUploading extends MateriState {}
class MateriUploadSuccess extends MateriState {}