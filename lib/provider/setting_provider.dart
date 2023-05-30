import 'package:flutter/material.dart';
import 'package:the_voice/controller/file_controller.dart';

enum Language { english, korean }

class SettingProvider extends ChangeNotifier {
  late bool largeFont;
  late Brightness brightness;
  late Language language;

  void init() {
    List<String> fileList = FileController.fileReadAsStringSync().split(' ');

    largeFont = fileList[0] == 'false' ? false : true;
    brightness = fileList[1] == 'light' ? Brightness.light : Brightness.dark;
    language = fileList[2] == 'english' ? Language.english : Language.korean;
  }

  void changeLargeFont() {
    largeFont = !largeFont;
    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[0] = largeFont.toString();
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }

  void changeBrightness() {
    brightness == Brightness.light
        ? brightness = Brightness.dark
        : brightness = Brightness.light;
    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[1] = brightness == Brightness.light ? 'light' : 'dark';
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }

  void changeLanguage() {
    language == Language.english
        ? language = Language.korean
        : language = Language.english;
    notifyListeners();

    List<String> fileList = FileController.fileReadAsStringSync().split(' ');
    fileList[2] = language == Language.english ? 'english' : 'korean';
    FileController.fileWriteAsStringSync(fileList.join(' '));
  }
}
