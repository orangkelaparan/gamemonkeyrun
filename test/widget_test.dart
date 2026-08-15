import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jungle_monkey_run/game/models/game_snapshot.dart';
import 'package:jungle_monkey_run/game/models/game_status.dart';
import 'package:jungle_monkey_run/screens/game_over_screen.dart';
import 'package:jungle_monkey_run/screens/home_screen.dart';
import 'package:jungle_monkey_run/screens/settings_screen.dart';
import 'package:jungle_monkey_run/screens/tutorial_dialog.dart';
import 'package:jungle_monkey_run/services/audio_service.dart';
import 'package:jungle_monkey_run/services/score_storage.dart';
import 'package:jungle_monkey_run/widgets/jungle_button.dart';
import 'package:jungle_monkey_run/widgets/score_hud.dart';

void main() {
  testWidgets('Bundled jungle music is a valid MP3 asset', (tester) async {
    final bytes = await rootBundle.load(
      'assets/audio/music/jungle_adventure_loop.mp3',
    );
    final data = bytes.buffer.asUint8List(
      bytes.offsetInBytes,
      bytes.lengthInBytes,
    );

    expect(data.length, greaterThan(100000));
    expect(data[0], 0xFF);
    expect(data[1] & 0xE0, 0xE0);
  });

  test('Audio preference configuration does not autoplay at startup', () async {
    final audio = AudioService();

    await audio.configure(music: true, sound: true);

    expect(audio.isInitialized, isFalse);
    expect(audio.lastError, isNull);
  });

  testWidgets('Jungle button exposes and triggers its action', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JungleButton(
            label: 'PLAY',
            primary: true,
            onPressed: () => pressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('PLAY'));
    await tester.pump();
    expect(pressed, isTrue);
  });

  testWidgets('Home controls invoke Play, tutorial, and settings callbacks', (
    tester,
  ) async {
    var playCount = 0;
    var tutorialCount = 0;
    var settingsCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(
          preferences: const GamePreferences(
            bestScore: 360,
            tutorialCompleted: true,
            musicEnabled: true,
            soundEnabled: true,
          ),
          onPlay: () => playCount++,
          onHowToPlay: () => tutorialCount++,
          onSettings: () => settingsCount++,
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('jungleButton:PLAY')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('jungleButton:HOW TO PLAY')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('jungleButton:SETTINGS')));
    await tester.pump();

    expect(playCount, 1);
    expect(tutorialCount, 1);
    expect(settingsCount, 1);
  });

  testWidgets('Tutorial Got It control invokes its callback', (tester) async {
    var completed = false;

    await tester.pumpWidget(
      MaterialApp(home: TutorialDialog(onGotIt: () => completed = true)),
    );

    await tester.tap(find.byKey(const ValueKey('jungleButton:GOT IT!')));
    await tester.pump();
    expect(completed, isTrue);
  });

  testWidgets('Pause HUD control invokes its callback', (tester) async {
    var paused = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScoreHud(
            snapshot: GameSnapshot.initial(),
            onPause: () => paused = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('pauseButton')));
    await tester.pump();
    expect(paused, isTrue);
  });

  testWidgets('Game Over controls invoke restart and home callbacks', (
    tester,
  ) async {
    var restarted = false;
    var returnedHome = false;
    const snapshot = GameSnapshot(
      status: GameStatus.gameOver,
      score: 410,
      bestScore: 410,
      distanceMeters: 216,
      countdownLabel: '',
      feedbackLabel: '',
      isNewBest: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameOverScreen(
            snapshot: snapshot,
            onRunAgain: () => restarted = true,
            onHome: () => returnedHome = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('jungleButton:RUN AGAIN')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('jungleButton:HOME')));
    await tester.pump();

    expect(restarted, isTrue);
    expect(returnedHome, isTrue);
  });

  testWidgets('Settings controls persist their intended values', (
    tester,
  ) async {
    final storage = _MemoryScoreStorage();
    final audio = AudioService();

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(
          storage: storage,
          audio: audio,
          initial: const GamePreferences(
            bestScore: 0,
            tutorialCompleted: true,
            musicEnabled: true,
            soundEnabled: true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(Switch).first);
    await tester.pump();
    await tester.tap(find.byType(Switch).last);
    await tester.pump();
    await tester.tap(find.text('SHOW AGAIN'));
    await tester.pump();

    expect(storage.musicEnabled, isFalse);
    expect(storage.soundEnabled, isFalse);
    expect(storage.tutorialCompleted, isFalse);
    expect(
      find.text('Tutorial will appear when you press PLAY.'),
      findsOneWidget,
    );
  });
}

class _MemoryScoreStorage extends ScoreStorage {
  _MemoryScoreStorage() : super.testing();

  bool musicEnabled = true;
  bool soundEnabled = true;
  bool tutorialCompleted = true;

  @override
  Future<void> setMusicEnabled(bool value) async {
    musicEnabled = value;
  }

  @override
  Future<void> setSoundEnabled(bool value) async {
    soundEnabled = value;
  }

  @override
  Future<void> setTutorialCompleted(bool value) async {
    tutorialCompleted = value;
  }
}
