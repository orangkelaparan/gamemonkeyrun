class DifficultySnapshot {
  const DifficultySnapshot({
    required this.speed,
    required this.spawnInterval,
    required this.terrainAmplitude,
    required this.atmosphereStrength,
    required this.tierLabel,
  });

  final double speed;
  final double spawnInterval;
  final double terrainAmplitude;
  final double atmosphereStrength;
  final String tierLabel;
}

class DifficultySystem {
  static const double baseSpeed = 250;
  static const double maxSpeed = 700;

  DifficultySnapshot forElapsed(double seconds) {
    final speed = (baseSpeed + seconds * 7.4)
        .clamp(baseSpeed, maxSpeed)
        .toDouble();
    final spawnInterval = (1.75 - seconds * 0.010).clamp(0.82, 1.75).toDouble();
    final terrainAmplitude = (4 + seconds * 0.18).clamp(4, 17).toDouble();
    final atmosphereStrength = (seconds / 100).clamp(0, 0.55).toDouble();

    return DifficultySnapshot(
      speed: speed,
      spawnInterval: spawnInterval,
      terrainAmplitude: terrainAmplitude,
      atmosphereStrength: atmosphereStrength,
      tierLabel: _tierFor(seconds),
    );
  }

  String _tierFor(double seconds) {
    if (seconds < 15) return 'EASY';
    if (seconds < 30) return 'NORMAL';
    if (seconds < 60) return 'FAST';
    if (seconds < 90) return 'VERY FAST';
    return 'EXTREME';
  }
}
