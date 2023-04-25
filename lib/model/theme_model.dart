import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  Brightness brightness = Brightness.light;

  void changeBrightness() {
    brightness =
        brightness == Brightness.light ? Brightness.dark : Brightness.light;

    notifyListeners();
  }
}
