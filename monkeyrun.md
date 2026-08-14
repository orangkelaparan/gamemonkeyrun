# MASTER PROMPT — JUNGLE MONKEY RUN ANDROID GAME

You are a senior mobile game developer, game designer, UI/UX designer, 2D game artist, audio designer, Android build engineer, and GitHub Actions DevOps engineer.

Create a complete, polished, production-ready Android endless runner game inspired by the gameplay simplicity of the Google Chrome “Dinosaur Game” that appears during a connection timeout, but do **not** copy Google’s visual assets, branding, characters, or copyrighted artwork.

The game must be an original game featuring a **monkey running through a lush tropical jungle**.

The entire game UI and all in-game text must use **English language**.

The project must be structured cleanly, compile successfully, and be ready to build through GitHub Actions.

---

## 1. GAME CONCEPT

Game title:

**JUNGLE MONKEY RUN**

Core concept:

The player controls a fast-running monkey escaping through a dangerous tropical jungle.

The gameplay starts simple and gradually becomes faster and more difficult.

The player must:

- Jump over obstacles.
- Avoid dangerous jungle objects.
- Collect coins.
- Collect bananas.
- Survive for as long as possible.
- Achieve the highest possible score.
- Beat the locally stored offline top score.

The gameplay should be immediately understandable:

**Run → Jump → Avoid → Collect → Survive → Get Faster → Beat High Score**

The game should feel:

- Fast.
- Funny.
- Responsive.
- Smooth.
- Lightweight.
- Addictive.
- Visually polished.
- Suitable for casual Android gaming.
- Easy to play with one hand.

Do not create unnecessary complicated game mechanics that interfere with the simple endless-runner experience.

---

# 2. GAME ENGINE

Use:

**Flutter + Flame Engine**

Recommended architecture:

- Flutter for Android application lifecycle, screen management, dialogs, storage, and UI overlays.
- Flame for gameplay rendering, game loop, collision detection, sprite animation, camera movement, particles, world objects, and game entities.

Use a modern stable Flutter version compatible with the repository.

Use a recent stable Flame version compatible with that Flutter version.

Do not use deprecated Flutter APIs.

Use clean architecture and separate game logic from Flutter UI.

Suggested structure:

```text
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── theme.dart
│   └── routes.dart
├── game/
│   ├── jungle_monkey_game.dart
│   ├── components/
│   │   ├── monkey.dart
│   │   ├── obstacle.dart
│   │   ├── coin.dart
│   │   ├── banana.dart
│   │   ├── jungle_background.dart
│   │   └── ground.dart
│   ├── systems/
│   │   ├── spawn_system.dart
│   │   ├── difficulty_system.dart
│   │   ├── score_system.dart
│   │   └── collision_system.dart
│   └── effects/
│       ├── particles.dart
│       └── screen_shake.dart
├── screens/
│   ├── home_screen.dart
│   ├── game_screen.dart
│   ├── game_over_screen.dart
│   └── tutorial_dialog.dart
├── services/
│   ├── score_storage.dart
│   └── audio_service.dart
└── widgets/
    ├── score_hud.dart
    ├── pause_button.dart
    └── tutorial_card.dart
```

Keep the architecture maintainable and easy to extend.

---

# 3. GAME ORIENTATION

Use:

**Portrait orientation**

Target:

**9:16**

The gameplay area should adapt cleanly to different Android screen sizes.

Support:

- Small phones.
- Normal phones.
- Large phones.
- Modern edge-to-edge Android screens.

Avoid important gameplay elements being hidden underneath system bars.

---

# 4. VISUAL STYLE

Create a premium stylized 2D jungle environment.

The visual style should look like:

**Polished 2D illustrated mobile game with subtle realism**

Do not make the game look like a basic programmer prototype.

Use:

- Rich jungle greenery.
- Layered foliage.
- Depth.
- Soft lighting.
- Atmospheric background.
- Subtle shadows.
- Slightly glossy collectible objects.
- Smooth animation.

The world should feel alive.

