import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widgets/bottom_nav_bar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String _appVersion = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  // ─── Load App Version ──────────────────────────────────────────
  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() {
      _appVersion = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  // ─── URL Launcher ──────────────────────────────────────────────
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Could not open link.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  // ─── Email Launcher ────────────────────────────────────────────
  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────────────────
            Container(
              width: double.infinity,
              height: 260,
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bolt,
                      size: 70,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Smart Faculty',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _appVersion.isNotEmpty
                          ? 'Version $_appVersion ($_buildNumber)'
                          : 'Version —',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─── App Info Section ────────────────────────────────
            _buildSectionLabel('App Info', isDark),
            _buildLinkRow(
              icon: Icons.info_outline,
              title: 'App Version',
              trailing: _appVersion.isNotEmpty ? 'v$_appVersion' : '—',
              isDark: isDark,
              onTap: null,
            ),
            _buildDivider(isDark),
            _buildLinkRow(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              isDark: isDark,
              onTap: () => _launchUrl('https://nsbm.ac.lk'),
            ),
            _buildDivider(isDark),
            _buildLinkRow(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              isDark: isDark,
              onTap: () => _launchUrl('https://nsbm.ac.lk'),
            ),

            const SizedBox(height: 24),

            // ─── Support Section ─────────────────────────────────
            _buildSectionLabel('Support', isDark),
            _buildLinkRow(
              icon: Icons.language_outlined,
              title: 'Visit Website',
              isDark: isDark,
              onTap: () => _launchUrl('https://nsbm.ac.lk'),
            ),
            _buildDivider(isDark),
            _buildLinkRow(
              icon: Icons.support_agent_outlined,
              title: 'Contact Support',
              isDark: isDark,
              onTap: () => _launchEmail('support@nsbm.ac.lk'),
            ),

            const SizedBox(height: 24),

            // ─── Development Section ─────────────────────────────
            _buildSectionLabel('Development', isDark),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2C2C)
                      : const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDevInfo('Project', 'IoT Smart Faculty App', isDark),
                    const SizedBox(height: 12),
                    _buildDevInfo('Module', 'IoT & Smart Systems', isDark),
                    const SizedBox(height: 12),
                    _buildDevInfo(
                      'Institution',
                      'NSBM Green University',
                      isDark,
                    ),
                    const SizedBox(height: 12),
                    _buildDevInfo('Year', '2024 / 2025', isDark),
                    const SizedBox(height: 16),
                    Divider(
                      color: isDark
                          ? const Color(0xFF3A3A3A)
                          : Colors.grey[300],
                    ),
                    const SizedBox(height: 12),

                    // ─── Team Members ──────────────────────────
                    Text(
                      'Development Team',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Add your team members here
                    _buildTeamMember('Hiranya', 'IoT & Backend', isDark),
                    const SizedBox(height: 8),
                    _buildTeamMember('Ravishan', 'Flutter & UI', isDark),
                    const SizedBox(height: 8),
                    _buildTeamMember('Chamath', 'Hardware & Sensors', isDark),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // ─── Bottom Nav ──────────────────────────────────────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }

  // ─── Section Label ─────────────────────────────────────────────
  Widget _buildSectionLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[500] : Colors.grey[500],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  // ─── Link Row ──────────────────────────────────────────────────
  Widget _buildLinkRow({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback? onTap,
    String? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDark ? Colors.grey[400] : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF1A1A1A),
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              )
            else if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
          ],
        ),
      ),
    );
  }

  // ─── Divider ───────────────────────────────────────────────────
  Widget _buildDivider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Divider(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        thickness: 1,
        height: 1,
      ),
    );
  }

  // ─── Dev Info Row ──────────────────────────────────────────────
  Widget _buildDevInfo(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Team Member Row ───────────────────────────────────────────
  Widget _buildTeamMember(String name, String role, bool isDark) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isDark ? const Color(0xFF3A3A3A) : Colors.white,
          child: Icon(
            Icons.person,
            size: 18,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
            Text(
              role,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
