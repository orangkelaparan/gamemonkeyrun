import 'dart:math' as math;

class ScreenShake {
  double _remaining = 0;
  double _duration = 0.35;
  double _strength = 0;
  double _time = 0;

  bool get isActive => _remaining > 0;

  void trigger({double duration = 0.35, double strength = 8}) {
    _duration = duration;
    _remaining = duration;
    _strength = strength;
    _time = 0;
  }

  void reset() {
    _remaining = 0;
    _time = 0;
  }

  ({double x, double y}) update(double dt) {
    if (_remaining <= 0) return (x: 0, y: 0);
    _remaining -= dt;
    _time += dt;
    final decay = (_remaining / _duration).clamp(0, 1);
    return (
      x: math.sin(_time * 78) * _strength * decay,
      y: math.cos(_time * 61) * _strength * 0.55 * decay,
    );
  }
}
