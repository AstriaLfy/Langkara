part of 'profile_bookmark_bloc.dart';

abstract class ProfileBookmarkEvent {}


class LoadProfileBookmark extends ProfileBookmarkEvent {}


class RefreshProfileBookmark extends ProfileBookmarkEvent {}