Add subtle environmental animation:

- Leaves moving.
- Grass moving.
- Small insects flying.
- Birds in the distance.
- Occasional falling leaves.
- Slight background parallax.
- Light rays through jungle canopy.

Do not overload the screen with effects.

Gameplay visibility must always remain excellent.

---

# 5. COLOR PALETTE

Use a jungle-focused palette.

Primary colors:

- Deep Jungle Green: `#123D24`
- Forest Green: `#1F6B3A`
- Leaf Green: `#3E9B4F`
- Bright Jungle Green: `#69C75A`
- Moss Green: `#789B43`
- Earth Brown: `#6B4527`
- Dark Soil: `#3B2719`
- Banana Yellow: `#FFD447`
- Coin Gold: `#F5B82E`
- Sky Light Green: `#BDE7A5`
- White: `#FFFFFF`
- Dark UI: `#172016`

The environment should use darker colors in the foreground and lighter colors in the distant background to create depth.

The monkey must contrast strongly against the jungle.

Collectible objects must visually pop from the environment.

---

# 6. MAIN CHARACTER — MONKEY

Create an original monkey character.

Character concept:

A playful athletic jungle monkey.

Appearance:

- Medium-sized brown monkey.
- Warm brown fur.
- Slightly lighter face and chest.
- Large expressive eyes.
- Small rounded ears.
- Long curved tail.
- Strong arms and legs.
- Friendly but energetic facial expression.

The monkey should feel cute but not childish.

Use proportions appropriate for an endless runner.

The monkey must have clear readable animation silhouettes.

Create at minimum:

1. Idle animation.
2. Running animation.
3. Jump animation.
4. Falling animation.
5. Landing animation.
6. Hit animation.
7. Game-over animation.
8. Hand-licking animation.

Animation should be smooth at approximately 60 FPS.

---

# 7. SPECIAL GAME OVER ANIMATION

This is an important signature feature.

When the monkey hits an obstacle:

- Stop forward gameplay movement immediately.
- Stop spawning new obstacles.
- Freeze the game momentarily for approximately 150–250 ms.
- Add a subtle impact effect.
- Slightly shake the camera.
- Monkey falls or stops.
- Monkey looks disappointed.
- Then transition into a humorous animation where the monkey **sits/stops and licks its hand**.

The hand-licking animation should be funny and recognizable.

Sequence:

```text
RUN
↓
COLLISION
↓
IMPACT
↓
MONKEY STOPS
↓
MONKEY LOOKS AT HAND
↓
MONKEY LICKS HAND
↓
GAME OVER UI
```

Do not make the collision violent.

Keep it humorous and family-friendly.

---

# 8. GAMEPLAY CONTROLS

Primary control:

**Tap anywhere on the gameplay screen to jump.**

Optional secondary control:

Allow a swipe-up gesture for jumping if it can be implemented without complicating the control system.

Controls must be extremely responsive.

Do not require virtual joystick controls.

The player should be able to play comfortably with one thumb.

---

# 9. JUNGLE WORLD

The jungle should consist of multiple visual layers.

Background:

- Bright green jungle atmosphere.
- Distant trees.
- Mountain silhouettes or distant jungle terrain.
- Mist.
- Sunlight.
- Birds.

Midground:

- Large jungle trees.
- Vines.
- Bushes.
- Palm leaves.
- Ferns.

Foreground:

- Ground.
- Grass.
- Stones.
- Roots.
- Fallen branches.
- Small plants.

Use parallax scrolling.

Suggested layers:

```text
Sky / Atmosphere
↓
Distant Jungle
↓
Large Trees
↓
Midground Plants
↓
Foreground Plants
↓
Ground
↓
Player
↓
Obstacles
↓
Collectibles
```

The foreground should move faster than the background.

---

# 10. GROUND DESIGN

The path must NOT remain perfectly flat.

The jungle road should naturally move:

- Up.
- Down.
- Slight slopes.
- Small hills.
- Small dips.

Do NOT create impossible steep slopes.

