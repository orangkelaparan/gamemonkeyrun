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
  ScoreStorage({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const _bestScoreKey = 'best_score';
  static const _tutorialCompletedKey = 'tutorial_completed';
  static const _musicEnabledKey = 'music_enabled';
  static const _soundEnabledKey = 'sound_enabled';

  final SharedPreferencesAsync _preferences;

  Future<GamePreferences> loadPreferences() async {
    try {
      final values = await Future.wait<Object?>([
        _preferences.getInt(_bestScoreKey),
        _preferences.getBool(_tutorialCompletedKey),
        _preferences.getBool(_musicEnabledKey),
        _preferences.getBool(_soundEnabledKey),
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
      return await _preferences.getInt(_bestScoreKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> saveBestScore(int score) =>
      _preferences.setInt(_bestScoreKey, score);

  Future<void> setTutorialCompleted(bool value) =>
      _preferences.setBool(_tutorialCompletedKey, value);

  Future<void> setMusicEnabled(bool value) =>
      _preferences.setBool(_musicEnabledKey, value);

  Future<void> setSoundEnabled(bool value) =>
      _preferences.setBool(_soundEnabledKey, value);
}
