import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_footer.dart';
import '../widgets/sound_toggle_button.dart';
import 'how_to_play_screen.dart';
import 'player_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // App Logo & Title
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryGreen.withValues(alpha: 0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/icon/app_icon.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => Container(
                                color: AppTheme.primaryGreen,
                                child: const Center(
                                  child: Text('🎲', style: TextStyle(fontSize: 42)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textDark,
                              letterSpacing: -0.5,
                            ),
                            children: [
                              TextSpan(text: 'Welcome to '),
                              TextSpan(
                                text: 'Pak Ludo',
                                style: TextStyle(color: AppTheme.primaryGreen),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'The classic, ad-free Ludo board game with local multiplayer and smart bot opponents',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: AppTheme.textMuted,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.primaryGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 6,
                                  shadowColor: AppTheme.primaryGreen.withValues(alpha: 0.5),
                                ),
                                icon: const Icon(Icons.play_arrow_rounded, size: 28),
                                label: const Text(
                                  'Play Now!',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppTheme.primaryGreen,
                                  side: const BorderSide(color: AppTheme.primaryGreen, width: 2),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                icon: const Icon(Icons.menu_book_rounded, size: 20),
                                label: const Text(
                                  'Rules',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // Available Everywhere Platform Links
                        const SizedBox(height: 10),
                        _buildPlatformsSection(),
                        const SizedBox(height: 24),

                        // Features List
                        _buildFeatureCard(
                          icon: '⚡',
                          title: 'Instant Play',
                          description: 'No sign-ups or logins. Jump straight into a match.',
                        ),
                        _buildFeatureCard(
                          icon: '🚫',
                          title: 'Zero Ads',
                          description: 'No pop-ups or unskippable videos between turns. Pure gameplay.',
                        ),
                        _buildFeatureCard(
                          icon: '🔒',
                          title: '100% Private',
                          description: 'Your game data stays on your device. No tracking or accounts.',
                        ),
                        _buildFeatureCard(
                          icon: '🤖',
                          title: 'Smart AI Bots',
                          description: 'Play solo against intelligent computer opponents or pass & play.',
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                // Footer
                const CustomFooter(),
              ],
            ),
            // Floating Sound Toggle
            const Positioned(
              top: 12,
              right: 16,
              child: SoundToggleButton(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {}
    }
  }

  Widget _buildPlatformsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            '🎮 Available Everywhere',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
        ),
        _buildPlatformCard(
          icon: '🌐',
          title: 'Web Version (Blogger)',
          subtitle: 'Play online at pak-ludo.blogspot.com',
          url: 'https://pak-ludo.blogspot.com/',
        ),
        _buildPlatformCard(
          icon: '🧩',
          title: 'Chrome Extension',
          subtitle: 'Install on Chrome Web Store',
          url: 'https://chromewebstore.google.com/detail/dmbglbhnkjeknkaiokpafonjbkcimgcb',
        ),
        _buildPlatformCard(
          icon: '📱',
          title: 'Android Releases',
          subtitle: 'Get latest APK on GitHub Releases',
          url: 'https://github.com/adrees20222/pak-ludo/releases',
        ),
        _buildPlatformCard(
          icon: '⭐',
          title: 'GitHub Repository',
          subtitle: 'Open source code & contributions',
          url: 'https://github.com/adrees20222/pak-ludo',
        ),
      ],
    );
  }

  Widget _buildPlatformCard({
    required String icon,
    required String title,
    required String subtitle,
    required String url,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => _launchUrl(url),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(icon, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.open_in_new_rounded,
                            size: 15,
                            color: AppTheme.textMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textMuted,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMuted,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