The gameplay path must remain readable.

Terrain changes should begin gradually.

Early gameplay:

Mostly flat.

Mid gameplay:

Introduce gentle slopes.

Late gameplay:

Use more frequent terrain variation.

The terrain should visually communicate elevation changes.

---

# 11. OBSTACLES

Create multiple original jungle obstacles.

At minimum include:

### Fallen Log

Large brown log lying across the path.

Player must jump over it.

### Tree Root

Large exposed root crossing the running path.

Requires jumping.

### Rock

Large jungle rock.

Can appear in different sizes.

### Small Bush

Dense bush occupying part of the running path.

### Thorny Plant

Dangerous-looking jungle plant.

### Broken Branch

Low branch/log obstacle.

### Mud Patch

A slippery dark jungle mud area.

Instead of instantly causing a collision, it may temporarily slow the monkey during early difficulty levels.

Later variants can become more dangerous.

### Hanging Vine

Optional decorative or gameplay obstacle.

Use carefully because gameplay readability is important.

---

# 12. OBSTACLE SPAWNING

Obstacles must be procedurally generated.

Do not use a fixed repeating sequence.

Create a spawn system that:

- Randomizes obstacle selection.
- Randomizes safe spacing.
- Randomizes obstacle combinations.
- Prevents impossible combinations.
- Maintains fair reaction time.

Never spawn an obstacle combination that makes jumping impossible.

Avoid situations such as:

```text
Obstacle
+ obstacle directly after obstacle
+ impossible jump distance
```

The game must always remain skill-based rather than random punishment.

---

# 13. DIFFICULTY SYSTEM

The game starts slowly.

As the player survives longer, speed gradually increases.

Example progression:

```text
0–15 seconds
Easy

15–30 seconds
Normal

30–60 seconds
Fast

60–90 seconds
Very Fast

90+ seconds
Extreme
```

Do not abruptly increase difficulty.

Increase:

- World speed.
- Obstacle frequency.
- Obstacle combinations.
- Terrain variation.
- Required reaction speed.

Gradually decrease the average spacing between obstacles.

The difficulty curve must feel smooth.

---

# 14. SPEED SYSTEM

Start at a comfortable running speed.

For example:

```text
Base Speed: 250
Maximum Speed: 700
```

The exact values should be adjusted based on actual screen dimensions and playtesting.

Increase speed gradually according to distance or time survived.

Do not let speed become so fast that the player cannot realistically react.

---

# 15. SCORE SYSTEM

Primary score should be based on distance survived.

For example:

```text
+1 score every small unit of distance
```

Display:

```text
SCORE 001245
```

Use leading zeros to create a classic arcade feeling.

Add bonus points for collectibles.

Example:

```text
Coin = +10
Banana = +25
Rare Golden Banana = +100
```

The exact values can be tuned during testing.

---

# 16. COINS

Coins are collectible items.

Design:

- Golden.
- Slightly glossy.
- Circular.
- Jungle-themed embossed center.
- Subtle shine.
- Small rotating animation.

Coin collection animation:

- Coin spins.
- Bright sparkle.
- Small particle burst.
- Score increases.
- Short collection sound.

Coins should be placed in interesting patterns:

```text
Straight line
Arc
Stair pattern
Small jump trail
Risk/reward pattern
```

---

# 17. BANANAS

Bananas are a signature collectible.

Design:

- Bright yellow.
- Slightly realistic banana shape.
- Small glossy highlight.
- Subtle rotation/bounce.

Bananas should award more points than normal coins.

Example:

```text
BANANA +25
```

Rarely spawn special golden bananas.

Golden banana:

- Golden yellow.
- Strong glow.
- Sparkle effect.
- Higher score.

---

# 18. COMBO / COLLECTION FEEL

Create satisfying collection feedback.

When the player collects multiple objects quickly:

- Slight score animation.
- Small floating text.
- Particle effects.
- Optional combo counter.

Example:

```text
+10
+10
+25
COMBO x4
```

Keep this feature subtle.

