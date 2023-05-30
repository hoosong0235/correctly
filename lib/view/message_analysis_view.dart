import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:provider/provider.dart';
import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/message_controller.dart';
import 'package:the_voice/util/build.dart';
import 'package:the_voice/provider/setting_provider.dart';
import 'package:the_voice/util/constant.dart';

class MessageAnalysisView extends StatefulWidget {
  final int threadId;

  const MessageAnalysisView({super.key, required this.threadId});

  @override
  State<MessageAnalysisView> createState() => _MessageAnalysisViewState();
}

class _MessageAnalysisViewState extends State<MessageAnalysisView> {
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

    SmsMessage lastMessage = MessageController.messages[widget.threadId]![0];

    String title =
        lastMessage.name! != '' ? lastMessage.name! : lastMessage.address!;

    List<SmsMessage> requests = MessageController.messages[widget.threadId]!;
    dynamic responses;

    SystemUiOverlayStyle getSystemUiOverlayStyle(double probability) {
      if (brightness) {
        if (THRESHOLD2 < probability && probability <= THRESHOLD3) {
          return SystemUiOverlayStyle.dark;
        } else {
          return SystemUiOverlayStyle.light;
        }
      } else {
        if (THRESHOLD2 < probability && probability <= THRESHOLD3) {
          return SystemUiOverlayStyle.light;
        } else {
          return SystemUiOverlayStyle.dark;
        }
      }
    }

