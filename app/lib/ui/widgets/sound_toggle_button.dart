import 'package:flutter/material.dart';
import '../../game/sound_service.dart';
import '../theme/app_theme.dart';

class SoundToggleButton extends StatefulWidget {
  final Color? color;
  const SoundToggleButton({super.key, this.color});

  @override
  State<SoundToggleButton> createState() => _SoundToggleButtonState();
}

class _SoundToggleButtonState extends State<SoundToggleButton> {
  @override
  Widget build(BuildContext context) {
    final isMuted = SoundService.instance.isMuted;
    final primary = widget.color ?? AppTheme.primaryGreen;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: primary.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        iconSize: 22,
        tooltip: isMuted ? 'Unmute Audio' : 'Mute Audio',
        icon: Icon(
          isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          color: isMuted ? const Color(0xFF94A3B8) : primary,
        ),
        onPressed: () async {
          await SoundService.instance.toggleMute();
          setState(() {});
        },
      ),
    );
  }
}
