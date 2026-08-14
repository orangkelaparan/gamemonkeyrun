import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../services/score_storage.dart';
import '../widgets/jungle_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.preferences,
    required this.onPlay,
    required this.onHowToPlay,
    required this.onSettings,
    super.key,
  });

  final GamePreferences preferences;
  final VoidCallback onPlay;
  final VoidCallback onHowToPlay;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/environment/jungle_backdrop.png',
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  JungleTheme.deepJungle.withValues(alpha: 0.20),
                  JungleTheme.deepJungle.withValues(alpha: 0.80),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: JungleTheme.glassPanel(),
                      child: Text(
                        'BEST  ${preferences.bestScore.toString().padLeft(6, '0')}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    'JUNGLE',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: JungleTheme.banana,
                      shadows: const [
                        Shadow(
                          color: JungleTheme.soil,
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'MONKEY RUN',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 34,
                      shadows: const [
                        Shadow(
                          color: JungleTheme.soil,
                          offset: Offset(0, 4),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RUN • JUMP • COLLECT • SURVIVE',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: JungleTheme.sky, letterSpacing: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/images/monkey/monkey_running.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  JungleButton(
                    label: 'PLAY',
                    icon: Icons.play_arrow_rounded,
                    primary: true,
                    onPressed: onPlay,
                  ),
                  const SizedBox(height: 12),
                  JungleButton(
                    label: 'HOW TO PLAY',
                    icon: Icons.help_outline_rounded,
                    onPressed: onHowToPlay,
                  ),
                  const SizedBox(height: 12),
                  JungleButton(
                    label: 'SETTINGS',
                    icon: Icons.settings_rounded,
                    onPressed: onSettings,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
