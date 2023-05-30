import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:the_voice/provider/setting_provider.dart';

class CallAnalysisView extends StatefulWidget {
  final CallLogEntry callLogEntry;

  const CallAnalysisView({super.key, required this.callLogEntry});

  @override
  State<CallAnalysisView> createState() => _CallAnalysisViewState();
}

class _CallAnalysisViewState extends State<CallAnalysisView> {
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

    String title = widget.callLogEntry.name! != ''
        ? widget.callLogEntry.name!
        : widget.callLogEntry.number!;

    SystemUiOverlayStyle getSystemUiOverlayStyle() {
      if (brightness) {
        return SystemUiOverlayStyle.dark;
      } else {
        return SystemUiOverlayStyle.light;
      }
    }

    Widget getTitle() {
      TextStyle? onSurfaceVariant = largeFont
          ? tt.displayMedium?.copyWith(color: cs.onSurfaceVariant)
          : tt.displaySmall?.copyWith(color: cs.onSurfaceVariant);

      return Text(lang ? 'Normal' : '보통이에요', style: onSurfaceVariant);
    }

    Widget getProbability() {
      TextStyle? onSurfaceVariant = tt.displayLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: cs.onSurfaceVariant,
      );

      return Text('50%', style: onSurfaceVariant);
    }

    Widget getBody() {
      TextStyle? onSurfaceVariant = largeFont
          ? tt.headlineMedium?.copyWith(color: cs.onSurfaceVariant)
          : tt.titleLarge?.copyWith(color: cs.onSurfaceVariant);

      return Text(
        lang
            ? 'AI Detected Below\nSentences Incorrect!'
            : 'AI가 아래 문장들을\n올바르지 않다고 판단했어요!',
        style: onSurfaceVariant,
      );
    }

    Color getBackgroundColor() {
      return cs.surfaceVariant;
    }

    Color getOnSurfaceColor() {
      return cs.onSurfaceVariant;
    }

    PreferredSizeWidget buildAppBar() {
      return AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          title,
          style: largeFont
              ? tt.headlineLarge?.copyWith(color: getOnSurfaceColor())
              : tt.titleLarge?.copyWith(color: getOnSurfaceColor()),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          color: getOnSurfaceColor(),
        ),
        systemOverlayStyle: getSystemUiOverlayStyle(),
      );
    }

    List<Widget> getMessages(Color onSurfaceColor) {
      return List.generate(
        10,
        (index) {
          bool isUser = index % 2 == 0;

          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 0 : 12,
              bottom: index == 10 - 1 ? 0 : 12,
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
                        ? lang
                            ? 'incorrect sentence'
                            : '올바르지 않은 문장'
                        : lang
                            ? 'correct sentence'
                            : '올바른 문장',
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

    Widget buildBody() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitle(),
              const SizedBox(height: 8),
              getProbability(),
              const SizedBox(height: 32),
              const Divider(endIndent: 128),
              const SizedBox(height: 32),
              getBody(),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: getMessages(getOnSurfaceColor()),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: getBackgroundColor(),
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }
}
