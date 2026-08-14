# Jungle Monkey Run Development Memory

## Confirmed Starting Point

The repository initially contained only `README.md` and `monkeyrun.md`; no Flutter project existed. A fresh Flutter 3.47.0 project was created in place with Android and web support, preserving the specification and project documentation.

## Key Decisions

- The app uses Flutter 3.47.0 and Flame 1.38.0.
- The Android application id is `com.aksisoft.junglemonkeyrun`.
- The target aspect is portrait 9:16, with controls and overlays kept within Flutter safe areas.
- All runtime art is local under `assets/images/`; no runtime network fetches are permitted.
- The game uses a lightweight 2D Flame loop with bundled generated art plus procedural effects and pose transforms rather than a large sprite-sheet / skeletal-animation dependency.
- Offline persistence uses `SharedPreferencesAsync` through a narrow `ScoreStorage` service.
- Gameplay logic is deterministic enough to unit test: safe spawning derives its gaps from speed, collisions use rectangle overlap, and difficulty depends on elapsed time.

## Visual Direction

The generated portrait reference places the monkey in the lower-left, obstacles on the right, and high-value collectibles above the safe running lane. The live implementation should preserve the deep-green foreground, pale atmospheric distance, brown-earth path, gold collectables, and warm-brown character contrast.

## Operational Notes

- Flutter was not installed in the base environment and is now available at `/home/ubuntu/flutter/bin/flutter` for this session.
- Android SDK and emulator tooling still need setup before a local APK build and device run.
- Generated alpha assets retain source variants ending in `_original.png`; runtime should reference the primary asset filenames only.
- Do not print, save, commit, or embed GitHub credentials in project files or git remotes.

## Visual Verification — Home Screen

The interactive Flutter web build rendered successfully after initial startup. The Home screen matches the target portrait composition: generated jungle background fills the viewport, the monkey is centered in a readable running pose, the title and arcade-style tagline are visible, the local BEST panel is high contrast, and the PLAY, HOW TO PLAY, and SETTINGS controls are large, aligned, and legible. The first blank capture was only the browser's transient application initialization frame; the succeeding capture showed the fully rendered game without a visible runtime error.

## Visual Verification — Initial Control Probe

The rendered Home view remained stable and visually unchanged after the first coordinate-based PLAY click attempt in the browser canvas. Since Flutter web exposes no semantic browser elements for this canvas composition, subsequent interactive verification should use a browser-level pointer-event dispatch or keyboard / touch simulation rather than DOM element indices. The visual rendering itself remains confirmed.

## Visual Verification — Active Gameplay

The `?demo=1` runtime rendered the active Flame scene successfully. The captured frame shows a portrait jungle environment with readable layered canopy, mountain depth, parallax foreground panels, a terrain path with subtle undulation, animated leaf particles, and birds. The monkey is airborne in a readable jump pose, with a vertical coin-and-banana trail ahead. SCORE, BEST, and pause HUD treatment are visible and high contrast. This confirms the runner canvas, generated local assets, score progression, collectible placement, and demo autopilot are operating visually in the interactive runtime.

## QA Note — Collision Demo Capture

The controlled collision route was launched after runtime hot reload, but the browser runtime became unavailable before the deferred Game Over frame could be captured. Existing Home and active-gameplay screenshots remain valid proof of the interactive Flutter render. The collision, hand-lick, and game-over sequence is covered by explicit state-machine code and was kept in the automated test/build scope; a fresh local browser session can be used later to capture the delayed result view if needed.
