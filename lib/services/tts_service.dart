import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  Future<void> _initialize() async {
    if (_isInitialized) return;

    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    _isInitialized = true;
  }

  Future<void> speak(String text, String languageCode) async {
    if (text.trim().isEmpty) return;

    await _initialize();

    // Map language codes for TTS compatibility
    final ttsLang = _mapLanguageCode(languageCode);
    await _flutterTts.setLanguage(ttsLang);
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  String _mapLanguageCode(String code) {
    // TTS engines often need locale format (e.g., en-US instead of en)
    final Map<String, String> mapping = {
      'en': 'en-US',
      'vi': 'vi-VN',
      'es': 'es-ES',
      'fr': 'fr-FR',
      'de': 'de-DE',
      'it': 'it-IT',
      'pt': 'pt-BR',
      'ru': 'ru-RU',
      'ja': 'ja-JP',
      'ko': 'ko-KR',
      'zh-CN': 'zh-CN',
      'zh-TW': 'zh-TW',
      'th': 'th-TH',
      'ar': 'ar-SA',
      'hi': 'hi-IN',
      'id': 'id-ID',
      'ms': 'ms-MY',
      'nl': 'nl-NL',
      'pl': 'pl-PL',
      'tr': 'tr-TR',
      'sv': 'sv-SE',
      'cs': 'cs-CZ',
      'da': 'da-DK',
      'fi': 'fi-FI',
      'el': 'el-GR',
      'he': 'he-IL',
      'hu': 'hu-HU',
      'no': 'nb-NO',
      'ro': 'ro-RO',
      'uk': 'uk-UA',
    };

    return mapping[code] ?? code;
  }

  void dispose() {
    _flutterTts.stop();
  }
}
