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

  bool get isMusicPlaying => _musicStarted && FlameAudio.bgm.isPlaying;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await FlameAudio.bgm.initialize();
      _initialized = true;
    } catch (error) {
      _log('Audio initialization failed: $error');
    }
  }

  Future<void> configure({required bool music, required bool sound}) async {
    final wasMusicEnabled = musicEnabled;
    musicEnabled = music;
    soundEnabled = sound;

    if (!music) {
      await stopMusic();
    } else if (!wasMusicEnabled) {
      await startMusic();
    }
  }

  Future<void> startMusic() async {
    if (!musicEnabled || (_musicStarted && FlameAudio.bgm.isPlaying)) return;
    await initialize();
    try {
      await FlameAudio.bgm.play(_musicAsset, volume: 0.42);
      _musicStarted = true;
    } catch (error) {
      _musicStarted = false;
      _log('Background music could not start: $error');
    }
  }

  Future<void> stopMusic() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (error) {
      _log('Background music could not stop: $error');
    } finally {
      _musicStarted = false;
    }
  }

  Future<void> pauseMusic() async {
    if (!_musicStarted) return;
    try {
      await FlameAudio.bgm.pause();
    } catch (error) {
      _log('Background music could not pause: $error');
    }
  }

  Future<void> resumeMusic() async {
    if (!musicEnabled || !_musicStarted) return;
    try {
      await FlameAudio.bgm.resume();
    } catch (error) {
      _log('Background music could not resume: $error');
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

  void _log(String message) {
    if (kDebugMode) debugPrint('Jungle Monkey Run audio: $message');
  }
}
