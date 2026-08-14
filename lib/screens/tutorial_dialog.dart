import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../widgets/jungle_button.dart';

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({required this.onGotIt, super.key});

  final VoidCallback onGotIt;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(22),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: JungleTheme.glassPanel(color: JungleTheme.deepJungle),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/monkey/monkey_running.png',
              height: 132,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              'HOW TO PLAY',
              style: Theme.of(context).textTheme.displayMedium
                  ?.copyWith(color: JungleTheme.banana),
            ),
            const SizedBox(height: 18),
            const _TutorialLine(
              icon: Icons.forest_rounded,
              text: 'RUN THROUGH THE JUNGLE',
            ),
            const _TutorialLine(
              icon: Icons.touch_app_rounded,
              text: 'TAP TO JUMP',
            ),
            const _TutorialLine(
              icon: Icons.warning_amber_rounded,
              text: 'AVOID OBSTACLES',
            ),
            const _TutorialLine(
              icon: Icons.stars_rounded,
              text: 'COLLECT COINS AND BANANAS',
            ),
            const _TutorialLine(
              icon: Icons.emoji_events_rounded,
              text: 'BEAT YOUR BEST SCORE!',
            ),
            const SizedBox(height: 20),
            JungleButton(label: 'GOT IT!', primary: true, onPressed: onGotIt),
          ],
        ),
      ),
    );
  }
}

class _TutorialLine extends StatelessWidget {
  const _TutorialLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: JungleTheme.banana, size: 21),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
