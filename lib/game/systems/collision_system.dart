import 'dart:ui';

class CollisionSystem {
  const CollisionSystem();

  bool overlaps(Rect a, Rect b, {double inset = 0}) {
    final safeA = a.deflate(inset);
    final safeB = b.deflate(inset);
    return safeA.overlaps(safeB);
  }

  bool isCollectiblePickup(Rect monkeyBounds, Rect collectibleBounds) {
    return overlaps(monkeyBounds, collectibleBounds, inset: 4);
  }

  bool isObstacleHit(Rect monkeyBounds, Rect obstacleBounds) {
    final tunedMonkey = Rect.fromLTWH(
      monkeyBounds.left + monkeyBounds.width * 0.16,
      monkeyBounds.top + monkeyBounds.height * 0.14,
      monkeyBounds.width * 0.68,
      monkeyBounds.height * 0.76,
    );
    final tunedObstacle = Rect.fromLTWH(
      obstacleBounds.left + obstacleBounds.width * 0.10,
      obstacleBounds.top + obstacleBounds.height * 0.15,
      obstacleBounds.width * 0.80,
      obstacleBounds.height * 0.80,
    );
    return tunedMonkey.overlaps(tunedObstacle);
  }
}
