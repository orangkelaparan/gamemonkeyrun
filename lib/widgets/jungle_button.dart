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
    final backgroundColor = primary ? JungleTheme.banana : JungleTheme.forest;
    final foregroundColor = primary ? JungleTheme.darkUi : Colors.white;
    final style = ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(58),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: Colors.grey.shade700,
      disabledForegroundColor: Colors.white54,
      elevation: 5,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: Colors.white.withValues(alpha: primary ? 0.35 : 0.18),
        ),
      ),
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: icon == null
          ? ElevatedButton(
              key: ValueKey<String>('jungleButton:$label'),
              onPressed: onPressed,
              style: style,
              child: Text(label),
            )
          : ElevatedButton.icon(
              key: ValueKey<String>('jungleButton:$label'),
              onPressed: onPressed,
              style: style,
              icon: Icon(icon, size: 22),
              label: Text(label),
            ),
    );
  }
}
