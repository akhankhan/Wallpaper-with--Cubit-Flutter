import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallapaper/cubit/wallpaper_cubit.dart';
import 'package:wallapaper/extra/constants.dart';
import 'package:wallapaper/screens/wallpaper_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WallpaperCubit()..getWallpaper(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wall Print',
        theme: theme,
        home: const WallpaperScreen(),
      ),
    );
  }
}
