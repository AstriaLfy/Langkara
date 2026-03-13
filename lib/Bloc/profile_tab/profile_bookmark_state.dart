part of 'profile_bookmark_bloc.dart';

abstract class ProfileBookmarkState {}

/// state awal
class ProfileBookmarkInitial extends  ProfileBookmarkState {}

/// loading 
class ProfileBookmarkLoading extends ProfileBookmarkState {}

//sukses
class ProfileBookmarkLoaded extends ProfileBookmarkState {
  final List<Map<String, dynamic>> bookmark;

  ProfileBookmarkLoaded(this.bookmark);
}
//gaada Bookmark
class ProfileBookmarkEmpty extends ProfileBookmarkState {}

/// error
class ProfileBookmarkError extends ProfileBookmarkState {
  final String message;

  ProfileBookmarkError(this.message);
}