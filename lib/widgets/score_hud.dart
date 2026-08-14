import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../game/models/game_snapshot.dart';

class ScoreHud extends StatelessWidget {
  const ScoreHud({required this.snapshot, required this.onPause, super.key});

  final GameSnapshot snapshot;
  final VoidCallback onPause;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium
        ?.copyWith(color: Colors.white70, letterSpacing: 1.1);
    final valueStyle = Theme.of(context).textTheme.titleLarge
        ?.copyWith(color: Colors.white, letterSpacing: 1.5);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Row(
          children: [
            _ScorePill(
              label: 'SCORE',
              value: snapshot.formattedScore,
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
            const Spacer(),
            _ScorePill(
              label: 'BEST',
              value: snapshot.formattedBest,
              labelStyle: labelStyle,
              valueStyle: valueStyle,
            ),
            const SizedBox(width: 8),
            Semantics(
              button: true,
              label: 'Pause game',
              child: Material(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  onPressed: onPause,
                  tooltip: 'Pause game',
                  style: IconButton.styleFrom(
                    minimumSize: const Size(48, 48),
                    backgroundColor: JungleTheme.darkUi.withValues(alpha: 0.78),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.pause_rounded),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScorePill extends StatelessWidget {
  const _ScorePill({
    required this.label,
    required this.value,
    this.labelStyle,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: JungleTheme.glassPanel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
