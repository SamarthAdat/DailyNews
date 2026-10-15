import 'package:flutter/material.dart';

extension SnackBarContext on BuildContext {
  void showMessage(String message, {SnackBarAction? action}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), action: action));
  }
}
