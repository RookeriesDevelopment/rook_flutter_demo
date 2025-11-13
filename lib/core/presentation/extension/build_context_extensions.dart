import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  EdgeInsets get systemPadding {
    return MediaQuery.of(this).padding;
  }

  ColorScheme get colorScheme {
    return Theme.of(this).colorScheme;
  }

  TextTheme get typography {
    return Theme.of(this).textTheme;
  }

  bool get isPortrait {
    return MediaQuery.of(this).orientation == Orientation.portrait;
  }

  Size get screenSize {
    return MediaQuery.of(this).size;
  }

  void showSnackBar(SnackBar snackBar) {
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  void showTextSnackBar(String text) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(text)));
  }
}
