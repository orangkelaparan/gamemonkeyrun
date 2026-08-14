import 'package:flutter/material.dart';

import '../app/theme.dart';

class JungleButton extends StatelessWidget {
  const JungleButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.primary = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final colors = primary
        ? const [JungleTheme.banana, Color(0xFFFFA826)]
        : const [JungleTheme.forest, JungleTheme.deepJungle];
    final foregroundColor = primary ? JungleTheme.darkUi : Colors.white;

    return Semantics(
      key: ValueKey<String>('jungleButton:$label'),
      button: true,
      enabled: onPressed != null,
      label: label,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: Listener(
          behavior: HitTestBehavior.opaque,
          onPointerUp: onPressed == null ? null : (_) => onPressed!.call(),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: onPressed == null
                    ? [Colors.grey.shade700, Colors.grey.shade800]
                    : colors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withValues(alpha: primary ? 0.35 : 0.18),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: foregroundColor, size: 22),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
