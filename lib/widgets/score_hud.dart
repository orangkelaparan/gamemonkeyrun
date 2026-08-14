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
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: onPause,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: JungleTheme.glassPanel(),
                  child: const Icon(Icons.pause_rounded, color: Colors.white),
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
