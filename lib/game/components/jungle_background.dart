import 'dart:math' as math;
import 'dart:ui' as ui;

class JungleBackground {
  JungleBackground(this.image);

  final ui.Image image;
  double _scroll = 0;
  double _leafTime = 0;

  void reset() {
    _scroll = 0;
    _leafTime = 0;
  }

  void update(double dt, double speed) {
    _scroll += speed * dt;
    _leafTime += dt;
  }

  void render(ui.Canvas canvas, ui.Size size, {required double darkness}) {
    final source = ui.Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final destination = ui.Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawImageRect(
      image,
      source,
      destination,
      ui.Paint()..filterQuality = ui.FilterQuality.high,
    );

    final distantPaint = ui.Paint()
      ..color = const ui.Color(0x5527653C).withValues(alpha: darkness * 0.8);
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, size.width, size.height),
      distantPaint,
    );

    final parallaxPaint = ui.Paint()
      ..color = const ui.Color(0xCC123D24)
          .withValues(alpha: 0.30 + darkness * 0.12);
    for (var i = -1; i < 6; i += 1) {
      final x = ((i * 120.0) - (_scroll * 0.20 % 120)) - 30;
      canvas.drawOval(
        ui.Rect.fromLTWH(x, size.height * 0.66, 150, 130),
        parallaxPaint,
      );
    }

    final birdPaint = ui.Paint()
      ..color = const ui.Color(0x99314132)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 2;
    final birdX = size.width - (_scroll * 0.12 % (size.width + 80));
    final birdY = size.height * 0.29 + math.sin(_leafTime * 0.8) * 9;
    canvas.drawArc(
      ui.Rect.fromCenter(center: ui.Offset(birdX, birdY), width: 16, height: 9),
      math.pi,
      math.pi,
      false,
      birdPaint,
    );
    canvas.drawArc(
      ui.Rect.fromCenter(
        center: ui.Offset(birdX + 15, birdY),
        width: 16,
        height: 9,
      ),
      math.pi,
      math.pi,
      false,
      birdPaint,
    );

    final leafPaint = ui.Paint()..color = const ui.Color(0xAA69C75A);
    for (var i = 0; i < 6; i += 1) {
      final phase = (_leafTime * (0.22 + i * 0.035) + i * 0.71) % 1;
      final x =
          (i * size.width / 5 + math.sin(_leafTime + i) * 24) % size.width;
      final y = phase * size.height * 0.78 + 80;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(phase * math.pi * 4);
      canvas.drawOval(
        ui.Rect.fromCenter(center: ui.Offset.zero, width: 10, height: 5),
        leafPaint,
      );
      canvas.restore();
    }
  }
}
