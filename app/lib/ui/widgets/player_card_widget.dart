import 'package:flutter/material.dart';
import '../../models/player_model.dart';
import '../theme/app_theme.dart';

class PlayerCardWidget extends StatelessWidget {
  final PlayerModel player;
  final bool isCurrentTurn;

  const PlayerCardWidget({
    super.key,
    required this.player,
    required this.isCurrentTurn,
  });

  @override
  Widget build(BuildContext context) {
    final color = player.color.color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCurrentTurn ? color.withValues(alpha: 0.15) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCurrentTurn ? color : const Color(0xFFE2E8F0),
          width: isCurrentTurn ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (isCurrentTurn)
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              player.name + (player.isBot ? ' 🤖' : ''),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isCurrentTurn ? FontWeight.w800 : FontWeight.w600,
                color: isCurrentTurn ? color : AppTheme.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '🏠${player.tokensHomeCount}/4',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
