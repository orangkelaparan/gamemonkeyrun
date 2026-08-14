import 'dart:math' as math;
import 'dart:ui' as ui;

class Ground {
  double _scroll = 0;

  void reset() => _scroll = 0;

  void update(double dt, double speed) => _scroll += speed * dt;

  void render(
    ui.Canvas canvas,
    ui.Size size, {
    required double groundY,
    required double amplitude,
  }) {
    final path = ui.Path()..moveTo(0, groundY);
    for (double x = 0; x <= size.width + 8; x += 8) {
      final wave =
          math.sin((x + _scroll * 0.32) / 86) * amplitude +
          math.sin((x + _scroll * 0.13) / 35) * amplitude * 0.18;
      path.lineTo(x, groundY + wave);
    }
    path
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final earthPaint = ui.Paint()
      ..shader = ui.Gradient.linear(
        ui.Offset(0, groundY - 5),
        ui.Offset(0, size.height),
        const [ui.Color(0xFF8E5A2F), ui.Color(0xFF3B2719)],
      );
    canvas.drawPath(path, earthPaint);

    final grassPaint = ui.Paint()
      ..color = const ui.Color(0xFF69C75A)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = ui.StrokeCap.round;
    for (double x = 0; x <= size.width; x += 15) {
      final y = groundY + math.sin((x + _scroll * 0.32) / 86) * amplitude;
      canvas.drawLine(
        ui.Offset(x, y),
        ui.Offset(x + math.sin(_scroll * 0.02 + x) * 3, y - 8),
        grassPaint,
      );
    }

    final pebblePaint = ui.Paint()..color = const ui.Color(0xAA3B2719);
    for (var i = 0; i < 9; i += 1) {
      final x = (i * 67.0 - _scroll * 0.45) % (size.width + 30);
      final y = groundY + 28 + (i % 3) * 17;
      canvas.drawOval(ui.Rect.fromLTWH(x, y, 7, 4), pebblePaint);
    }
  }
}
