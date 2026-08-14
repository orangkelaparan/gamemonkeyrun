import 'package:flutter/material.dart';

import '../game/jungle_monkey_game.dart';
import '../screens/game_screen.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/tutorial_dialog.dart';
import '../services/audio_service.dart';
import '../services/score_storage.dart';
import 'theme.dart';

class JungleMonkeyRunApp extends StatefulWidget {
  const JungleMonkeyRunApp({super.key});

  @override
  State<JungleMonkeyRunApp> createState() => _JungleMonkeyRunAppState();
}

class _JungleMonkeyRunAppState extends State<JungleMonkeyRunApp> {
  final ScoreStorage _storage = ScoreStorage();
  final AudioService _audio = AudioService();
  GamePreferences? _preferences;
  JungleMonkeyGame? _game;
  final bool _isDemo = Uri.base.queryParameters.containsKey('demo');
  final bool _demoCollision = Uri.base.queryParameters['collision'] == '1';
  final bool _demoPause = Uri.base.queryParameters['pause'] == '1';
  final bool _tutorialPreview = Uri.base.queryParameters['tutorial'] == '1';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final preferences = await _storage.loadPreferences();
    await _audio.configure(
      music: preferences.musicEnabled,
      sound: preferences.soundEnabled,
    );
    if (!mounted) return;
    setState(() {
      _preferences = preferences;
      if (_isDemo && _game == null) {
        _game = JungleMonkeyGame(
          storage: _storage,
          audio: _audio,
          autopilot: true,
          demoCollision: _demoCollision,
          demoPause: _demoPause,
        );
      }
    });
    if (_tutorialPreview) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showDialog<void>(
          context: context,
          builder: (context) =>
              TutorialDialog(onGotIt: () => Navigator.of(context).pop()),
        );
      });
    }
  }

  Future<void> _openGame() async {
    final preferences = await _storage.loadPreferences();
    if (!mounted) return;
    if (!preferences.tutorialCompleted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => TutorialDialog(
          onGotIt: () {
            _completeTutorial(context);
          },
        ),
      );
    }
    if (!mounted) return;
    setState(() => _game = JungleMonkeyGame(storage: _storage, audio: _audio));
  }

  Future<void> _completeTutorial(BuildContext dialogContext) async {
    await _storage.setTutorialCompleted(true);
    if (dialogContext.mounted) Navigator.of(dialogContext).pop();
  }

  Future<void> _showHowToPlay() async {
    await showDialog<void>(
      context: context,
      builder: (context) =>
          TutorialDialog(onGotIt: () => Navigator.of(context).pop()),
    );
  }

  Future<void> _openSettings() async {
    if (_preferences == null) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          storage: _storage,
          audio: _audio,
          initial: _preferences!,
        ),
      ),
    );
    await _loadPreferences();
  }

  void _returnHome() {
    _game?.goHome();
    setState(() => _game = null);
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jungle Monkey Run',
      debugShowCheckedModeBanner: false,
      theme: JungleTheme.build(),
      home: _preferences == null
          ? const _LoadingScreen()
          : _game != null
          ? GameScreen(game: _game!, onHome: _returnHome)
          : HomeScreen(
              preferences: _preferences!,
              onPlay: () {
                _openGame();
              },
              onHowToPlay: () {
                _showHowToPlay();
              },
              onSettings: () {
                _openSettings();
              },
            ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [JungleTheme.deepJungle, JungleTheme.forest],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: CircularProgressIndicator(color: JungleTheme.banana),
        ),
      ),
    );
  }
}
