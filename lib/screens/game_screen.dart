import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../game/jungle_monkey_game.dart';
import '../game/models/game_snapshot.dart';
import '../game/models/game_status.dart';
import '../widgets/jungle_button.dart';
import '../widgets/score_hud.dart';
import 'game_over_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({required this.game, required this.onHome, super.key});

  final JungleMonkeyGame game;
  final VoidCallback onHome;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.game.startSequence(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(game: widget.game),
          ValueListenableBuilder<GameSnapshot>(
            valueListenable: widget.game.snapshot,
            builder: (context, snapshot, _) => _GameOverlay(
              game: widget.game,
              snapshot: snapshot,
              onHome: widget.onHome,
            ),
          ),
        ],
      ),
    );
  }
}

class _GameOverlay extends StatelessWidget {
  const _GameOverlay({
    required this.game,
    required this.snapshot,
    required this.onHome,
  });

  final JungleMonkeyGame game;
  final GameSnapshot snapshot;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    final active =
        snapshot.status == GameStatus.ready ||
        snapshot.status == GameStatus.running;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (active) ScoreHud(snapshot: snapshot, onPause: game.pause),
        if (snapshot.countdownLabel.isNotEmpty &&
            snapshot.status == GameStatus.ready)
          IgnorePointer(
            ignoring: true,
            child: Center(
              child: Text(
                snapshot.countdownLabel,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 86,
                  color: JungleTheme.banana,
                  shadows: const [
                    Shadow(color: JungleTheme.soil, offset: Offset(0, 5)),
                  ],
                ),
              ),
            ),
          ),
        if (snapshot.feedbackLabel.isNotEmpty &&
            (snapshot.status == GameStatus.running ||
                snapshot.status == GameStatus.collision))
          IgnorePointer(
            ignoring: true,
            child: Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Text(
                snapshot.feedbackLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: JungleTheme.banana,
                  shadows: const [
                    Shadow(color: JungleTheme.soil, offset: Offset(0, 3)),
                  ],
                ),
              ),
            ),
          ),
        if (snapshot.status == GameStatus.paused)
          _PauseOverlay(game: game, onHome: onHome),
        if (snapshot.status == GameStatus.gameOver)
          GameOverScreen(
            snapshot: snapshot,
            onRunAgain: game.restart,
            onHome: onHome,
          ),
        if (snapshot.status == GameStatus.handLick)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 74,
            child: Text(
              'A quick hand clean-up...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

class _PauseOverlay extends StatelessWidget {
  const _PauseOverlay({required this.game, required this.onHome});

  final JungleMonkeyGame game;
  final VoidCallback onHome;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.48),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: JungleTheme.glassPanel(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PAUSED',
                  style: Theme.of(context).textTheme.displayMedium
                      ?.copyWith(color: JungleTheme.banana),
                ),
                const SizedBox(height: 20),
                JungleButton(
                  label: 'RESUME',
                  icon: Icons.play_arrow_rounded,
                  primary: true,
                  onPressed: game.resume,
                ),
                const SizedBox(height: 12),
                JungleButton(
                  label: 'RESTART',
                  icon: Icons.replay_rounded,
                  onPressed: game.restart,
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
      ),
    );
  }
}
