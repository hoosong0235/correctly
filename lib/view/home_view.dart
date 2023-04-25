import 'package:flutter/material.dart';
import 'package:keywordly_app/controller/cloud_functions_controller.dart';
import 'package:keywordly_app/model/theme_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CloudFunctionsController cloudFunctionsController =
      CloudFunctionsController();

  String input = '';
  int words = 0;
  int characters = 0;
  dynamic output = '';

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Consumer<ThemeModel>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Color.lerp(
          colorScheme.primary,
          colorScheme.background,
          0.99,
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Keywordly'),
          actions: [
            IconButton(
              onPressed: () => value.changeBrightness(),
              icon: Icon(
                value.brightness == Brightness.light
                    ? Icons.wb_sunny_outlined
                    : Icons.wb_sunny_rounded,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 32),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Center(
                        child: Text(output),
                      ),
                    ),
                  ),
                  SizedBox(width: 32),
                ],
              ),
            ),
            SizedBox(height: 32),
            Row(
              children: [
                SizedBox(width: 32),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(
                      () {
                        input = value;
                        words = input
                            .split(' ')
                            .where((element) => element.isNotEmpty)
                            .length;
                        characters = input.replaceAll(' ', '').length;
                      },
                    ),
                    decoration: InputDecoration(
                      hintText: 'Input Keyword',
                      counterText: '$words words $characters characters',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          output =
                              await cloudFunctionsController.getResponse(input);
                          setState(() {});
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 32),
              ],
            ),
            SizedBox(height: 32),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 1,
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(Icons.analytics),
              icon: Icon(Icons.analytics_outlined),
              label: 'Analysis',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
