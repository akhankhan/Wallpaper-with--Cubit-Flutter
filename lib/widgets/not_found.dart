import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallapaper/extra/constants.dart';

import '../cubit/wallpaper_cubit.dart';

class NotFoundIllustration extends StatelessWidget {
  const NotFoundIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 300,
          child: Image.asset(
            notFoundIllustration,
            fit: BoxFit.cover,
          ),
        ),
        ElevatedButton(
          onPressed: () => context.read<WallpaperCubit>().getWallpaper(),
          child: const Text('Retry'),
        )
      ],
    );
  }
}
