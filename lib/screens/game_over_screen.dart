import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../game/models/game_snapshot.dart';
import '../widgets/jungle_button.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({
    required this.snapshot,
    required this.onRunAgain,
    required this.onHome,
    super.key,
  });

  final GameSnapshot snapshot;
  final VoidCallback onRunAgain;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: JungleTheme.glassPanel(color: JungleTheme.darkUi),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (snapshot.isNewBest) ...[
                const Icon(
                  Icons.emoji_events_rounded,
                  size: 50,
                  color: JungleTheme.banana,
                ),
                const SizedBox(height: 6),
                Text(
                  'NEW BEST!',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(color: JungleTheme.banana),
                ),
              ],
              Text(
                'GAME OVER',
                style: Theme.of(context).textTheme.displayMedium
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 18),
              _ScoreRow(
                label: 'SCORE',
                value: snapshot.formattedScore,
                accent: JungleTheme.banana,
              ),
              const SizedBox(height: 8),
              _ScoreRow(
                label: 'BEST',
                value: snapshot.formattedBest,
                accent: JungleTheme.brightLeaf,
              ),
              const SizedBox(height: 6),
              Text(
                '${snapshot.distanceMeters} m through the jungle',
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 22),
              JungleButton(
                label: 'RUN AGAIN',
                icon: Icons.replay_rounded,
                primary: true,
                onPressed: onRunAgain,
              ),
              const SizedBox(height: 12),
              JungleButton(
                label: 'HOME',
                icon: Icons.home_rounded,
                onPressed: onHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
