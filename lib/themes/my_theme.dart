import 'package:flutter/material.dart';
import 'package:hrms/themes/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData lightTheme() => ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
          .copyWith(
              secondary: kPrimaryColor,
              background: Colors.white,
              shadow: const Color(0xff000000).withOpacity(0.25)),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            textStyle: const TextStyle(
              fontSize: 16,
            )),
      ),
      textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
          )));

  static ThemeData darkTheme() => ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black.withOpacity(0.9),
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
      ).copyWith(
          secondary: kPrimaryColor,
          background: const Color(0xff242424),
          shadow: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            disabledForegroundColor: Colors.white60,
            backgroundColor: kPrimaryColor,
            textStyle: const TextStyle(
              fontSize: 16,
            )),
      ),
      textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
          )));
}