Do not make the HUD cluttered.

---

# 19. HUD

The gameplay HUD must be minimal.

Top-left:

```text
SCORE
001245
```

Top-right:

```text
BEST
006732
```

Optional pause icon in the top-right corner beside the score area.

HUD should use a bold readable arcade-style font.

Use a subtle dark translucent background if necessary for readability.

---

# 20. HOME SCREEN

Create a polished jungle-themed home screen.

Main logo:

**JUNGLE MONKEY RUN**

Main character should be visible.

Background:

- Tropical jungle.
- Layered trees.
- Light fog.
- Leaves.
- Monkey in a running pose.

Main buttons:

```text
PLAY
HOW TO PLAY
SETTINGS
```

Buttons should be large and touch-friendly.

Primary PLAY button should visually stand out.

---

# 21. FIRST-TIME TUTORIAL

On the first launch only, display a tutorial popup before starting the game.

Tutorial title:

**HOW TO PLAY**

Content:

```text
RUN THROUGH THE JUNGLE

TAP TO JUMP

AVOID OBSTACLES

COLLECT COINS AND BANANAS

RUN AS FAR AS YOU CAN!

BEAT YOUR BEST SCORE!
```

Show a simple monkey jump illustration.

Include:

**GOT IT!**

Store a local flag indicating that the tutorial has been completed.

Do not show the tutorial every time the player starts the game.

Add an option in Settings to:

**SHOW TUTORIAL AGAIN**

---

# 22. GAME OVER SCREEN

After the monkey stops and performs the hand-licking animation, display a polished game-over overlay.

Title:

**GAME OVER**

Show:

```text
SCORE
001245

BEST
006732
```

If a new record is achieved:

```text
NEW BEST!
```

Add subtle celebration particles.

Buttons:

```text
RUN AGAIN
HOME
```

If the player beats the previous score, clearly celebrate the achievement.

---

# 23. OFFLINE HIGH SCORE

The game must support offline high-score persistence.

Use local device storage.

Suitable options:

- SharedPreferences
- Hive
- SharedPreferences + simple service layer

Store:

```text
best_score
tutorial_completed
sound_enabled
music_enabled
```

The high score must remain available after:

- Closing the game.
- Restarting the phone.
- Relaunching the application.

No internet connection is required.

The game must work completely offline.

Do not implement online leaderboards unless specifically requested later.

---

# 24. AUDIO

Create a strong audio experience.

Sound effects:

- Jump.
- Land.
- Coin collect.
- Banana collect.
- Rare golden banana.
- Collision.
- New high score.
- Button click.

Background music:

Use an energetic but relaxing jungle/adventure loop.

Music style:

- Light percussion.
- Jungle ambience.
- Wooden percussion.
- Soft tropical instruments.
- Energetic rhythm.

The music must increase the sense of adventure without becoming annoying.

Provide Settings controls:

```text
Music ON/OFF
Sound ON/OFF
```

---

# 25. JUNGLE AMBIENCE

Add subtle ambient sounds:

- Birds.
- Insects.
- Leaves.
- Wind.
- Distant animals.

Keep ambience subtle.

Do not overpower gameplay sound effects.

---

# 26. VISUAL EFFECTS

Use lightweight effects appropriate for mobile.

Examples:

- Coin sparkle.
- Banana sparkle.
- Dust particles when running.
- Small landing dust.
- Collision impact.
- Leaf particles.
- Golden banana glow.
- New record celebration.

Avoid expensive shader effects that significantly increase GPU usage.

Target:

**Smooth 60 FPS on mid-range Android devices.**

---

# 27. CAMERA

Implement a simple side-scrolling camera.

Camera should follow the gameplay world naturally.

The monkey should remain approximately in the left-to-middle region of the screen.

Do not center the character too aggressively.

The player should have enough visibility to anticipate obstacles.

---

# 28. GAME FEEL

The game must feel responsive.

Important priorities:

