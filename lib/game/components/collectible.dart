import 'dart:math' as math;
import 'dart:ui' as ui;

import '../systems/score_system.dart';

class Collectible {
  Collectible({
    required this.kind,
    required this.image,
    required this.x,
    required this.y,
  }) {
    switch (kind) {
      case CollectionKind.coin:
        width = 38;
        height = 38;
      case CollectionKind.banana:
        width = 58;
        height = 42;
      case CollectionKind.goldenBanana:
        width = 68;
        height = 48;
    }
  }

  final CollectionKind kind;
  final ui.Image image;
  double x;
  final double y;
  late final double width;
  late final double height;
  double _age = 0;

  ui.Rect get bounds =>
      ui.Rect.fromLTWH(x, y + math.sin(_age * 5) * 4, width, height);
  bool get offscreen => x + width < -20;

  void update(double dt, double speed) {
    _age += dt;
    x -= speed * dt;
  }

  void render(ui.Canvas canvas) {
    final target = bounds;
    canvas.save();
    canvas.translate(target.center.dx, target.center.dy);
    final rotation = kind == CollectionKind.coin
        ? _age * 5
        : math.sin(_age * 3) * 0.08;
    canvas.rotate(rotation);

    if (kind == CollectionKind.goldenBanana) {
      final glow = ui.Paint()
        ..color = const ui.Color(0xFFFFD447).withValues(alpha: 0.22)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 14);
      canvas.drawCircle(ui.Offset.zero, width * 0.52, glow);
    }

    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      ui.Rect.fromCenter(center: ui.Offset.zero, width: width, height: height),
      ui.Paint()..filterQuality = ui.FilterQuality.high,
    );
    canvas.restore();
  }
}
