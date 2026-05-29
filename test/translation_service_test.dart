import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:dichvn/services/translation_service.dart';

void main() {
  group('TranslationService', () {
    test('returns translated text on successful API call', () async {
      final mockClient = MockClient((request) async {
        final responseBody = json.encode({
          'responseData': {
            'translatedText': 'Xin chao',
            'match': 1.0,
          },
          'responseStatus': 200,
        });
        return http.Response(responseBody, 200);
      });

      final service = TranslationService(client: mockClient);

      final result = await service.translate(
        text: 'Hello',
        fromLang: 'en',
        toLang: 'vi',
      );

      expect(result, 'Xin chao');
    });

    test('returns empty string for empty input', () async {
      final service = TranslationService();

      final result = await service.translate(
        text: '',
        fromLang: 'en',
        toLang: 'vi',
      );

      expect(result, '');
    });

    test('throws TranslationException on API error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = TranslationService(client: mockClient);

      expect(
        () => service.translate(
          text: 'Hello',
          fromLang: 'en',
          toLang: 'vi',
        ),
        throwsA(isA<TranslationException>()),
      );
    });

    test('throws TranslationException on invalid response format', () async {
      final mockClient = MockClient((request) async {
        final responseBody = json.encode({
          'responseData': null,
        });
        return http.Response(responseBody, 200);
      });

      final service = TranslationService(client: mockClient);

      expect(
        () => service.translate(
          text: 'Hello',
          fromLang: 'en',
          toLang: 'vi',
        ),
        throwsA(isA<TranslationException>()),
      );
    });
  });
}
