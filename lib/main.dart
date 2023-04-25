import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keywordly_app/firebase_options.dart';
import 'package:keywordly_app/model/theme_model.dart';
import 'package:keywordly_app/view/home_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Keywordly());
}

class Keywordly extends StatelessWidget {
  const Keywordly({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      builder: (context, child) => Consumer<ThemeModel>(
        builder: (context, value, child) => MaterialApp(
          home: HomeView(),
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.indigo,
            brightness: value.brightness,
            appBarTheme: AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: value.brightness == Brightness.light
                    ? Brightness.dark
                    : Brightness.light,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
