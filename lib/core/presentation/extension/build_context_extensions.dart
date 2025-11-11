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
}
