import 'package:flutter/material.dart';

void showSuccessMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showErrorMessage(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