    Widget getTitle(double probability) {
      TextStyle? onTertiary = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onTertiary)
          : tt.displaySmall?.copyWith(color: cs.onTertiary);
      TextStyle? onSurfaceVariant = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onSurfaceVariant)
          : tt.displaySmall?.copyWith(color: cs.onSurfaceVariant);
      TextStyle? onPrimary = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onPrimary)
          : tt.displaySmall?.copyWith(color: cs.onPrimary);

      if (probability > THRESHOLD4) {
        return Text(lang ? 'Very Correct' : '매우 올발라요', style: onPrimary);
      } else if (probability > THRESHOLD3) {
        return Text(lang ? 'Correct' : '올발라요', style: onPrimary);
      } else if (probability > THRESHOLD2) {
        return Text(lang ? 'Normal' : '보통이에요', style: onSurfaceVariant);
      } else if (probability > THRESHOLD1) {
        return Text(lang ? 'Incorrect' : '올바르지 않아요', style: onTertiary);
      } else {
        return Text(lang ? 'Very Incorrect' : '매우 올바르지 않아요', style: onTertiary);
      }
    }

    Widget getProbability(double probability) {
      TextStyle? onTertiary = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onTertiary,
      );
      TextStyle? onSurfaceVariant = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onSurfaceVariant,
      );
      TextStyle? onPrimary = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onPrimary,
      );

      if (probability > THRESHOLD4) {
        return Text('${probability.toInt()}%', style: onPrimary);
      } else if (probability > THRESHOLD3) {
        return Text('${probability.toInt()}%', style: onPrimary);
      } else if (probability > THRESHOLD2) {
        return Text('${probability.toInt()}%', style: onSurfaceVariant);
      } else if (probability > THRESHOLD1) {
        return Text('${probability.toInt()}%', style: onTertiary);
      } else {
        return Text('${probability.toInt()}%', style: onTertiary);
      }
    }

    Widget getBody(double probability) {
      TextStyle? onTertiary = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onTertiary)
          : tt.titleLarge?.copyWith(color: cs.onTertiary);
      TextStyle? onSurfaceVariant = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onSurfaceVariant)
          : tt.titleLarge?.copyWith(color: cs.onSurfaceVariant);
      TextStyle? onPrimary = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onPrimary)
          : tt.titleLarge?.copyWith(color: cs.onPrimary);

      if (probability > THRESHOLD4) {
        return Text(
          lang
              ? 'AI Detected Below\nSentences Incorrect!'
              : 'AI가 아래 문장들을\n올바르지 않다고 판단했어요!',
          style: onPrimary,
        );
      } else if (probability > THRESHOLD3) {
        return Text(
          lang
              ? 'AI Detected Below\nSentences Incorrect!'
              : 'AI가 아래 문장들을\n올바르지 않다고 판단했어요!',
          style: onPrimary,
        );
      } else if (probability > THRESHOLD2) {
        return Text(
          lang
              ? 'AI Detected Below\nSentences Incorrect!'
              : 'AI가 아래 문장들을\n올바르지 않다고 판단했어요!',
          style: onSurfaceVariant,
        );
      } else if (probability > THRESHOLD1) {
        return Text(
          lang
              ? 'AI Detected Below\nSentences Incorrect!'
              : 'AI가 아래 문장들을\n올바르지 않다고 판단했어요!',
          style: onTertiary,
        );
      } else {
        return Text(
          lang
              ? 'AI Detected Below\nSentences Incorrect!'
              : 'AI가 아래 문장들을\n올바르지 않다고 판단했어요!',
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

    Color getBackgroundColor(double probability) {
      TonalPalette toTonalPallete(Color color) {
        final hct = Hct.fromInt(color.value);
        return TonalPalette.of(hct.hue, hct.chroma);
      }

      if (probability > THRESHOLD4) {
        return cs.primary;
      } else if (probability > THRESHOLD3) {
        return Color(toTonalPallete(cs.primary).get(60));
      } else if (probability > THRESHOLD2) {
        return cs.surfaceVariant;
      } else if (probability > THRESHOLD1) {
        return Color(toTonalPallete(cs.tertiary).get(60));
      } else {
        return cs.tertiary;
      }
    }

    Color getOnSurfaceColor(double probability) {
      if (probability > THRESHOLD3) {
        return cs.onPrimary;
      } else if (probability > THRESHOLD2) {
        return cs.onSurfaceVariant;
      } else {
        return cs.onTertiary;
      }
    }

    PreferredSizeWidget buildAppBar(double probability) {
      return AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: largeFont
              ? tt.headlineLarge?.copyWith(
                  color: getOnSurfaceColor(probability),
                )
              : tt.titleLarge?.copyWith(
                  color: getOnSurfaceColor(probability),
                ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: getOnSurfaceColor(probability),
        ),
        systemOverlayStyle: getSystemUiOverlayStyle(probability),
      );
    }

    List<Widget> getMessages(Color onSurfaceColor) {
      return List.generate(
        responses['variants'].length * 2,
        (i) {
          int index = i ~/ 2;
          bool isUser = i % 2 == 0;

          return Padding(
            padding: EdgeInsets.only(
              top: i == 0 ? 0 : 12,
              bottom: i == responses!.length * 2 - 1 ? 0 : 12,
            ),
            child: Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isUser ? cs.surface : cs.surfaceVariant,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                          isUser ? const Radius.circular(16) : Radius.zero,
                      bottomRight:
                          isUser ? Radius.zero : const Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    isUser
                        ? process(
                            requests[index].body!,
                            largeFont ? 16 : 24,
                          )
                        : process(
                            responses['variants'][index][0],
                            largeFont ? 16 : 24,
                          ),
                    style: largeFont
                        ? tt.titleLarge?.copyWith(
                            color: isUser ? cs.onSurface : cs.onSurfaceVariant,
                          )
                        : tt.bodyLarge?.copyWith(
                            color: isUser ? cs.onSurface : cs.onSurfaceVariant,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget buildBody(double probability) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTitle(probability),
            const SizedBox(height: 8),
            getProbability(probability),
            const SizedBox(height: 32),
            const Divider(endIndent: 128),
            const SizedBox(height: 32),
            getBody(probability),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: getMessages(getOnSurfaceColor(probability)),
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

    double getPercentage() {
      int cnt = 0;

      for (int i = 0; i < responses['variants'].length; i++) {
        String request = requests[i].body!;

        for (int j = 0; j < responses['variants'][i].length; j++) {
          String variant = responses['variants'][i][j];

          if (request == variant) {
            cnt += 1;
            break;
          }
        }
      }

      return 100 * cnt / responses['variants'].length;
    }

    return FutureBuilder(
      future: MessageController.analyzeMessages(requests),
      builder: (_, snapshot) {
        responses = snapshot.data;

        if (snapshot.hasData) {
          int statusCode = responses['statusCode'];

          if (statusCode == 200) {
            assert(requests.length == responses['variants'].length);

            double probability = getPercentage();

            return Scaffold(
              backgroundColor: getBackgroundColor(probability),
              appBar: buildAppBar(probability),
              body: buildBody(probability),
            );
          } else {
            return buildError(responses['statusCode']);
          }
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
