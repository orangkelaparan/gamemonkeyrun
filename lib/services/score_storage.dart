import 'package:shared_preferences/shared_preferences.dart';

class GamePreferences {
  const GamePreferences({
    required this.bestScore,
    required this.tutorialCompleted,
    required this.musicEnabled,
    required this.soundEnabled,
  });

  final int bestScore;
  final bool tutorialCompleted;
  final bool musicEnabled;
  final bool soundEnabled;
}

class ScoreStorage {
  ScoreStorage() : _preferences = SharedPreferencesAsync();

  ScoreStorage.testing() : _preferences = null;

  SharedPreferencesAsync get _store => _preferences ?? SharedPreferencesAsync();

  static const _bestScoreKey = 'best_score';
  static const _tutorialCompletedKey = 'tutorial_completed';
  static const _musicEnabledKey = 'music_enabled';
  static const _soundEnabledKey = 'sound_enabled';

  final SharedPreferencesAsync? _preferences;

  Future<GamePreferences> loadPreferences() async {
    try {
      final values = await Future.wait<Object?>([
        _store.getInt(_bestScoreKey),
        _store.getBool(_tutorialCompletedKey),
        _store.getBool(_musicEnabledKey),
        _store.getBool(_soundEnabledKey),
      ]);
      return GamePreferences(
        bestScore: values[0] as int? ?? 0,
        tutorialCompleted: values[1] as bool? ?? false,
        musicEnabled: values[2] as bool? ?? true,
        soundEnabled: values[3] as bool? ?? true,
      );
    } catch (_) {
      return const GamePreferences(
        bestScore: 0,
        tutorialCompleted: false,
        musicEnabled: true,
        soundEnabled: true,
      );
    }
  }

  Future<int> loadBestScore() async {
    try {
      return await _store.getInt(_bestScoreKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> saveBestScore(int score) => _store.setInt(_bestScoreKey, score);

  Future<void> setTutorialCompleted(bool value) =>
      _store.setBool(_tutorialCompletedKey, value);

  Future<void> setMusicEnabled(bool value) =>
      _store.setBool(_musicEnabledKey, value);

  Future<void> setSoundEnabled(bool value) =>
      _store.setBool(_soundEnabledKey, value);
}
