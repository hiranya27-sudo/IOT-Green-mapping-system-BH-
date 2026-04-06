import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class CabinScreen extends StatefulWidget {
  const CabinScreen({super.key});

  @override
  State<CabinScreen> createState() => _CabinScreenState();
}

class _CabinScreenState extends State<CabinScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ───────────────────────────────────────────
            Text(
              'Lecture Hall',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'IoT Enabled — Live Controls',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),

            const SizedBox(height: 24),

            // ─── Location Info Card ───────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 24,
                      color: isDark
                          ? Colors.grey[400]
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lecture Hall A',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          'Floor 2 · Faculty of Computing',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // IoT live indicator
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ─── Section Label ────────────────────────────────────
            _buildSectionLabel('Sensor Data', isDark),
            const SizedBox(height: 12),

            // ─── Temperature Card ─────────────────────────────────
            StreamBuilder<double>(
              stream: _firebaseService.getTemperature(),
              builder: (context, snapshot) {
                final temp = snapshot.data ?? 0.0;
                final isConnected =
                    snapshot.connectionState == ConnectionState.active;
                return _buildSensorCard(
                  icon: Icons.thermostat_outlined,
                  title: 'Temperature',
                  value: isConnected ? '${temp.toStringAsFixed(1)}°C' : '—',
                  subtitle: _getTempStatus(temp),
                  isDark: isDark,
                );
              },
            ),

            const SizedBox(height: 12),

            // ─── Occupancy Card ───────────────────────────────────
            StreamBuilder<int>(
              stream: _firebaseService.getOccupancy(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                final isConnected =
                    snapshot.connectionState == ConnectionState.active;
                return _buildSensorCard(
                  icon: Icons.people_outline,
                  title: 'Occupancy',
                  value: isConnected ? '$count' : '—',
                  subtitle: _getOccupancyStatus(count),
                  isDark: isDark,
                );
              },
            ),

            const SizedBox(height: 32),

            // ─── Section Label ────────────────────────────────────
            _buildSectionLabel('Controls', isDark),
            const SizedBox(height: 12),

            // ─── Controls Card ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF2C2C2C)
                    : const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // ─── AC Control ─────────────────────────────────
                  StreamBuilder<bool>(
                    stream: _firebaseService.getACStatus(),
                    builder: (context, snapshot) {
                      final isOn = snapshot.data ?? false;
                      return _buildControlRow(
                        icon: Icons.ac_unit_outlined,
                        title: 'Air Conditioner',
                        subtitle: isOn ? 'Currently ON' : 'Currently OFF',
                        value: isOn,
                        isDark: isDark,
                        onChanged: (val) => _firebaseService.setAC(val),
                      );
                    },
                  ),

                  _buildDivider(isDark),

                  // ─── Lights Control ──────────────────────────────
                  StreamBuilder<bool>(
                    stream: _firebaseService.getLightsControlStatus(),
                    builder: (context, snapshot) {
                      final isOn = snapshot.data ?? false;
                      return _buildControlRow(
                        icon: Icons.lightbulb_outline,
                        title: 'Lights',
                        subtitle: isOn ? 'Currently ON' : 'Currently OFF',
                        value: isOn,
                        isDark: isDark,
                        onChanged: (val) => _firebaseService.setLights(val),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ─── Quick Navigate to Map ────────────────────────────
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/map'),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2C2C2C)
                      : const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 24,
                      color: isDark
                          ? Colors.grey[400]
                          : const Color(0xFF1A1A1A),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'View on Faculty Map',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? const Color(0xFFE0E0E0)
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── Temperature Status ────────────────────────────────────────
  String _getTempStatus(double temp) {
    if (temp == 0.0) return 'Sensor connecting...';
    if (temp < 18) return 'Too cold';
    if (temp <= 24) return 'Comfortable';
    if (temp <= 28) return 'Warm';
    return 'Too hot';
  }

  // ─── Occupancy Status ──────────────────────────────────────────
  String _getOccupancyStatus(int count) {
    if (count == 0) return 'Hall is empty';
    if (count <= 20) return 'Low occupancy';
    if (count <= 60) return 'Moderate occupancy';
    return 'High occupancy';
  }

  // ─── Sensor Card ───────────────────────────────────────────────
  Widget _buildSensorCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isDark ? Colors.grey[400] : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Control Row ───────────────────────────────────────────────
  Widget _buildControlRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: isDark ? Colors.grey[400] : const Color(0xFF1A1A1A),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  // ─── Section Label ─────────────────────────────────────────────
  Widget _buildSectionLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.grey[500] : Colors.grey[500],
        letterSpacing: 0.5,
      ),
    );
  }

  // ─── Divider ───────────────────────────────────────────────────
  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? const Color(0xFF3A3A3A) : Colors.grey[300],
      thickness: 1,
      height: 1,
    );
  }
}
