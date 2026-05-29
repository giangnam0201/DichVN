class Language {
  final String code;
  final String name;

  const Language({required this.code, required this.name});

  @override
  String toString() => '$name ($code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;

  static const List<Language> supportedLanguages = [
    Language(code: 'en', name: 'English'),
    Language(code: 'vi', name: 'Vietnamese'),
    Language(code: 'es', name: 'Spanish'),
    Language(code: 'fr', name: 'French'),
    Language(code: 'de', name: 'German'),
    Language(code: 'it', name: 'Italian'),
    Language(code: 'pt', name: 'Portuguese'),
    Language(code: 'ru', name: 'Russian'),
    Language(code: 'ja', name: 'Japanese'),
    Language(code: 'ko', name: 'Korean'),
    Language(code: 'zh-CN', name: 'Chinese (Simplified)'),
    Language(code: 'zh-TW', name: 'Chinese (Traditional)'),
    Language(code: 'th', name: 'Thai'),
    Language(code: 'ar', name: 'Arabic'),
    Language(code: 'hi', name: 'Hindi'),
    Language(code: 'id', name: 'Indonesian'),
    Language(code: 'ms', name: 'Malay'),
    Language(code: 'nl', name: 'Dutch'),
    Language(code: 'pl', name: 'Polish'),
    Language(code: 'tr', name: 'Turkish'),
    Language(code: 'sv', name: 'Swedish'),
    Language(code: 'cs', name: 'Czech'),
    Language(code: 'da', name: 'Danish'),
    Language(code: 'fi', name: 'Finnish'),
    Language(code: 'el', name: 'Greek'),
    Language(code: 'he', name: 'Hebrew'),
    Language(code: 'hu', name: 'Hungarian'),
    Language(code: 'no', name: 'Norwegian'),
    Language(code: 'ro', name: 'Romanian'),
    Language(code: 'uk', name: 'Ukrainian'),
    Language(code: 'bg', name: 'Bulgarian'),
    Language(code: 'hr', name: 'Croatian'),
    Language(code: 'sk', name: 'Slovak'),
    Language(code: 'sl', name: 'Slovenian'),
    Language(code: 'sr', name: 'Serbian'),
  ];
}
