import 'dart:async';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

import '../game/systems/score_system.dart';

class AudioService {
  bool musicEnabled = true;
  bool soundEnabled = true;
  bool _musicStarted = false;

  Future<void> configure({required bool music, required bool sound}) async {
    musicEnabled = music;
    soundEnabled = sound;
    if (!music) await stopMusic();
  }

  Future<void> startMusic() async {
    if (!musicEnabled || _musicStarted) return;
    try {
      await FlameAudio.bgm.play(
        'music/jungle_adventure_loop.wav',
        volume: 0.34,
      );
      _musicStarted = true;
    } catch (_) {
      _musicStarted = false;
    }
  }

  Future<void> stopMusic() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {
      // Audio must never interrupt the game if the device audio backend is unavailable.
    } finally {
      _musicStarted = false;
    }
  }

  Future<void> pauseMusic() async {
    if (!_musicStarted) return;
    try {
      await FlameAudio.bgm.pause();
    } catch (_) {
      // Safe no-op on unsupported audio platforms.
    }
  }

  Future<void> resumeMusic() async {
    if (!musicEnabled || !_musicStarted) return;
    try {
      await FlameAudio.bgm.resume();
    } catch (_) {
      // Safe no-op on unsupported audio platforms.
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
}