1. Jump responsiveness.
2. Collision fairness.
3. Clear obstacle visibility.
4. Smooth acceleration.
5. Satisfying collectible feedback.
6. Smooth animation.
7. Fast restart.

Restarting a run should take only a few taps.

---

# 29. LOGO DESIGN

Create an original logo for:

**JUNGLE MONKEY RUN**

Logo design:

- Bold arcade lettering.
- Rounded but energetic typography.
- Jungle leaf accents.
- Slight 3D depth.
- Soft glossy highlights.
- Dark green outer stroke.
- Warm yellow/orange highlight accents.
- Small tropical leaf details.
- Monkey silhouette integrated subtly into the logo.

The logo should be recognizable even at small sizes.

Do not use the Google Chrome dinosaur logo.

Do not use Google branding.

Do not copy any existing game logo.

---

# 30. GAME FONT

Use a bold, playful, highly readable display font.

Recommended style:

**Baloo 2 / Fredoka / Nunito ExtraBold / equivalent open-source font**

Use:

- Heavy weight for titles.
- Bold weight for buttons.
- Medium/bold for score.
- Avoid thin fonts.

Font characteristics:

- Rounded.
- Friendly.
- Arcade-like.
- Easy to read on small mobile screens.

Ensure the selected font is legally usable and included properly in the project.

---

# 31. UI DESIGN

UI should have:

- Rounded corners.
- Soft shadows.
- Slight glass/translucent effects where appropriate.
- Jungle-themed decorative leaves.
- Strong visual hierarchy.
- Large touch targets.

Buttons:

```text
PLAY
HOW TO PLAY
SETTINGS
RUN AGAIN
HOME
```

Use consistent spacing.

Do not make the interface look like a generic Flutter application.

The interface should look like a real mobile game.

---

# 32. SETTINGS SCREEN

Create a simple settings screen.

Options:

```text
Music     ON/OFF
Sound     ON/OFF
Tutorial  SHOW AGAIN
```

Also display:

```text
JUNGLE MONKEY RUN
Version 1.0.0
```

Include:

**BACK**

Keep it simple.

---

# 33. GAME STATES

Implement a clear game-state system.

States:

```text
HOME
TUTORIAL
READY
RUNNING
PAUSED
COLLISION
GAME_OVER
```

Transitions must be robust.

Prevent gameplay input from affecting the wrong state.

---

# 34. START SEQUENCE

When PLAY is pressed:

Display a short countdown:

```text
3
2
1
GO!
```

Then start running.

The countdown should be fast and unobtrusive.

---

# 35. PAUSE SYSTEM

Add a pause button.

When paused:

Display:

```text
PAUSED

RESUME
RESTART
HOME
```

Freeze gameplay completely while paused.

Audio should also pause or duck appropriately.

---

# 36. PERFORMANCE

Optimize the game for Android.

Important requirements:

- Avoid unnecessary object allocation.
- Use sprite/component reuse where practical.
- Avoid memory leaks.
- Keep asset sizes reasonable.
- Compress images appropriately.
- Avoid excessive particle count.
- Keep frame rate smooth.
- Avoid unnecessary Flutter rebuilds during gameplay.
- Keep game logic primarily inside Flame.

Target smooth performance on mid-range Android phones.

---

# 37. ACCESSIBILITY

Use readable text.

Ensure important controls have enough contrast.

Buttons must have comfortable touch areas.

Do not rely exclusively on tiny icons.

---

# 38. ERROR HANDLING

Handle:

- Missing assets.
- Missing audio.
- Local storage errors.
- App lifecycle changes.
- Pause/resume.
- Orientation changes if applicable.

The game must fail gracefully rather than crashing.

---

# 39. ANDROID CONFIGURATION

Create a proper Android application.

Use a professional package identifier, for example:

```text
com.aksisoft.junglemonkeyrun
```

Use the repository's existing package identifier if one already exists and changing it would break the project.

Configure:

- Android SDK.
- Minimum supported Android version.
- Target SDK compatible with current Flutter/Android tooling.
- App launcher icon.
- Splash screen.
- App name.

