import 'package:flutter/material.dart';

void showErrorMessage(BuildContext context, String error) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
      SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(error, textAlign: TextAlign.center)
      )
  );
}