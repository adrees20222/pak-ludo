import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'player_setup_screen.dart';

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How to Play Pak Ludo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      icon: '🎯',
                      title: 'Objective',
                      body:
                          'Be the first player to move all 4 of your tokens from the base yard to the central Home Triangle by moving clockwise around the board track.',
                    ),
                    _buildSection(
                      icon: '🚪',
                      title: 'Getting Tokens Out',
                      body:
                          '• Roll a 6 on the die to release a token from the base to your starting square.\n• Rolling a 6 always grants an extra roll!\n• Note: Rolling three 6s in a row cancels your third roll and ends your turn.',
                    ),
                    _buildSection(
                      icon: '💥',
                      title: 'Capturing Opponents',
                      body:
                          '• If your token lands on a square occupied by an opponent\'s token (outside Safe Zones), the opponent is captured and sent back to their base!\n• Capturing an opponent grants an EXTRA dice roll.',
                    ),
                    _buildSection(
                      icon: '⭐',
                      title: 'Safe Zones',
                      body:
                          '• Squares marked with a Star ⭐ and the colored home column entry tiles are Safe Zones.\n• Tokens standing on Safe Zones CANNOT be captured.\n• Multiple tokens from any player can safely share the same star tile.',
                    ),
                    _buildSection(
                      icon: '🏁',
                      title: 'Winning the Match',
                      body:
                          '• Guide your tokens around the board and up your color\'s home column.\n• Exact rolls are required to enter the center home.\n• The first player to bring all 4 tokens home wins 1st place! 🥇',
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
                    );
                  },
                  child: const Text(
                    '🔥 Play Now!',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String icon,
    required String title,
    required String body,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textDark,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
