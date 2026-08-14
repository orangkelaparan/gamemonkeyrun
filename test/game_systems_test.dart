import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:jungle_monkey_run/game/systems/collision_system.dart';
import 'package:jungle_monkey_run/game/systems/difficulty_system.dart';
import 'package:jungle_monkey_run/game/systems/score_system.dart';
import 'package:jungle_monkey_run/game/systems/spawn_system.dart';

void main() {
  group('ScoreSystem', () {
    test('distance raises score and emits milestones', () {
      final score = ScoreSystem();
      final event = score.update(10, 250);

      expect(score.distanceMeters, greaterThanOrEqualTo(100));
      expect(score.score, greaterThanOrEqualTo(100));
      expect(event?.isMilestone, isTrue);
    });

    test('collectible values match the game rules', () {
      final score = ScoreSystem();
      expect(score.collect(CollectionKind.coin).points, 10);
      expect(score.collect(CollectionKind.banana).points, 25);
      expect(score.collect(CollectionKind.goldenBanana).points, 100);
      expect(score.score, 135);
      expect(score.combo, 3);
    });
  });

  group('DifficultySystem', () {
    test('speed and spawn pressure increase smoothly over time', () {
      final system = DifficultySystem();
      final early = system.forElapsed(5);
      final late = system.forElapsed(70);

      expect(late.speed, greaterThan(early.speed));
      expect(late.spawnInterval, lessThan(early.spawnInterval));
      expect(late.terrainAmplitude, greaterThan(early.terrainAmplitude));
      expect(late.speed, lessThanOrEqualTo(DifficultySystem.maxSpeed));
    });
  });

  group('SpawnSystem', () {
    test('safe gap grows with speed', () {
      final system = SpawnSystem();
      expect(
        system.minimumSafeDistance(600),
        greaterThan(system.minimumSafeDistance(250)),
      );
      expect(system.minimumSafeDistance(250), greaterThan(350));
    });
  });

  group('CollisionSystem', () {
    const system = CollisionSystem();

    test('identifies overlapping obstacle hitboxes', () {
      expect(
        system.isObstacleHit(
          const Rect.fromLTWH(20, 20, 80, 90),
          const Rect.fromLTWH(75, 55, 70, 60),
        ),
        isTrue,
      );
    });

    test('does not report separated hitboxes', () {
      expect(
        system.isObstacleHit(
          const Rect.fromLTWH(20, 20, 80, 90),
          const Rect.fromLTWH(180, 55, 70, 60),
        ),
        isFalse,
      );
    });
  });
}
