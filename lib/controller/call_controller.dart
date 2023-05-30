import 'package:call_log/call_log.dart';
import 'package:the_voice/controller/contact_controller.dart';

class CallController {
  static int _loadedIndex = 0;
  static bool _isLoading = false;

  static List<CallLogEntry> _callLogEntries = [];

  // ignore: prefer_final_fields
  static List<CallLogEntry> _calls = [];
  static List<CallLogEntry> get calls {
    if (_calls.isEmpty) loadCalls();
    return _calls;
  }

  static Future<void> fetchCalls() async {
    _callLogEntries = (await CallLog.get()).toList()
      ..sort((a, b) => (b.timestamp!).compareTo(a.timestamp!));

    for (CallLogEntry callLogEntry in _callLogEntries) {
      callLogEntry.name = ContactController.getName(callLogEntry.number!);
    }
  }

  static void loadCalls() {
    if (!_isLoading) {
      _isLoading = true;
      if (_loadedIndex + 10 < _callLogEntries.length) {
        _calls.addAll(_callLogEntries.sublist(_loadedIndex, _loadedIndex + 10));
        _loadedIndex += 10;
      } else {
        _calls.addAll(
            _callLogEntries.sublist(_loadedIndex, _callLogEntries.length));
        _loadedIndex = _callLogEntries.length;
      }
      _isLoading = false;
    }
  }
}
