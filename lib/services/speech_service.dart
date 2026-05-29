import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _isInitialized = await _speechToText.initialize(
      onError: (error) {
        _isListening = false;
      },
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          _isListening = false;
        }
      },
    );

    return _isInitialized;
  }

  Future<void> startListening({
    required Function(SpeechRecognitionResult) onResult,
    String? localeId,
  }) async {
    if (!_isInitialized) {
      final success = await initialize();
      if (!success) return;
    }

    _isListening = true;

    await _speechToText.listen(
      onResult: (result) {
        onResult(result);
      },
      localeId: localeId,
      listenMode: ListenMode.dictation,
    );
  }

  Future<void> stopListening() async {
    _isListening = false;
    await _speechToText.stop();
  }

  void dispose() {
    _speechToText.stop();
    _speechToText.cancel();
  }
}
