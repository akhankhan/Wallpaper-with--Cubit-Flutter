import 'dart:convert';
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallapaper/extra/constants.dart';
import 'package:wallapaper/extra/location_enum.dart';
import 'package:wallapaper/extra/wallpaper_model.dart';

part 'wallpaper_state.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  WallpaperCubit() : super(WallpaperLoading());
  List<WallpaperModel> wallpaper = [];
  String _lastQuery = 'abstract art';

  Future<void> getWallpaper([String? query]) async {
    query == null || query.isEmpty ? query = _lastQuery : _lastQuery = query;

    try {
      emit(WallpaperLoading());

      wallpaper = await _getWallpaper(query);

      emit(WallpaperLoaded(wallpapers: wallpaper));
    } catch (e) {
      emit(WallpaperError(message: e.toString()));
    }
  }

  Future<List<WallpaperModel>> _getWallpaper(String query) async {
    query = query.replaceAll(' ', '+');
    try {
      final Response response = await get(
          Uri.parse(
              'https://api.pexels.com/v1/search?query=$query&per_page=80'),
          headers: {
            'Authorization': key,
          });

      if (response.statusCode == 200) {
        final List<WallpaperModel> wallpaper = [];
        final Map<String, dynamic> data = jsonDecode(response.body);
        data['photos'].forEach((photo) {
          wallpaper.add(WallpaperModel.fromJson(photo['src']));
        });
        return wallpaper;
      } else {
        throw Exception();
      }
    } catch (_) {
      throw Exception();
    }
  }

  Future<File?> downloadWallpaper(String url) async {
    try {
      final dir = await getTemporaryDirectory();
      var response = await get(Uri.parse(url));
      var filePath = '${dir.path}/${DateTime.now().toIso8601String()}.jpg';
      final file = File(filePath);
      file.writeAsBytesSync(response.bodyBytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  Future<void> setWallpaper(String path, WallpaperLocation location) async {
    try {
      if (location == WallpaperLocation.both) {
        await _setWallpaper(path, WallpaperLocation.both);
        await _setWallpaper(path, WallpaperLocation.lock);
      } else {
        await _setWallpaper(path, location);
      }
      emit(WallpaperSuccess());
    } catch (_) {
      emit(WallpaperFailed());
    }
  }

  Future<void> _setWallpaper(String path, WallpaperLocation location) async {
    await AsyncWallpaper.setWallpaperFromFile(
      filePath: path,
      wallpaperLocation: location.value,
      goToHome: false,
    );
  }
}
