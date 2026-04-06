import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/auth_service.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await _firebaseService.getUserProfileOnce();
    if (!mounted) return;
    setState(() {
      _userProfile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ─── Header ───────────────────────────────────
                Container(
                  width: double.infinity,
                  height: 280,
                  color: isDark
                      ? const Color(0xFF2C2C2C)
                      : const Color(0xFFF1F3F5),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? const Color(0xFF3A3A3A)
                                : Colors.white,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: isDark
                                ? Colors.grey[400]
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Name
                        Text(
                          _userProfile?['name'] ?? 'User',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1A1A1A)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _userProfile?['role'] ?? 'User',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Profile Info ──────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        _buildProfileInfoRow(
                          icon: Icons.person_outline,
                          label: 'Name',
                          value: _userProfile?['name'] ?? '—',
                          isDark: isDark,
                        ),
                        _buildDivider(isDark),
                        _buildProfileInfoRow(
                          icon: Icons.school_outlined,
                          label: 'Faculty',
                          value: _userProfile?['faculty'] ?? '—',
                          isDark: isDark,
                        ),
                        _buildDivider(isDark),
                        _buildProfileInfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Contact',
                          value: _userProfile?['contact'] ?? '—',
                          isDark: isDark,
                        ),
                        _buildDivider(isDark),
                        _buildProfileInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          value: _userProfile?['email'] ?? '—',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

      // ─── Bottom Nav ────────────────────────────────────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }

  // ─── Profile Info Row ──────────────────────────────────────────
  Widget _buildProfileInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.grey[400] : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 16),

          // Label + Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Divider ───────────────────────────────────────────────────
  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
      thickness: 1,
      height: 1,
    );
  }
}
