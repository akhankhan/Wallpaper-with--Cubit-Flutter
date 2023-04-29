import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallapaper/cubit/wallpaper_cubit.dart';
import 'package:wallapaper/extra/constants.dart';
import 'package:wallapaper/extra/location_enum.dart';
import 'package:wallapaper/extra/snackbar.dart';
import 'package:wallapaper/extra/wallpaper_model.dart';
import 'package:wallapaper/widgets/loading_indicator.dart';

class SetWallpaperScreen extends StatefulWidget {
  const SetWallpaperScreen({super.key, required this.wallpaperModel});
  final WallpaperModel wallpaperModel;

  @override
  State<SetWallpaperScreen> createState() => _SetWallpaperScreenState();
}

class _SetWallpaperScreenState extends State<SetWallpaperScreen> {
  File? wallpaperFile;
  @override
  void initState() {
    super.initState();
    context
        .read<WallpaperCubit>()
        .downloadWallpaper(widget.wallpaperModel.original)
        .then((file) {
      setState(() {
        wallpaperFile = file;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WallpaperCubit, WallpaperState>(
      listener: (context, state) {
        if (state is WallpaperSuccess) {
          Snackbar.show(
              context, "Wallpaper applied successfully", ContentType.success);
        } else if (state is WallpaperFailed) {
          Snackbar.show(context, "Failed Wallpaper", ContentType.failure);
        }
      },
      child: Scaffold(
        body: Center(
            child: Stack(
          fit: StackFit.expand,
          children: [
            wallpaperFile == null
                ? const Center(child: LoadingIndicator())
                : Image.file(
                    wallpaperFile!,
                    fit: BoxFit.cover,
                  ),
            if (wallpaperFile != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<WallpaperCubit>().setWallpaper(
                              wallpaperFile!.path, WallpaperLocation.home);
                        },
                        child: const Text('Home Screen'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<WallpaperCubit>().setWallpaper(
                              wallpaperFile!.path, WallpaperLocation.both);
                        },
                        child: const Text('Both'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<WallpaperCubit>().setWallpaper(
                              wallpaperFile!.path, WallpaperLocation.lock);
                        },
                        child: const Text('Lock Screen'),
                      )
                    ],
                  ),
                ),
              ),
            Positioned(
              top: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: white,
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: black,
                ),
              ),
            )
          ],
        )),
      ),
    );
  }
}
