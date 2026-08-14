import 'dart:math';

import 'score_system.dart';

enum ObstacleKind { log, root, rock, thornyPlant }

class SpawnRequest {
  const SpawnRequest.obstacle(this.obstacle)
    : collectible = null,
      heightFactor = 0;

  const SpawnRequest.collectible(this.collectible, this.heightFactor)
    : obstacle = null;

  final ObstacleKind? obstacle;
  final CollectionKind? collectible;
  final double heightFactor;

  bool get isObstacle => obstacle != null;
}

class SpawnSystem {
  SpawnSystem({Random? random}) : _random = random ?? Random();

  final Random _random;
  double _cooldown = 1.2;
  double _safeGap = 0;
  int _spawnIndex = 0;

  void reset() {
    _cooldown = 1.2;
    _safeGap = 0;
    _spawnIndex = 0;
  }

  double minimumSafeDistance(double speed) => speed * 0.82 + 175;

  List<SpawnRequest> update(double dt, double speed, double targetInterval) {
    _cooldown -= dt;
    if (_cooldown > 0) return const [];

    final safeDistance = minimumSafeDistance(speed);
    _safeGap = safeDistance;
    _cooldown = (safeDistance / speed).clamp(targetInterval, 2.7);
    _spawnIndex += 1;

    final obstacle =
        ObstacleKind.values[_random.nextInt(ObstacleKind.values.length)];
    final requests = <SpawnRequest>[SpawnRequest.obstacle(obstacle)];

    final pattern = _spawnIndex % 5;
    if (pattern == 1 || pattern == 3) {
      requests.add(const SpawnRequest.collectible(CollectionKind.coin, 0.30));
      requests.add(const SpawnRequest.collectible(CollectionKind.coin, 0.48));
      requests.add(const SpawnRequest.collectible(CollectionKind.banana, 0.64));
    } else if (pattern == 0) {
      requests.add(
        const SpawnRequest.collectible(CollectionKind.goldenBanana, 0.72),
      );
    } else if (pattern == 2) {
      requests.add(const SpawnRequest.collectible(CollectionKind.banana, 0.42));
    }
    return requests;
  }

  double get latestSafeGap => _safeGap;
}
