import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:the_voice/controller/cloud_functions_controller.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/util/constant.dart';

class SearchView extends StatefulWidget {
  final String text;

  const SearchView({super.key, required this.text});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SettingProvider sm = context.watch<SettingProvider>();
    bool largeFont = sm.largeFont;
    bool brightness = sm.brightness == Brightness.light;
    bool lang = sm.language == Language.english;

    String title = '';
    String request = widget.text;
    dynamic response;

    SystemUiOverlayStyle getSystemUiOverlayStyle() {
      if (brightness) {
        return SystemUiOverlayStyle.light;
      } else {
        return SystemUiOverlayStyle.dark;
      }
    }

    Widget getTitle(bool isCorrect) {
      TextStyle? onTertiary = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onTertiary)
          : tt.displaySmall?.copyWith(color: cs.onTertiary);

      TextStyle? onPrimary = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onPrimary)
          : tt.displaySmall?.copyWith(color: cs.onPrimary);

      if (isCorrect) {
        return Text(lang ? 'Correct' : '올발라요', style: onPrimary);
      } else {
        return Text(lang ? 'Incorrect' : '올바르지 않아요', style: onTertiary);
      }
    }

    Widget getBody(bool isCorrect) {
      TextStyle? onTertiary = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onTertiary)
          : tt.titleLarge?.copyWith(color: cs.onTertiary);

      TextStyle? onPrimary = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onPrimary)
          : tt.titleLarge?.copyWith(color: cs.onPrimary);

      if (isCorrect) {
        return Text(
          lang
              ? 'AI Generated\nPossible Sentence Variants!'
              : 'AI가 가능한 문장의\n경우의 수를 생성했어요!',
          style: onPrimary,
        );
      } else {
        return Text(
          lang
              ? 'AI Generated\nPossible Sentence Variants!'
              : 'AI가 가능한 문장의\n경우의 수를 생성했어요!',
          style: onTertiary,
        );
      }
    }

    String getError(int statusCode) {
      if (statusCode == ERROR_EMPTY) {
        return 'EMPTY';
      } else if (statusCode == ERROR_SERVER) {
        return 'SERVER';
      } else if (statusCode == ERROR_CLIENT) {
        return 'CLIENT';
      } else {
        return 'UNKNOWN';
      }
    }

    Color getBackgroundColor(bool isCorrect) {
      if (isCorrect) {
        return cs.primary;
      } else {
        return cs.tertiary;
      }
    }

    Color getOnSurfaceColor(bool isCorrect) {
      if (isCorrect) {
        return cs.onPrimary;
      } else {
        return cs.onTertiary;
      }
    }

    PreferredSizeWidget buildAppBar(bool isCorrect) {
      return AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: largeFont
              ? tt.headlineLarge?.copyWith(
                  color: getOnSurfaceColor(isCorrect),
                )
              : tt.titleLarge?.copyWith(
                  color: getOnSurfaceColor(isCorrect),
                ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: getOnSurfaceColor(isCorrect),
        ),
        systemOverlayStyle: getSystemUiOverlayStyle(),
      );
    }

    List<Widget> getMessages(Color onSurfaceColor) {
      return List.generate(
        response.length,
        (i) {
          return Padding(
            padding: EdgeInsets.only(
              top: i == 0 ? 0 : 12,
              bottom: i == response.length - 1 ? 0 : 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    process(
                      response[i],
                      largeFont ? 16 : 24,
                    ),
                    style: largeFont
                        ? tt.titleLarge?.copyWith(color: cs.onSurface)
                        : tt.bodyLarge?.copyWith(color: cs.onSurface),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget buildBody(bool isCorrect) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(isCorrect),
            const SizedBox(height: 32),
            const Divider(endIndent: 128),
            const SizedBox(height: 32),
            getBody(isCorrect),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: getMessages(getOnSurfaceColor(isCorrect)),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildError(int statusCode) {
      return Scaffold(
        appBar: BuildAppBar(pushed: true, title: title),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ERROR',
                style: tt.headlineLarge?.copyWith(color: cs.onSurface),
              ),
              Text(
                getError(statusCode),
                style: tt.displayLarge?.copyWith(color: cs.onSurface),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildLoading() {
      return Scaffold(
        appBar: BuildAppBar(pushed: true, title: title),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    bool getIsCorrect() {
      for (int j = 0; j < response.length; j++) {
        String variant = response[j];

        if (request == variant) {
          return true;
        }
      }

      return false;
    }

    return FutureBuilder(
      future: CloudFunctionsController.getResponse(request),
      builder: (_, snapshot) {
        response = snapshot.data;

        if (snapshot.hasData) {
          bool isCorrect = getIsCorrect();

          return Scaffold(
            backgroundColor: getBackgroundColor(isCorrect),
            appBar: buildAppBar(isCorrect),
            body: buildBody(isCorrect),
          );
        } else {
          return buildLoading();
        }
      },
    );
  }
}

String process(String data, int num) {
  List<String> lines = [];

  int cnt = 0;
  String line = "";
  for (int i = 0; i < data.length; i += 1) {
    if (i == data.length - 1) {
      cnt += 1;
      line += data[i];
      lines.add(line);
    } else if (cnt == num || data[i] == '\n') {
      lines.add(line);
      cnt = 1;
      line = data[i];
    } else {
      cnt += 1;
      line += data[i];
    }
  }

  return lines.join('\n');
}
