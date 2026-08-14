enum CollectionKind { coin, banana, goldenBanana }

class ScoreEvent {
  const ScoreEvent(this.label, this.points, {this.isMilestone = false});

  final String label;
  final int points;
  final bool isMilestone;
}

class ScoreSystem {
  int _score = 0;
  double _distanceAccumulator = 0;
  int _distanceMeters = 0;
  int _combo = 0;
  double _comboTimer = 0;
  int _nextMilestone = 100;

  int get score => _score;
  int get distanceMeters => _distanceMeters;
  int get combo => _combo;

  void reset() {
    _score = 0;
    _distanceAccumulator = 0;
    _distanceMeters = 0;
    _combo = 0;
    _comboTimer = 0;
    _nextMilestone = 100;
  }

  ScoreEvent? update(double dt, double speed) {
    _distanceAccumulator += speed * dt;
    final newMeters = (_distanceAccumulator / 24).floor();
    if (newMeters > _distanceMeters) {
      final gained = newMeters - _distanceMeters;
      _distanceMeters = newMeters;
      _score += gained;
    }

    if (_comboTimer > 0) {
      _comboTimer -= dt;
      if (_comboTimer <= 0) _combo = 0;
    }

    if (_distanceMeters >= _nextMilestone) {
      final reached = _nextMilestone;
      _nextMilestone *= 5;
      return ScoreEvent('$reached m', 0, isMilestone: true);
    }
    return null;
  }

  ScoreEvent collect(CollectionKind kind) {
    final points = switch (kind) {
      CollectionKind.coin => 10,
      CollectionKind.banana => 25,
      CollectionKind.goldenBanana => 100,
    };
    _score += points;
    _combo += 1;
    _comboTimer = 2.2;
    final itemLabel = switch (kind) {
      CollectionKind.coin => '+10',
      CollectionKind.banana => 'BANANA +25',
      CollectionKind.goldenBanana => 'GOLDEN +100',
    };
    final comboLabel = _combo >= 3 ? '  COMBO x$_combo' : '';
    return ScoreEvent('$itemLabel$comboLabel', points);
  }
}
