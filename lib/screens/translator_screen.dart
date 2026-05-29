import 'package:flutter/material.dart';
import '../models/language.dart';
import '../services/translation_service.dart';
import '../services/tts_service.dart';
import '../services/speech_service.dart';
import '../widgets/language_selector.dart';
import '../widgets/speak_button.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TranslationService _translationService = TranslationService();
  final TtsService _ttsService = TtsService();
  final SpeechService _speechService = SpeechService();
  final TextEditingController _textController = TextEditingController();

  Language _sourceLanguage = Language.supportedLanguages[0]; // English
  Language _targetLanguage = Language.supportedLanguages[1]; // Vietnamese

  String _translatedText = '';
  bool _isTranslating = false;
  bool _isListening = false;

  @override
  void dispose() {
    _textController.dispose();
    _translationService.dispose();
    _ttsService.dispose();
    _speechService.dispose();
    super.dispose();
  }

  Future<void> _translate() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isTranslating = true);

    try {
      final result = await _translationService.translate(
        text: _textController.text,
        fromLang: _sourceLanguage.code,
        toLang: _targetLanguage.code,
      );
      setState(() {
        _translatedText = result;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() => _isTranslating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Translation failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = temp;

      if (_translatedText.isNotEmpty) {
        _textController.text = _translatedText;
        _translatedText = '';
        _translate();
      }
    });
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speechService.stopListening();
      setState(() => _isListening = false);
      if (_textController.text.isNotEmpty) {
        _translate();
      }
    } else {
      setState(() => _isListening = true);
      await _speechService.startListening(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
          if (result.finalResult) {
            setState(() => _isListening = false);
            _translate();
          }
        },
        localeId: _sourceLanguage.code,
      );
    }
  }

  Future<void> _speakSource() async {
    if (_textController.text.isNotEmpty) {
      await _ttsService.speak(_textController.text, _sourceLanguage.code);
    }
  }

  Future<void> _speakTranslation() async {
    if (_translatedText.isNotEmpty) {
      await _ttsService.speak(_translatedText, _targetLanguage.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.3),
              colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // App Title
                Text(
                  'DichVN Translator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Language Selectors Row
                _buildLanguageRow(),
                const SizedBox(height: 16),

                // Input Area
                Expanded(
                  flex: 2,
                  child: _buildInputCard(colorScheme),
                ),
                const SizedBox(height: 12),

                // Speak Button
                SpeakButton(
                  isListening: _isListening,
                  onPressed: _toggleListening,
                ),
                const SizedBox(height: 12),

                // Translation Output
                Expanded(
                  flex: 2,
                  child: _buildOutputCard(colorScheme),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageRow() {
    return Row(
      children: [
        Expanded(
          child: LanguageSelector(
            label: 'From',
            selectedLanguage: _sourceLanguage,
            onLanguageChanged: (lang) {
              setState(() => _sourceLanguage = lang);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton.filled(
            onPressed: _swapLanguages,
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Swap languages',
          ),
        ),
        Expanded(
          child: LanguageSelector(
            label: 'To',
            selectedLanguage: _targetLanguage,
            onLanguageChanged: (lang) {
              setState(() => _targetLanguage = lang);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Enter text to translate...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                onSubmitted: (_) => _translate(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _speakSource,
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Listen to source text',
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: _isTranslating ? null : _translate,
                  icon: _isTranslating
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : const Icon(Icons.translate_rounded),
                  label: const Text('Translate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutputCard(ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.secondaryContainer.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: SelectableText(
                    _translatedText.isEmpty
                        ? 'Translation will appear here...'
                        : _translatedText,
                    style: TextStyle(
                      fontSize: 16,
                      color: _translatedText.isEmpty
                          ? colorScheme.onSurface.withOpacity(0.5)
                          : colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed:
                      _translatedText.isNotEmpty ? _speakTranslation : null,
                  icon: const Icon(Icons.volume_up_rounded),
                  tooltip: 'Listen to translation',
                  color: colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
