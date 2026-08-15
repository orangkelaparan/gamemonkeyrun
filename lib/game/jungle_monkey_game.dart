import 'dart:async';
import 'dart:ui' as ui;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' show Color, ValueNotifier;

import '../services/audio_service.dart';
import '../services/score_storage.dart';
import 'components/collectible.dart';
import 'components/ground.dart';
import 'components/jungle_background.dart';
import 'components/monkey.dart';
import 'components/obstacle.dart';
import 'effects/screen_shake.dart';
import 'models/game_snapshot.dart';
import 'models/game_status.dart';
import 'systems/collision_system.dart';
import 'systems/difficulty_system.dart';
import 'systems/score_system.dart';
import 'systems/spawn_system.dart';

class JungleMonkeyGame extends FlameGame with TapCallbacks {
  JungleMonkeyGame({
    required this.storage,
    required this.audio,
    this.autopilot = false,
    this.demoCollision = false,
    this.demoPause = false,
  });

  final ScoreStorage storage;
  final AudioService audio;
  final bool autopilot;
  final bool demoCollision;
  final bool demoPause;
  final ValueNotifier<GameSnapshot> snapshot = ValueNotifier(
    GameSnapshot.initial(),
  );
  final Completer<void> _loadCompleter = Completer<void>();
  final DifficultySystem _difficultySystem = DifficultySystem();
  final ScoreSystem _scoreSystem = ScoreSystem();
  final SpawnSystem _spawnSystem = SpawnSystem();
  final CollisionSystem _collisionSystem = const CollisionSystem();
  final ScreenShake _screenShake = ScreenShake();
  final List<Obstacle> _obstacles = [];
  final List<Collectible> _collectibles = [];

  late final JungleBackground _background;
  late final Ground _ground;
  late final Monkey _monkey;
  late final Map<ObstacleKind, ui.Image> _obstacleImages;
  late final Map<CollectionKind, ui.Image> _collectibleImages;

  GameStatus _status = GameStatus.home;
  int _bestScore = 0;
  double _elapsed = 0;
  double _countdown = 0;
  double _collisionTimer = 0;
  double _handLickTimer = 0;
  double _feedbackTimer = 0;
  String _feedback = '';
  bool _newBest = false;
  bool _demoPauseTriggered = false;
  bool _pausedFromCountdown = false;
  double _shakeX = 0;
  double _shakeY = 0;

  Future<void> get initialized => _loadCompleter.future;
  GameStatus get status => _status;
  double get groundY => size.y * 0.82;

  @override
  Color backgroundColor() => const Color(0xFF123D24);

  @override
  Future<void> onLoad() async {
    await images.loadAll([
      'environment/jungle_backdrop.png',
      'monkey/monkey_running.png',
      'obstacles/fallen_log.png',
      'obstacles/tree_root.png',
      'obstacles/jungle_rock.png',
      'obstacles/thorny_plant.png',
      'collectibles/coin.png',
      'collectibles/banana.png',
      'collectibles/golden_banana.png',
    ]);

    _background = JungleBackground(
      images.fromCache('environment/jungle_backdrop.png'),
    );
    _ground = Ground();
    _monkey = Monkey(images.fromCache('monkey/monkey_running.png'));
    _obstacleImages = {
      ObstacleKind.log: images.fromCache('obstacles/fallen_log.png'),
      ObstacleKind.root: images.fromCache('obstacles/tree_root.png'),
      ObstacleKind.rock: images.fromCache('obstacles/jungle_rock.png'),
      ObstacleKind.thornyPlant: images.fromCache('obstacles/thorny_plant.png'),
    };
    _collectibleImages = {
      CollectionKind.coin: images.fromCache('collectibles/coin.png'),
      CollectionKind.banana: images.fromCache('collectibles/banana.png'),
      CollectionKind.goldenBanana: images.fromCache(
        'collectibles/golden_banana.png',
      ),
    };
    _bestScore = await storage.loadBestScore();
    _resetWorld();
    _status = GameStatus.home;
    _publish();
    _loadCompleter.complete();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) {
      _monkey.reset(screenWidth: size.x, groundY: groundY);
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (_status == GameStatus.ready) {
      _beginRunningImmediately();
    }
    if (_status == GameStatus.running) jump();
  }

