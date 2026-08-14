import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../services/audio_service.dart';
import '../services/score_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.storage,
    required this.audio,
    required this.initial,
    super.key,
  });

  final ScoreStorage storage;
  final AudioService audio;
  final GamePreferences initial;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _music = widget.initial.musicEnabled;
  late bool _sound = widget.initial.soundEnabled;
  String _message = '';

  Future<void> _toggleMusic(bool value) async {
    setState(() => _music = value);
    await widget.storage.setMusicEnabled(value);
    await widget.audio.configure(music: value, sound: _sound);
  }

  Future<void> _toggleSound(bool value) async {
    setState(() => _sound = value);
    await widget.storage.setSoundEnabled(value);
    await widget.audio.configure(music: _music, sound: value);
  }

  Future<void> _showTutorialAgain() async {
    await widget.storage.setTutorialCompleted(false);
    if (!mounted) return;
    setState(() => _message = 'Tutorial will appear when you press PLAY.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [JungleTheme.deepJungle, JungleTheme.forest],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SETTINGS',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(color: JungleTheme.banana),
                    ),
                  ],
                ),
                const Spacer(),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: JungleTheme.darkUi.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(22),
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          _SettingSwitch(
                            label: 'MUSIC',
                            value: _music,
                            onChanged: _toggleMusic,
                            icon: Icons.music_note_rounded,
                          ),
                          const Divider(color: Colors.white24),
                          _SettingSwitch(
                            label: 'SOUND',
                            value: _sound,
                            onChanged: _toggleSound,
                            icon: Icons.volume_up_rounded,
                          ),
                          const Divider(color: Colors.white24),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.school_rounded,
                              color: JungleTheme.banana,
                            ),
                            title: const Text(
                              'TUTORIAL',
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                            trailing: TextButton(
                              onPressed: _showTutorialAgain,
                              child: const Text('SHOW AGAIN'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_message.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    _message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: JungleTheme.sky,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  'JUNGLE MONKEY RUN\nVersion 1.0.0',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('BACK'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.icon,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      secondary: Icon(icon, color: JungleTheme.banana),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
      value: value,
      activeTrackColor: JungleTheme.brightLeaf,
      onChanged: onChanged,
    );
  }
}
