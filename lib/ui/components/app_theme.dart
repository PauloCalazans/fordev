import 'package:flutter/material.dart';

ThemeData makeAppTheme () {
  final primaryColor = Color.fromRGBO(136, 14, 79, 1);
  final primaryColorDark = Color.fromRGBO(96, 0, 39, 1);
  final primaryColorLight = Color.fromRGBO(188, 71, 123, 1);
  final secondaryColorDark = Color.fromRGBO(0, 37, 26, 1);
  final secondaryColor = Color.fromRGBO(0, 77, 64, 1);
  final disabledColor = Colors.grey[400];
  final dividerColor = Colors.grey;

  return ThemeData(
      primaryColor: primaryColor,
      primaryColorDark: primaryColorDark,
      primaryColorLight: primaryColorLight,
      secondaryHeaderColor: secondaryColorDark,
      highlightColor: secondaryColor,
      disabledColor: disabledColor,
      dividerColor: dividerColor,
      accentColor: primaryColor,
      backgroundColor: Colors.white,
      textTheme: TextTheme(
          headline1: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryColorDark
          )
      ),
      inputDecorationTheme: InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColorLight)
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryColor)
          ),
          alignLabelWithHint: true
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: primaryColor,
            onPrimary: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
          )
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: primaryColor,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
          )
      ),
      buttonTheme: ButtonThemeData(
          colorScheme: ColorScheme.light(primary: primaryColor),
          buttonColor: primaryColor,
          splashColor: primaryColorLight,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          )
      ),
      iconTheme: IconThemeData(
          color: primaryColorLight
      ),
      primaryIconTheme: IconThemeData(
          color: primaryColorLight
      )
  );
}