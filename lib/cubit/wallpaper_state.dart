part of 'wallpaper_cubit.dart';

abstract class WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  List<WallpaperModel> wallpapers;
  WallpaperLoaded({required this.wallpapers});
}

class WallpaperError extends WallpaperState {
  String message;
  WallpaperError({required this.message});
}

class WallpaperSuccess extends WallpaperState {}

class WallpaperFailed extends WallpaperState {}