  Future<void> startSequence() async {
    await initialized;
    _resetWorld();
    _status = GameStatus.ready;
    _countdown = 3.2;
    _feedback = '';
    unawaited(audio.startMusic());
    _publish();
  }

  void jump() {
    if (_status == GameStatus.ready) {
      _beginRunningImmediately();
    }
    if (_status == GameStatus.running && _monkey.jump()) {
      audio.playJump();
    }
  }

  void _beginRunningImmediately() {
    if (_status != GameStatus.ready) return;
    _countdown = 0;
    _status = GameStatus.running;
    _monkey.startRunning();
    unawaited(audio.startMusic());
    _publish();
  }

  void pause() {
    if (_status != GameStatus.ready && _status != GameStatus.running) return;
    _pausedFromCountdown = _status == GameStatus.ready;
    _status = GameStatus.paused;
    unawaited(audio.pauseMusic());
    _publish();
  }

  void resume() {
    if (_status != GameStatus.paused) return;
    _status = _pausedFromCountdown ? GameStatus.ready : GameStatus.running;
    _pausedFromCountdown = false;
    unawaited(audio.resumeMusic());
    _publish();
  }

  Future<void> restart() => startSequence();

  void goHome() {
    _status = GameStatus.home;
    audio.stopMusic();
    _publish();
  }

  void _resetWorld() {
    _elapsed = 0;
    _countdown = 0;
    _collisionTimer = 0;
    _handLickTimer = 0;
    _feedbackTimer = 0;
    _feedback = '';
    _newBest = false;
    _demoPauseTriggered = false;
    _pausedFromCountdown = false;
    _obstacles.clear();
    _collectibles.clear();
    _scoreSystem.reset();
    _spawnSystem.reset();
    _background.reset();
    _ground.reset();
    _screenShake.reset();
    _monkey.reset(screenWidth: size.x, groundY: groundY);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isLoaded) return;

    final shake = _screenShake.update(dt);
    _shakeX = shake.x;
    _shakeY = shake.y;

    if (_feedbackTimer > 0) {
      _feedbackTimer -= dt;
      if (_feedbackTimer <= 0 && _status == GameStatus.running) {
        _feedback = '';
      }
    }

