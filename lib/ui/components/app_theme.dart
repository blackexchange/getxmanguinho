import 'package:flutter/material.dart';

ThemeData makeAppTheme() {
  final primaryColor = Color.fromRGBO(34, 95, 100, 1);
  final primaryColorDark = Color.fromRGBO(33, 43, 64, 1);
  final primaryColorLight = Color.fromRGBO(33, 183, 160, 1);

  final textTheme = TextTheme(
      headline1: TextStyle(
          fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark));

  final inputDecorationTheme = InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColorLight)),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
      alignLabelWithHint: true);
  final buttonTheme = ButtonThemeData(
      colorScheme: ColorScheme.light(primary: primaryColor),
      buttonColor: primaryColor,
      splashColor: primaryColorLight,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));

  return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      accentColor: primaryColor,
      backgroundColor: Colors.white,
      textTheme: textTheme,
      inputDecorationTheme: inputDecorationTheme,
      buttonTheme: buttonTheme);
}
