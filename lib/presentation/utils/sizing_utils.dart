import 'package:flutter/material.dart';

class SizingUtils {
  static const kDesktopMinWidth = 1100.0;

  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= kDesktopMinWidth;
  }
}
