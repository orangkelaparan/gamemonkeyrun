import 'dart:ui' as ui;

import '../systems/spawn_system.dart';

class Obstacle {
  Obstacle({
    required this.kind,
    required this.image,
    required this.x,
    required this.groundY,
  }) {
    switch (kind) {
      case ObstacleKind.log:
        width = 148;
        height = 72;
      case ObstacleKind.root:
        width = 125;
        height = 65;
      case ObstacleKind.rock:
        width = 110;
        height = 70;
      case ObstacleKind.thornyPlant:
        width = 100;
        height = 78;
    }
  }

  final ObstacleKind kind;
  final ui.Image image;
  double x;
  final double groundY;
  late final double width;
  late final double height;

  double get y => groundY - height;
  ui.Rect get bounds => ui.Rect.fromLTWH(x, y, width, height);
  bool get offscreen => x + width < -20;

  void update(double dt, double speed) => x -= speed * dt;

  void render(ui.Canvas canvas) {
    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      bounds,
      ui.Paint()..filterQuality = ui.FilterQuality.high,
    );
  }
}
