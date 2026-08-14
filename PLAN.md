# Game Plan: Jungle Monkey Run

## Product Target

Jungle Monkey Run is an original, portrait-orientation, offline Android endless runner. Flutter owns application navigation, overlays, local preferences, accessibility semantics, and Android integration. Flame owns the real-time loop, asset rendering, input handling, collisions, spawning, and effects.

The primary interaction is deliberately simple: the player taps or swipes up to jump. The game escalates from a comfortable early pace to a demanding but fair late pace, while preserving a measurable safe gap between hazards.

## Risk Tasks

### 1. Responsive jump and safe obstacle generation

- **Why isolated:** Procedural hazards, speed growth, and jump timing can easily produce unwinnable runs if their constraints are not derived from the current speed and jump arc.
- **Approach:** Use a deterministic game model with `jumpVelocity`, gravity, grounded state, and obstacle rectangles. The spawner calculates a minimum horizontal gap using current speed, a reaction allowance, and a jump-clearance allowance. It never emits a second blocking obstacle before the prior obstacle's safe clearance boundary.
- **Verify:** A tap and an upward swipe each initiate one jump only while grounded; a completed jump returns the monkey to the ground without sinking; generated obstacle gaps remain above the calculated safe threshold at every speed tier.

### 2. Collision-to-game-over hand-lick sequence

- **Why isolated:** A single collision must cleanly stop gameplay, briefly freeze motion, show impact feedback, animate the monkey into a humorous hand-licking pose, and only then show the game-over overlay.
- **Approach:** Use explicit `GameStatus` values and timed phases: `running -> collisionFreeze -> handLick -> gameOver`. Spawn movement and score updates stop at collision. The monkey renderer moves from run to a stopped, rotated, hand-near-mouth pose while a short camera shake decays.
- **Verify:** Colliding with a log, root, rock, or thorn plant stops new spawns immediately; an impact flash appears; shake occurs for less than one second; the monkey visibly changes to the hand-lick pose before the Game Over overlay is exposed.

### 3. Offline progress and settings persistence

- **Why isolated:** Persisted best score, tutorial state, and sound settings need reliable behavior across a full application restart without blocking the first frame.
- **Approach:** Put all reads and writes behind `ScoreStorage`, backed by `SharedPreferencesAsync`. The home screen reads the cached view state while initial preferences load, and all state mutations write through the service.
- **Verify:** Score updates only when a run beats the previous best; tutorial completion and music/sound toggles survive an app relaunch; storage errors fall back to sensible in-memory defaults without a crash.

## Main Build

The application includes a branded home screen, a first-play tutorial, a short 3–2–1–GO start sequence, an in-game HUD, pause overlay, settings screen, game-over celebration, local high score, and original bundled illustrations. The Flame scene has a moving jungle backdrop, parallax-like drifting foliage, birds, falling leaves, terrain undulation, procedurally spawned obstacles, coin trails, normal bananas, rare golden bananas, distance scoring, collection feedback, milestones, and difficulty tiers.

- **Assets:** Generated jungle backdrop; original monkey runner; fallen log, root, rock, thorn-plant obstacle sprites; coin, banana, golden-banana sprites; launcher icon; visual-reference image. Runtime art is bundled under `assets/images/` and available offline.
- **Verify:**
  - Home, tutorial, settings, countdown, running, pause, collision, hand-lick, game-over, and restart flows operate through explicit states.
  - The monkey remains in the left-to-middle play region while forward objects move left at a smoothly accelerating speed.
  - Score uses an arcade five-digit display; coins award 10, bananas award 25, and golden bananas award 100.
  - HUD text has high contrast, clear touch targets, and stays inside safe areas.
  - No required runtime asset is fetched from a network location.
  - `flutter pub get`, formatting validation, analysis, widget/unit tests, and release APK build pass.
  - Android screenshots cover the home screen, tutorial, active run, paused state, collection feedback, and game-over state.

## Acceptance Checklist

| Area | Required proof |
| --- | --- |
| Gameplay | Jump, collectible rewards, collision, safe spawning, difficulty progression, terrain motion, pause, and restart work. |
| Character | The running monkey is visible, animated through procedural pose changes, and performs the hand-licking game-over sequence. |
| UI | All interface copy is English; branded home, tutorial, settings, HUD, and game-over views render correctly. |
| Persistence | Best score, tutorial completion, music preference, and sound preference are stored locally. |
| Android | Portrait 9:16 configuration, launcher icon, splash color, release APK, and GitHub Actions workflow are present. |
| Quality | Code is formatted, analyzed, tested, and built without blocking errors. |

## Out of Scope

This first production release deliberately omits online leaderboards, advertisements, account systems, remote configuration, paid content, and network-backed analytics so that it is entirely offline and lightweight.