App name:

**Jungle Monkey Run**

---

# 40. APP ICON

Create a game icon featuring:

- Monkey face.
- Green jungle background.
- Bold silhouette.
- Yellow/orange accent.
- High contrast.
- No tiny text.

The icon must remain recognizable at small Android launcher sizes.

---

# 41. ASSET PIPELINE

Organize assets clearly:

```text
assets/
├── images/
│   ├── monkey/
│   ├── environment/
│   ├── obstacles/
│   ├── collectibles/
│   ├── ui/
│   └── logo/
├── audio/
│   ├── music/
│   ├── sfx/
│   └── ambience/
└── fonts/
```

Use optimized assets.

Do not reference external URLs for required game assets during runtime.

The game must be completely playable offline.

---

# 42. GAME LOGIC SAFETY

The procedural generation system must guarantee playable layouts.

Implement a minimum-safe-distance calculation.

For each new obstacle:

- Calculate player speed.
- Calculate expected jump capability.
- Calculate minimum reaction distance.
- Ensure sufficient gap from the previous obstacle.

Never generate impossible obstacle layouts.

---

# 43. CREATIVE DETAILS

Add polished details to make the game memorable.

Examples:

### Monkey Personality

Occasionally during idle moments:

- Monkey looks around.
- Monkey scratches its head.
- Monkey looks at the player.
- Monkey briefly swings its tail.

Do not interrupt gameplay.

### Jungle Animals

Occasionally show:

- Small birds.
- Butterflies.
- Distant monkey silhouettes.
- Tiny lizards.

These should be decorative and non-collidable unless specifically needed.

### Environment Progression

As distance increases, slightly change jungle atmosphere:

Early:

Bright tropical jungle.

Mid:

Denser jungle.

Late:

Darker, more dramatic jungle.

Extreme:

Strong green shadows, mist, intense speed sensation.

Do not make the environment so dark that obstacles become difficult to see.

---

# 44. DISTANCE MILESTONES

Add subtle milestone feedback.

Examples:

```text
100m
500m
1,000m
2,500m
5,000m
```

A small celebratory animation can appear when reaching major milestones.

Do not interrupt gameplay.

---

# 45. RANDOM EVENT SYSTEM

Optionally implement very rare harmless environmental events:

- Falling leaves.
- A bird flying across the background.
- A butterfly swarm.
- Distant animal movement.
- Sunlight beam changing.

These must not interfere with gameplay.

---

# 46. GAME BALANCE

The game should be:

Easy to learn.

Hard to master.

The first 10–20 seconds must feel accessible.

After that, difficulty should naturally increase.

A skilled player should be able to achieve very high scores.

Do not rely on unfair random collisions.

---

# 47. CODE QUALITY

Write production-quality code.

Requirements:

- Clean naming.
- Null safety.
- No unnecessary global state.
- Small maintainable classes.
- Reusable components.
- Comments only where useful.
- No dead code.
- No placeholder TODOs for core functionality.
- No mock gameplay.
- No fake buttons.
- No unfinished screens.

---

# 48. TESTING

Create appropriate tests.

Test at minimum:

- Score calculation.
- High-score persistence.
- Tutorial persistence.
- Coin collection.
- Banana collection.
- Collision detection.
- Difficulty increase.
- Game state transitions.

Also perform a real Android build.

---

# 49. GITHUB REPOSITORY WORKFLOW

This project already uses a GitHub repository.

Work directly inside the provided repository.

First:

1. Inspect the repository.
2. Identify the existing Flutter project.
3. Reuse the existing project structure where reasonable.
4. Do not overwrite unrelated applications or projects.
5. Inspect current dependencies.
6. Update dependencies only when necessary.

Then implement the entire game.

After implementation:

1. Run formatting.
2. Run static analysis.
3. Run tests.
4. Build the Android APK.
5. Fix all errors and warnings that block the build.
6. Re-run tests.
7. Verify the final APK exists.

Then create/update GitHub Actions.

---

# 50. GITHUB ACTIONS

