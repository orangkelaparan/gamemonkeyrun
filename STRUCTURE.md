# Jungle Monkey Run Architecture

## Runtime Ownership

```text
Flutter application
├── App shell and routes
├── Screens and overlays
├── Persistent preferences
└── Accessibility / Android integration

Flame game world
├── JungleMonkeyGame state machine
├── Monkey physics and pose animation
├── Spawn, score, difficulty, and collision systems
├── Scrolling terrain and ambient effects
└── Asset-backed sprites and procedural effects
```

The app has one source of truth for the current `GameStatus`. Flutter overlays observe changes from the game and never manipulate obstacle physics directly. The Flame game owns real-time values such as distance, speed, player position, and active world objects.

## Module Map

| Path | Responsibility |
| --- | --- |
| `lib/main.dart` | Initializes Flutter bindings, locks portrait orientation, loads preferences, and starts the application. |
| `lib/app/app.dart` | Defines the material theme and application entry. |
| `lib/app/theme.dart` | Centralizes the jungle palette, typography, gradients, shadows, and button treatment. |
| `lib/game/jungle_monkey_game.dart` | Flame root, state machine, game loop, spawning, render orchestration, input handling, and collision checks. |
| `lib/game/models/game_status.dart` | Declares the explicit user-visible gameplay states. |
| `lib/game/models/game_snapshot.dart` | Supplies the Flutter layer with read-only score, best score, countdown, feedback, and state data. |
| `lib/game/systems/difficulty_system.dart` | Maps elapsed time to speed, spawn cadence, visual atmosphere, and terrain amplitude. |
| `lib/game/systems/score_system.dart` | Computes distance score, collection awards, combo state, and milestone feedback. |
| `lib/game/systems/spawn_system.dart` | Uses a seeded random source and safe-distance calculation to schedule obstacles and collectibles. |
| `lib/game/systems/collision_system.dart` | Performs dependable rectangle-overlap checks with tunable hitbox insets. |
| `lib/game/components/monkey.dart` | Owns player physics, movement state, readable pose transforms, and jump lifecycle. |
| `lib/game/components/obstacle.dart` | Represents log, root, rock, and thorn variants with game-space collision bounds. |
| `lib/game/components/collectible.dart` | Represents coin, banana, and golden-banana rewards with bob and spin transforms. |
| `lib/game/components/jungle_background.dart` | Draws the generated backdrop with parallax drift, foliage layers, birds, and atmospheric tint. |
| `lib/game/components/ground.dart` | Draws safe, gently undulating terrain and dust accents. |
| `lib/game/effects/particles.dart` | Provides lightweight dust, sparkle, leaf, and collision impact effects. |
| `lib/game/effects/screen_shake.dart` | Produces a decaying camera offset during collision. |
| `lib/screens/home_screen.dart` | Branded landing screen and primary navigation. |
| `lib/screens/game_screen.dart` | Hosts `GameWidget` and state-aware overlays. |
| `lib/screens/game_over_screen.dart` | Displays a polished result card and restart / home actions. |
| `lib/screens/settings_screen.dart` | Toggles music and sound, plus tutorial reset. |
| `lib/screens/tutorial_dialog.dart` | Presents the first-launch instructions. |
| `lib/services/score_storage.dart` | Async local persistence for best score and preferences. |
| `lib/services/audio_service.dart` | Safe no-op capable audio preference service for the offline release. |
| `lib/widgets/score_hud.dart` | Uses game snapshots to render the score, best score, and pause button. |
| `lib/widgets/jungle_button.dart` | Reusable high-contrast game button. |

## State Machine

```text
HOME -> TUTORIAL -> READY -> RUNNING -> PAUSED
                        |          |
                        |          +-> COLLISION -> HAND_LICK -> GAME_OVER
                        +-> HOME
GAME_OVER -> READY | HOME
PAUSED -> RUNNING | READY | HOME
```

Input is accepted only while the game is `READY` or `RUNNING`. Collision stops simulation after a short impact pause. Restart always builds a fresh world state while retaining local preferences and high score.

## Performance Guardrails

The game uses a small object pool-like active list, restricts particles to a low fixed maximum, avoids game-loop Flutter rebuilds except for meaningful snapshot updates, and keeps gameplay art as bundled PNGs. There are no network calls, live services, or remote assets at runtime.

## Asset Hints

- The jungle backdrop fills the portrait viewport and is cropped with `BoxFit.cover`.
- The monkey renders around 145 pixels high in a 390×844 logical viewport.
- Obstacles render between 85 and 155 pixels wide along the ground.
- Coins render at 36 pixels square; bananas render 54×38 pixels; golden bananas render 64×44 pixels.
- The game keeps its main character near 28% of viewport width to preserve forward reaction time.
