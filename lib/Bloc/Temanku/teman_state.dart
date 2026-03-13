part of 'teman_bloc.dart';

@immutable
sealed class TemanState {}

final class TemanInitial extends TemanState {}

class TemanLoading extends TemanState {}

class TemanLoaded extends TemanState {
  final List<TemanProfileModel> temanList;
  TemanLoaded(this.temanList);
}

class TemanError extends TemanState {
  final String message;
  TemanError(this.message);
}
