import 'package:flutter/material.dart';
import '../../models/player_model.dart';
import '../theme/app_theme.dart';

class VictoryDialog extends StatelessWidget {
  final List<PlayerModel> finishOrder;
  final VoidCallback onPlayAgain;
  final VoidCallback onClose;

  const VictoryDialog({
    super.key,
    required this.finishOrder,
    required this.onPlayAgain,
    required this.onClose,
  });

  String _formatTime(int ms) {
    if (ms <= 0) return '00:00';
    final seconds = (ms / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remSecs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 16,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 28),
                const Text(
                  'GAME FINISHED!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textDark,
                    letterSpacing: 0.5,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppTheme.textMuted),
                  onPressed: onClose,
                  tooltip: 'Close and Exit to Home',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: finishOrder.length,
                separatorBuilder: (context, index) => const Divider(height: 12),
                itemBuilder: (context, index) {
                  final player = finishOrder[index];
                  final rank = index + 1;
                  return _buildPlayerRow(player, rank);
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: onPlayAgain,
                    child: const Text(
                      'Play Again!',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textDark,
                      side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: onClose,
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(PlayerModel player, int rank) {
    String rankBadge;
    Color badgeColor;

    switch (rank) {
      case 1:
        rankBadge = '🥇 1st';
        badgeColor = const Color(0xFFEAB308);
        break;
      case 2:
        rankBadge = '🥈 2nd';
        badgeColor = const Color(0xFF94A3B8);
        break;
      case 3:
        rankBadge = '🥉 3rd';
        badgeColor = const Color(0xFFD97706);
        break;
      default:
        rankBadge = '4th';
        badgeColor = const Color(0xFF64748B);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              rankBadge,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: badgeColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: player.color.color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black45, width: 1),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              player.name + (player.isBot ? ' (Bot)' : ''),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppTheme.textDark,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            _formatTime(player.finishTimeMs),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
