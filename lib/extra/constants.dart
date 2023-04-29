import 'package:flutter/material.dart';

// key
const key = 'enter api key';

// assets
const String handlee = 'Handlee-Regular';
const String notFoundIllustration = 'assets/nointernet1.gif';

// colors
// const Color creamWhite = Color.fromARGB(255, 236, 236, 236);
const Color creamWhite = Color(0XFFe6e6e6);
const Color white = Colors.white;
const Color black = Colors.black;
const Color grey = Colors.grey;

// theme
final theme = ThemeData.light().copyWith(
  primaryColor: black,
  colorScheme: const ColorScheme.light().copyWith(
    primary: black,
    secondary: black,
  ),
);
