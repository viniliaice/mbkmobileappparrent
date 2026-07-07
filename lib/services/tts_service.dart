import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._internal();
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;
  bool _initFailed = false;
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;
  bool get initFailed => _initFailed;

  Future<void> _initEngine() async {
    if (_initialized || _initFailed) return;
    try {
      // Step 1: wait for the native engine to actually bind
      // flutter_tts exposes this via getLanguages — it blocks until bound
      await _waitForEngine();

      // Step 2: now safe to configure
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.40);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.awaitSpeakCompletion(true);

      // Step 3: register handlers once
      _tts.setCompletionHandler(() {
        _isSpeaking = false;
      });
      _tts.setErrorHandler((msg) {
        debugPrint('TTS error: $msg');
        _isSpeaking = false;
      });
      _tts.setCancelHandler(() {
        _isSpeaking = false;
      });

      _initialized = true;
      debugPrint('TTS engine initialized OK');
    } catch (e) {
      debugPrint('TTS init failed: $e');
      _initFailed = true;
    }
  }

  /// Polls until the native TTS engine is bound and responsive.
  /// getLanguages() throws or returns empty if the engine isn't ready yet.
  Future<void> _waitForEngine() async {
    const maxAttempts = 10;
    const delay = Duration(milliseconds: 200);

    for (int i = 0; i < maxAttempts; i++) {
      try {
        final languages = await _tts.getLanguages;
        if (languages != null && (languages as List).isNotEmpty) {
          debugPrint('TTS engine bound after ${(i + 1) * 200}ms');
          return; // engine is ready
        }
      } catch (_) {
        // not ready yet
      }
      await Future.delayed(delay);
    }

    // If we get here the engine never responded — throw so _initFailed is set
    throw Exception('TTS engine did not bind after ${maxAttempts * 200}ms');
  }

  Future<void> _ensureInitialized() async {
    if (!_initialized && !_initFailed) {
      await _initEngine();
    }
  }

  Future<void> _reinitIfNeeded() async {
    _initialized = false;
    _initFailed = false;
    await _initEngine();
  }

  Future<void> _safeSpeak(String text, {double? rate}) async {
    await _ensureInitialized();
    if (_initFailed) return;

    try {
      if (_isSpeaking) {
        await _tts.stop();
        _isSpeaking = false;
      }
      if (rate != null) {
        await _tts.setSpeechRate(rate);
      }
      _isSpeaking = true;
      await _tts.speak(text);
    } catch (e) {
      debugPrint('TTS speak failed: $e — attempting re-init');
      _isSpeaking = false;
      await _reinitIfNeeded();
      if (!_initFailed) {
        try {
          if (rate != null) await _tts.setSpeechRate(rate);
          _isSpeaking = true;
          await _tts.speak(text);
        } catch (_) {
          _isSpeaking = false;
        }
      }
    }
  }

  Future<void> speak(String text) async {
    await _safeSpeak(text);
  }

  Future<void> speakWord(String word) async {
    await _safeSpeak(word, rate: 0.35);
  }

  Future<void> stop() async {
    if (_initFailed) return;
    try {
      if (_isSpeaking) {
        await _tts.stop();
        _isSpeaking = false;
      }
    } catch (e) {
      debugPrint('TTS stop failed: $e');
      _isSpeaking = false;
    }
  }

  Future<void> dispose() async {
    await stop();
  }
}