    switch (_status) {
      case GameStatus.ready:
        _updateReady(dt);
      case GameStatus.running:
        _updateRunning(dt);
      case GameStatus.collision:
        _updateCollision(dt);
      case GameStatus.handLick:
        _updateHandLick(dt);
      case GameStatus.home ||
          GameStatus.tutorial ||
          GameStatus.paused ||
          GameStatus.gameOver:
        break;
    }
  }

  void _updateReady(double dt) {
    _countdown -= dt;
    final label = _countdown > 2.1
        ? '3'
        : _countdown > 1.1
        ? '2'
        : _countdown > 0.15
        ? '1'
        : 'GO!';
    _monkey.update(
      dt,
      groundY: groundY,
      physicsEnabled: false,
      handLickMode: false,
    );
    if (_countdown <= 0) {
      _beginRunningImmediately();
    } else {
      _publish(countdownLabel: label);
    }
  }

  void _updateRunning(double dt) {
    _elapsed += dt;
    if (demoPause && !_demoPauseTriggered && _elapsed > 3.8) {
      _demoPauseTriggered = true;
      pause();
      return;
    }
    if (demoCollision && _elapsed > 4.8) {
      _handleCollision();
      return;
    }
    final difficulty = _difficultySystem.forElapsed(_elapsed);
    _background.update(dt, difficulty.speed);
    _ground.update(dt, difficulty.speed);
    _monkey.update(
      dt,
      groundY: groundY,
      physicsEnabled: true,
      handLickMode: false,
    );
    _applyAutopilot(difficulty.speed);

    final milestone = _scoreSystem.update(dt, difficulty.speed);
    if (milestone != null) _showFeedback(milestone.label, duration: 1.5);

    for (final request in _spawnSystem.update(
      dt,
      difficulty.speed,
      difficulty.spawnInterval,
    )) {
      if (request.isObstacle) {
        _obstacles.add(
          Obstacle(
            kind: request.obstacle!,
            image: _obstacleImages[request.obstacle]!,
            x: size.x + 50,
            groundY: groundY,
          ),
        );
      } else {
        _collectibles.add(
          Collectible(
            kind: request.collectible!,
            image: _collectibleImages[request.collectible]!,
            x: size.x + 95,
            y: groundY - 80 - request.heightFactor * 190,
          ),
        );
      }
    }

    for (final obstacle in _obstacles) {
      obstacle.update(dt, difficulty.speed);
      if (_collisionSystem.isObstacleHit(_monkey.bounds, obstacle.bounds)) {
        _handleCollision();
        return;
      }
    }
    _obstacles.removeWhere((item) => item.offscreen);

    for (final item in _collectibles) {
      item.update(dt, difficulty.speed);
      if (_collisionSystem.isCollectiblePickup(_monkey.bounds, item.bounds)) {
        final event = _scoreSystem.collect(item.kind);
        _showFeedback(event.label, duration: 1.0);
        audio.playCollect(item.kind);
        item.x = -100;
      }
    }
    _collectibles.removeWhere((item) => item.offscreen);

    _publish();
  }

  void _applyAutopilot(double speed) {
    if (!autopilot || !_monkey.isGrounded) return;
    for (final obstacle in _obstacles) {
      final distance = obstacle.x - (_monkey.position.x + _monkey.width);
      if (distance > 0 && distance < speed * 0.58 + 165) {
        _monkey.jump();
        return;
      }
    }
  }

  void _handleCollision() {
    _status = GameStatus.collision;
    _collisionTimer = 0.22;
    _monkey.collide();
    _screenShake.trigger();
    audio.playCollision();
    _showFeedback('OOPS!', duration: 0.8);
    _publish();
  }

  void _updateCollision(double dt) {
    _collisionTimer -= dt;
    _monkey.update(
      dt,
      groundY: groundY,
      physicsEnabled: false,
      handLickMode: false,
    );
    if (_collisionTimer <= 0) {
      _status = GameStatus.handLick;
      _handLickTimer = 1.35;
      _publish();
    }
  }

  void _updateHandLick(double dt) {
    _handLickTimer -= dt;
    _monkey.update(
      dt,
      groundY: groundY,
      physicsEnabled: false,
      handLickMode: true,
    );
    if (_handLickTimer <= 0) {
      unawaited(_finishRun());
    }
  }

  Future<void> _finishRun() async {
    final score = _scoreSystem.score;
    _newBest = score > _bestScore;
    if (_newBest) {
      _bestScore = score;
      try {
        await storage.saveBestScore(score);
      } catch (_) {
        // The Game Over screen must still appear when persistence fails.
      }
      audio.playNewBest();
    }
    _status = GameStatus.gameOver;
    audio.stopMusic();
    _publish();
  }

  void _showFeedback(String label, {required double duration}) {
    _feedback = label;
    _feedbackTimer = duration;
  }

  void _publish({String? countdownLabel}) {
    snapshot.value = GameSnapshot(
      status: _status,
      score: _scoreSystem.score,
      bestScore: _bestScore,
      distanceMeters: _scoreSystem.distanceMeters,
      countdownLabel:
          countdownLabel ?? (_status == GameStatus.ready ? '3' : ''),
      feedbackLabel: _feedback,
      isNewBest: _newBest,
    );
  }

  @override
  void render(ui.Canvas canvas) {
    super.render(canvas);
    if (!isLoaded) return;
    canvas.save();
    canvas.translate(_shakeX, _shakeY);
    final difficulty = _difficultySystem.forElapsed(_elapsed);
    _background.render(
      canvas,
      ui.Size(size.x, size.y),
      darkness: difficulty.atmosphereStrength,
    );
    _ground.render(
      canvas,
      ui.Size(size.x, size.y),
      groundY: groundY,
      amplitude: difficulty.terrainAmplitude,
    );

    for (final collectible in _collectibles) {
      collectible.render(canvas);
    }
    for (final obstacle in _obstacles) {
      obstacle.render(canvas);
    }
    _monkey.render(canvas);

    if (_status == GameStatus.collision) {
      canvas.drawRect(
        ui.Rect.fromLTWH(0, 0, size.x, size.y),
        ui.Paint()..color = const ui.Color(0x99FFFFFF).withValues(alpha: 0.28),
      );
    }
    canvas.restore();
  }

  @override
  void onRemove() {
    super.onRemove();
    snapshot.dispose();
  }
}
