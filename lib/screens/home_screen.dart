import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // ─── Load User Profile ─────────────────────────────────────────
  Future<void> _loadUserProfile() async {
    final profile = await _firebaseService.getUserProfileOnce();
    if (!mounted) return;
    setState(() {
      _userProfile = profile;
      _isLoading = false;
    });
  }

  // ─── Dynamic Greeting ──────────────────────────────────────────
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  // ─── User Display Name ─────────────────────────────────────────
  String _getUserName() {
    if (_userProfile != null && _userProfile!['name'] != null) {
      return _userProfile!['name'];
    }
    // Fallback to Firebase Auth display name or email
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? user?.email ?? 'User';
  }

  // ─── User Faculty ──────────────────────────────────────────────
  String _getFaculty() {
    if (_userProfile != null && _userProfile!['faculty'] != null) {
      return _userProfile!['faculty'];
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // ─── Header ─────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFFE0E0E0)
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _getUserName(),
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.black87,
                              ),
                            ),
                            if (_getFaculty().isNotEmpty)
                              Text(
                                _getFaculty(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isDark
                                      ? Colors.grey[500]
                                      : Colors.grey[600],
                                ),
                              ),
                          ],
                        ),

                        // ─── Profile Avatar ──────────────────────
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/profile'),
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: isDark
                                ? const Color(0xFF2C2C2C)
                                : const Color(0xFFF1F3F5),
                            child: Icon(
                              Icons.person,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 48),

                    // ─── Section Label ───────────────────────────
                    Text(
                      'Quick Access',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ─── 2x2 Grid Menu ───────────────────────────
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                        children: [
                          _buildMenuCard(
                            context,
                            title: 'Next Lecture',
                            icon: Icons.school_outlined,
                            route: '/next_lecture',
                            isDark: isDark,
                          ),
                          _buildMenuCard(
                            context,
                            title: 'Faculty Map',
                            icon: Icons.map_outlined,
                            route: '/map',
                            isDark: isDark,
                          ),
                          _buildMenuCard(
                            context,
                            title: 'Lecture Hall',
                            icon: Icons.meeting_room_outlined,
                            route: '/cabin',
                            isDark: isDark,
                          ),
                          _buildMenuCard(
                            context,
                            title: 'Time Table',
                            icon: Icons.calendar_month_outlined,
                            route: '/timetable',
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),

      // ─── Bottom Nav ──────────────────────────────────────────────
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }

  // ─── Menu Card Widget ──────────────────────────────────────────
  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with subtle background
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 26,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
