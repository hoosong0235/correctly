import 'dart:convert';
import 'package:http/http.dart' as http;

class CloudFunctionsController {
  String authority = 'us-central1-atlantean-bot-383117.cloudfunctions.net';
  String encodedPath = '/keywordly';

  Future<dynamic> getResponse(String input) async {
    try {
      http.Response response = await http.post(
        Uri.https(authority, encodedPath),
        body: jsonEncode({'input': input}),
      );

      return response.body;
    } catch (error) {
      return 'getResponse() error';
    }
  }
}
