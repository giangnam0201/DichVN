import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String _baseUrl =
      'https://api.mymemory.translated.net/get';

  final http.Client _client;

  TranslationService({http.Client? client})
      : _client = client ?? http.Client();

  Future<String> translate({
    required String text,
    required String fromLang,
    required String toLang,
  }) async {
    if (text.trim().isEmpty) {
      return '';
    }

    try {
      final encodedText = Uri.encodeComponent(text);
      final url =
          '$_baseUrl?q=$encodedText&langpair=$fromLang|$toLang';

      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final responseData = data['responseData'];

        if (responseData != null &&
            responseData['translatedText'] != null) {
          return responseData['translatedText'] as String;
        } else {
          throw TranslationException(
              'Invalid response format from translation API');
        }
      } else {
        throw TranslationException(
            'Translation API returned status code: ${response.statusCode}');
      }
    } on TranslationException {
      rethrow;
    } catch (e) {
      throw TranslationException('Translation failed: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}

class TranslationException implements Exception {
  final String message;

  TranslationException(this.message);

  @override
  String toString() => 'TranslationException: $message';
}
