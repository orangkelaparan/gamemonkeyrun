import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../game/systems/score_system.dart';

class AudioService {
  static const _musicAsset = 'music/jungle_adventure_loop.mp3';

  bool musicEnabled = true;
  bool soundEnabled = true;
  bool _musicStarted = false;
  bool _initialized = false;
  String? _lastError;

  bool get isMusicPlaying => _musicStarted && FlameAudio.bgm.isPlaying;
  bool get isInitialized => _initialized;
  String? get lastError => _lastError;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await FlameAudio.bgm.initialize();
      _initialized = true;
      _lastError = null;
    } catch (error, stackTrace) {
      _lastError = 'Audio initialization failed: $error';
      _log(_lastError!, stackTrace);
    }
  }

  /// Applies persisted preferences without starting playback during app boot.
  Future<void> configure({required bool music, required bool sound}) async {
    musicEnabled = music;
    soundEnabled = sound;
    if (!music) await stopMusic();
  }

  /// Applies a preference change caused by a user interaction.
  Future<void> configureFromUser({
    required bool music,
    required bool sound,
  }) async {
    final wasMusicEnabled = musicEnabled;
    await configure(music: music, sound: sound);
    if (music && (!wasMusicEnabled || !_musicStarted)) {
      await startMusic();
    }
  }

  Future<void> startMusic() async {
    if (!musicEnabled || (_musicStarted && FlameAudio.bgm.isPlaying)) return;
    await initialize();
    if (!_initialized) return;
    try {
      await FlameAudio.bgm.play(_musicAsset, volume: 0.42);
      _musicStarted = true;
      _lastError = null;
    } catch (error, stackTrace) {
      _musicStarted = false;
      _lastError = 'Background music could not start: $error';
      _log(_lastError!, stackTrace);
    }
  }

  Future<void> stopMusic() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (error, stackTrace) {
      _lastError = 'Background music could not stop: $error';
      _log(_lastError!, stackTrace);
    } finally {
      _musicStarted = false;
    }
  }

  Future<void> pauseMusic() async {
    if (!_musicStarted) return;
    try {
      await FlameAudio.bgm.pause();
    } catch (error, stackTrace) {
      _lastError = 'Background music could not pause: $error';
      _log(_lastError!, stackTrace);
    }
  }

  Future<void> resumeMusic() async {
    if (!musicEnabled || !_musicStarted) return;
    try {
      await FlameAudio.bgm.resume();
    } catch (error, stackTrace) {
      _lastError = 'Background music could not resume: $error';
      _log(_lastError!, stackTrace);
    }
  }

  void playJump() => _click();

  void playCollision() => _alert();

  void playCollect(CollectionKind kind) {
    if (kind == CollectionKind.goldenBanana) {
      _alert();
    } else {
      _click();
    }
  }

  void playNewBest() => _alert();

  void _click() {
    if (!soundEnabled) return;
    unawaited(SystemSound.play(SystemSoundType.click).catchError((_) {}));
  }

  void _alert() {
    if (!soundEnabled) return;
    unawaited(SystemSound.play(SystemSoundType.alert).catchError((_) {}));
  }

  void _log(String message, [StackTrace? stackTrace]) {
    debugPrint('Jungle Monkey Run audio: $message');
    if (stackTrace != null && kDebugMode) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
