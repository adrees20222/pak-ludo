import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF01411C),
            Color(0xFF0D6E38),
            Color(0xFF15803D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 6,
        children: [
          _buildLink('Portfolio', 'https://adrees2022.blogspot.com/'),
          _buildDivider(),
          _buildLink('Support', 'https://my-extension.blogspot.com/p/support.html'),
          _buildDivider(),
          _buildLink('Donate', 'https://my-extension.blogspot.com/p/donate.html'),
          _buildDivider(),
          _buildLink('Terms of Services', 'https://my-extension.blogspot.com/p/terms.html'),
          _buildDivider(),
          _buildLink('Privacy Policy', 'https://my-extension.blogspot.com/p/privacy-policy_15.html'),
        ],
      ),
    );
  }

  Widget _buildLink(String title, String url) {
    return InkWell(
      onTap: () => _launch(url),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: Colors.white70,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '•',
        style: TextStyle(color: Colors.white54, fontSize: 13),
      ),
    );
  }
}
