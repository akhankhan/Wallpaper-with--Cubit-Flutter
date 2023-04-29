import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wallapaper/cubit/wallpaper_cubit.dart';
import 'package:wallapaper/extra/constants.dart';
import 'package:wallapaper/extra/wallpaper_model.dart';
import 'package:wallapaper/widgets/image_card.dart';
import 'package:wallapaper/widgets/loading_indicator.dart';
import 'package:wallapaper/widgets/not_found.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamWhite,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: black,
      ),
      body: Column(
        children: [
          const Text(
            'Wall Print',
            style: TextStyle(
              fontSize: 40,
              fontFamily: handlee,
            ),
          ),
          Neumorphic(
            child: TextField(
              controller: _controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                border: InputBorder.none,
                hintText: 'Search Wallpaper',
                hintStyle: const TextStyle(
                  color: grey,
                ),
                suffixIcon: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<WallpaperCubit>()
                          .getWallpaper(_controller.text);
                      _controller.clear();
                    },
                    child: const Icon(Icons.search)),
              ),
              onSubmitted: ((value) {
                FocusScope.of(context).unfocus();
                context.read<WallpaperCubit>().getWallpaper(_controller.text);
                _controller.clear();
              }),
            ),
          ),
          Expanded(
            child: BlocConsumer<WallpaperCubit, WallpaperState>(
                builder: (_, state) {
                  if (state is WallpaperLoading) {
                    return const LoadingIndicator();
                  } else if (state is WallpaperError) {
                    return const NotFoundIllustration();
                  }
                  List<WallpaperModel> wallpapers = [];
                  if (state is WallpaperLoaded) {
                    wallpapers = state.wallpapers;
                  } else {
                    wallpapers = context.read<WallpaperCubit>().wallpaper;
                  }
                  log('LENGTH: ${wallpapers.length}');
                  return MasonryGridView.count(
                      itemCount: wallpapers.length,
                      crossAxisCount: 2,
                      // mainAxisSpacing: 2,
                      // crossAxisSpacing: 2,
                      itemBuilder: (_, index) {
                        return ImageCard(
                          wallpaper: wallpapers[index],
                        );
                      });
                },
                listener: (_, state) {}),
          ),
        ],
      ),
    );
  }
}
