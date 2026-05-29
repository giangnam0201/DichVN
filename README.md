# DichVN Translator

A cross-platform translator app built with Flutter, featuring speech-to-text, text-to-speech, and translation powered by the MyMemory API.

## Features

- Translate text between 30+ languages
- Speech-to-text input via microphone
- Text-to-speech output for both source and translated text
- Beautiful Material Design 3 UI
- Cross-platform: Web, Android, and Windows

## Supported Platforms

- **Web** - Runs in any modern browser
- **Android** - APK for Android 5.0+
- **Windows** - Native Windows desktop app

## Building

### Prerequisites

- Flutter SDK (stable channel)
- For Android: Java 17
- For Windows: Visual Studio with Desktop C++ workload

### Commands

```bash
# Get dependencies
flutter pub get

# Build for web
flutter build web

# Build for Android
flutter build apk --release

# Build for Windows
flutter build windows --release
```

## Architecture

- `lib/models/` - Data models (Language)
- `lib/services/` - Business logic (Translation, TTS, Speech)
- `lib/widgets/` - Reusable UI components
- `lib/screens/` - App screens

## API

Uses the [MyMemory Translation API](https://mymemory.translated.net/) (free, no API key required).