Create:

```text
.github/workflows/android-build.yml
```

Workflow requirements:

- Trigger on push.
- Trigger on pull request.
- Use Ubuntu runner.
- Checkout repository.
- Install Java.
- Set up Flutter.
- Run Flutter pub get.
- Run formatting check.
- Run analyzer.
- Run tests.
- Build release APK.

Example workflow sequence:

```text
Checkout
↓
Setup Java
↓
Setup Flutter
↓
flutter pub get
↓
dart format --output=none --set-exit-if-changed .
↓
flutter analyze
↓
flutter test
↓
flutter build apk --release
↓
Upload APK artifact
```

Upload the generated APK as a GitHub Actions artifact.

Use a predictable artifact name such as:

```text
jungle-monkey-run-release-apk
```

---

# 51. BUILD REQUIREMENTS

The final project must successfully execute:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

Do not leave the repository in a broken state.

If the first build fails:

- Inspect the error.
- Fix the root cause.
- Re-run the failed command.
- Continue until successful.

Do not simply disable checks to hide errors.

---

# 52. GIT WORKFLOW

After the project is completed and verified:

Check:

```bash
git status
```

Review the changes.

Add only the intended files.

Commit with a clear message such as:

```text
feat: create Jungle Monkey Run endless runner
```

Then push the changes to the configured GitHub remote.

Use the repository's existing branch strategy.

Do not rewrite history.

Do not force push unless absolutely required and explicitly authorized.

After pushing:

- Verify GitHub Actions started.
- Inspect the workflow result.
- If the workflow fails, fix the issue.
- Commit the fix.
- Push again.
- Verify the workflow passes.

The final state must be:

**GitHub repository updated + GitHub Actions build passing.**

---

# 53. FINAL VERIFICATION

Before considering the task complete, verify:

### Gameplay

- Monkey runs correctly.
- Jump works.
- Collision works.
- Game-over animation works.
- Monkey licks its hand after collision.
- Coins work.
- Bananas work.
- Score works.
- Best score works.
- Speed increases.
- Obstacles become harder.
- Terrain moves up/down naturally.
- Restart works.
- Pause works.

### UI

- Home screen looks polished.
- Logo is visible.
- Tutorial appears on first launch.
- Tutorial does not repeatedly appear.
- Game-over screen works.
- Settings work.
- English text is used throughout.

### Storage

- Best score persists offline.
- Tutorial completion persists offline.
- Settings persist offline.

### Build

- flutter pub get succeeds.
- flutter analyze succeeds without blocking issues.
- flutter test succeeds.
- flutter build apk --release succeeds.
- GitHub Actions succeeds.

---

# 54. IMPORTANT CREATIVE DIRECTION

Do not produce a bare-minimum clone.

The game should feel like a professionally designed casual mobile game.

Prioritize:

**Fun + readability + smooth animation + satisfying game feel + polished jungle visuals.**

The visual identity should immediately communicate:

**“A fast, funny monkey running through a beautiful dangerous jungle.”**

The game should be recognizable from a single screenshot.

Make the monkey charming.

Make the jungle beautiful.

Make the obstacles readable.

Make collecting coins and bananas satisfying.

Make the increasing speed exciting.

Make the game-over hand-licking animation funny and memorable.

Keep the core gameplay as immediately understandable as the classic Chrome offline runner, while making the world, character, mechanics, visuals, animation, and branding completely original.

---

# 55. EXECUTION INSTRUCTION

Do not merely describe the implementation.

Actually implement the project in the GitHub repository.

Inspect the existing repository first.

Build the application.

Test it.

Fix errors.

Create or update GitHub Actions.

Commit the completed work.

Push it to GitHub.

Verify the GitHub Actions build succeeds.

At the end, report:

1. What was implemented.
2. Main technologies used.
3. Important files changed.
4. Git commit hash.
5. GitHub Actions workflow status.
6. APK artifact location.
7. Any remaining non-blocking warnings.

Do not claim success unless the repository and build were actually verified.