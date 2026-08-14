import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';

enum MonkeyPose {
  idle,
  running,
  jumping,
  falling,
  landing,
  hit,
  handLick,
  gameOver,
}

class Monkey {
  Monkey(this.image);

  final ui.Image image;
  final Vector2 position = Vector2.zero();
  final Vector2 velocity = Vector2.zero();

  MonkeyPose pose = MonkeyPose.idle;
  double width = 132;
  double height = 172;
  double _poseTime = 0;
  double _runTime = 0;

  bool get isGrounded =>
      velocity.y.abs() < 0.01 &&
      pose != MonkeyPose.jumping &&
      pose != MonkeyPose.falling;

  ui.Rect get bounds => ui.Rect.fromLTWH(
    position.x + width * 0.19,
    position.y + height * 0.18,
    width * 0.64,
    height * 0.70,
  );

  void reset({required double screenWidth, required double groundY}) {
    width = screenWidth * 0.34;
    height = width * 1.30;
    position
      ..x = screenWidth * 0.17
      ..y = groundY - height;
    velocity.setZero();
    pose = MonkeyPose.idle;
    _poseTime = 0;
    _runTime = 0;
  }

  void startRunning() {
    if (pose == MonkeyPose.idle || pose == MonkeyPose.landing) {
      pose = MonkeyPose.running;
    }
  }

  bool jump() {
    if (!isGrounded ||
        pose == MonkeyPose.hit ||
        pose == MonkeyPose.handLick ||
        pose == MonkeyPose.gameOver) {
      return false;
    }
    velocity.y = -690;
    pose = MonkeyPose.jumping;
    _poseTime = 0;
    return true;
  }

  void collide() {
    velocity.setZero();
    pose = MonkeyPose.hit;
    _poseTime = 0;
  }

  void update(
    double dt, {
    required double groundY,
    required bool physicsEnabled,
    required bool handLickMode,
  }) {
    _poseTime += dt;
    _runTime += dt;

    if (handLickMode) {
      pose = MonkeyPose.handLick;
      velocity.setZero();
      position.y = groundY - height;
      return;
    }

    if (!physicsEnabled) return;

    if (!isGrounded ||
        pose == MonkeyPose.jumping ||
        pose == MonkeyPose.falling) {
      velocity.y += 1820 * dt;
      position.y += velocity.y * dt;
      if (velocity.y > 0 && pose == MonkeyPose.jumping) {
        pose = MonkeyPose.falling;
      }
      if (position.y >= groundY - height) {
        position.y = groundY - height;
        velocity.y = 0;
        pose = MonkeyPose.landing;
        _poseTime = 0;
      }
    } else if (pose == MonkeyPose.landing && _poseTime > 0.12) {
      pose = MonkeyPose.running;
    }
  }

  void render(ui.Canvas canvas) {
    final centerX = position.x + width / 2;
    final centerY = position.y + height / 2;
    final runBob = pose == MonkeyPose.running
        ? math.sin(_runTime * 16) * 3
        : 0.0;
    final jumpTilt = pose == MonkeyPose.jumping
        ? -0.10
        : pose == MonkeyPose.falling
        ? 0.10
        : 0.0;
    final handLickTilt = pose == MonkeyPose.handLick
        ? -0.30 + math.sin(_poseTime * 9) * 0.08
        : 0.0;
    final hitTilt = pose == MonkeyPose.hit ? 0.22 : 0.0;
    final scaleY = pose == MonkeyPose.landing ? 0.92 : 1.0;
    final scaleX = pose == MonkeyPose.landing ? 1.08 : 1.0;

    canvas.save();
    canvas.translate(centerX, centerY + runBob);
    canvas.rotate(jumpTilt + handLickTilt + hitTilt);
    canvas.scale(scaleX, scaleY);
    final destination = ui.Rect.fromCenter(
      center: ui.Offset.zero,
      width: width,
      height: height,
    );
    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      destination,
      ui.Paint()..filterQuality = ui.FilterQuality.high,
    );

    if (pose == MonkeyPose.handLick) {
      final handPaint = ui.Paint()
        ..color = const ui.Color(0xFFFFC486).withValues(alpha: 0.82);
      canvas.drawCircle(
        ui.Offset(width * 0.14, -height * 0.14),
        width * 0.075,
        handPaint,
      );
      final lickPaint = ui.Paint()
        ..color = const ui.Color(0xFFFF7B86)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawArc(
        ui.Rect.fromCenter(
          center: ui.Offset(width * 0.22, -height * 0.15),
          width: width * 0.18,
          height: height * 0.09,
        ),
        0.2,
        1.4,
        false,
        lickPaint,
      );
    }
    canvas.restore();
  }
}
