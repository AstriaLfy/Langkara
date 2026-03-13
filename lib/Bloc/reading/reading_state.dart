part of 'reading_bloc.dart';

abstract class ReadingState {}

class ReadingInitial extends ReadingState {}

class ReadingLoading extends ReadingState {}

class ReadingEmpty extends ReadingState {}

class ReadingLoaded extends ReadingState {
  final List materiList;

  ReadingLoaded(this.materiList);
}

class ReadingError extends ReadingState {
  final String message;

  ReadingError(this.message);
}