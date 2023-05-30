import 'package:telephony/telephony.dart';
import 'package:the_voice/controller/cloud_functions_controller.dart';
import 'package:the_voice/controller/contact_controller.dart';

class MessageController {
  static int _loadedIndex = 0;
  static bool _isLoading = false;

  static List<SmsConversation> _smsConversations = [];

  // ignore: prefer_final_fields
  static Map<int, List<SmsMessage>> _messages = {};
  static Map<int, List<SmsMessage>> get messages {
    return _messages;
  }

  // ignore: prefer_final_fields
  static List<SmsConversation> _conversations = [];
  static List<SmsConversation> get conversations {
    if (_conversations.isEmpty) loadConversations();
    return _conversations;
  }

  static Future<void> fetchMessages() async {
    Telephony telephony = Telephony.instance;

    _smsConversations = await telephony.getConversations();

    for (SmsConversation smsConversation in _smsConversations) {
      _messages[smsConversation.threadId!] =
          (await Telephony.instance.getSentSms(
        filter: SmsFilter.where(SmsColumn.THREAD_ID).equals(
          smsConversation.threadId.toString(),
        ),
      ))
            ..forEach((e) => e.name = ContactController.getName(e.address!))
            ..sort((a, b) => (b.date!).compareTo(a.date!));
    }

    _smsConversations = _smsConversations
        .where((element) => _messages[element.threadId]!.isNotEmpty)
        .toList();

    _smsConversations.sort(
      (a, b) => (_messages[b.threadId]![0].date!)
          .compareTo(_messages[a.threadId]![0].date!),
    );
  }

  static void loadConversations() {
    if (!_isLoading) {
      _isLoading = true;

      if (_loadedIndex + 10 < _smsConversations.length) {
        _conversations.addAll(
          _smsConversations.sublist(_loadedIndex, _loadedIndex + 10),
        );
        _loadedIndex += 10;
      } else {
        _conversations.addAll(
          _smsConversations.sublist(_loadedIndex, _smsConversations.length),
        );
        _loadedIndex = _smsConversations.length;
      }

      _isLoading = false;
    }
  }

  static Future<dynamic> analyzeMessages(List<SmsMessage> requests) async {
    List<dynamic> responses = [];

    for (int i = 0; i < requests.length; i++) {
      responses.add(
        await CloudFunctionsController.getResponse(requests[i].body!),
      );
    }

    return {'statusCode': 200, 'variants': responses};
  }
}
