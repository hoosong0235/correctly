import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudFunctionsController {
  static String authority =
      'us-central1-atlantean-bot-383117.cloudfunctions.net';
  static String encodedPath = '/keywordly';

  static Future<dynamic> getResponse(String input) async {
    http.Response response = await http.post(
      Uri.https(authority, encodedPath),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({'input': input}),
    );

    return jsonDecode(response.body);
  }
}
