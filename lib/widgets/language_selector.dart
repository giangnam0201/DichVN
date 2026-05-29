import 'package:flutter/material.dart';
import '../models/language.dart';

class LanguageSelector extends StatelessWidget {
  final Language selectedLanguage;
  final ValueChanged<Language> onLanguageChanged;
  final String label;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.surfaceContainerHighest,
          ),
          child: DropdownButton<Language>(
            value: selectedLanguage,
            isExpanded: true,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(12),
            icon: Icon(
              Icons.arrow_drop_down_rounded,
              color: colorScheme.primary,
            ),
            items: Language.supportedLanguages.map((language) {
              return DropdownMenuItem<Language>(
                value: language,
                child: Text(
                  '${language.name} (${language.code})',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (language) {
              if (language != null) {
                onLanguageChanged(language);
              }
            },
          ),
        ),
      ],
    );
  }
}
