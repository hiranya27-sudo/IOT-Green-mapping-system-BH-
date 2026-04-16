import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/lecture_slot.dart';

class NextLectureScreen extends StatefulWidget {
  const NextLectureScreen({super.key});

  @override
  State<NextLectureScreen> createState() => _NextLectureScreenState();
}

class _NextLectureScreenState extends State<NextLectureScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  LectureSlot? _nextLecture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNextLecture();
  }

  Future<void> _loadNextLecture() async {
    final slot = await _firebaseService.getNextLecture();
    if (!mounted) return;
    setState(() {
      _nextLecture = slot;
      _isLoading = false;
    });
  }

  // ─── Get Day + Date String ─────────────────────────────────────
  String _getTodayString() {
    return DateFormat('EEEE, MMMM d').format(DateTime.now());
  }

  // ─── Time Until Lecture ────────────────────────────────────────
  String _getTimeUntil(String startTime) {
    final now = DateTime.now();
    final parts = startTime.split(':');
    final lectureTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
    final diff = lectureTime.difference(now);

    if (diff.isNegative) return 'In progress';
    if (diff.inMinutes < 60) return 'In ${diff.inMinutes} minutes';
    if (diff.inHours < 24) return 'In ${diff.inHours}h ${diff.inMinutes % 60}m';
    return 'Later today';
  }

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNextLecture,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Title ───────────────────────────────────
                    Text(
                      'Next Lecture',
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
                      _getTodayString(),
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.grey[500] : Colors.grey[500],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ─── No Lecture State ─────────────────────────
                    if (_nextLecture == null)
                      _buildNoLectureCard(isDark)
                    else ...[
                      // ─── Time Until Badge ───────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2C2C)
                              : const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _getTimeUntil(_nextLecture!.startTime),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ─── Lecture Card ───────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2C2C)
                              : const Color(0xFFF1F3F5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Subject
                            Text(
                              _nextLecture!.subject,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? const Color(0xFFE0E0E0)
                                    : const Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Time
                            _buildInfoRow(
                              icon: Icons.access_time_outlined,
                              label: 'Time',
                              value:
                                  '${_nextLecture!.startTime} – ${_nextLecture!.endTime}',
                              isDark: isDark,
                            ),
                            const SizedBox(height: 14),

                            // Venue
                            _buildInfoRow(
                              icon: Icons.location_on_outlined,
                              label: 'Venue',
                              value: _nextLecture!.venue,
                              isDark: isDark,
                            ),

                            // IoT Hall Badge
                            if (_nextLecture!.isIoTHall) ...[
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.4),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.sensors,
                                      size: 14,
                                      color: Colors.green,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'IoT Enabled Hall',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ─── IoT Controls (only if IoT hall) ────────
                      if (_nextLecture!.isIoTHall) ...[
                        Text(
                          'Hall Controls',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Live sensor data from the hall',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.grey[500] : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildIoTControls(isDark),
                      ],

                      const SizedBox(height: 40),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  // ─── IoT Controls Section ──────────────────────────────────────
  Widget _buildIoTControls(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Temperature ───────────────────────────────────────
          StreamBuilder<double>(
            stream: _firebaseService.getTemperature(),
            builder: (context, snapshot) {
              final temp = snapshot.data ?? 0.0;
              return _buildSensorRow(
                icon: Icons.thermostat_outlined,
                title: 'Temperature',
                subtitle: 'Inside the hall',
                value: '${temp.toStringAsFixed(1)}°C',
                isDark: isDark,
              );
            },
          ),

          _buildDivider(isDark),

          // ─── AC Control ────────────────────────────────────────
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
          const SizedBox(height: 12),

          // ─── Lights Control (4 Channels) ───────────────────────
          Text(
            'Lights',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.6,
            children: List.generate(4, (i) {
              final channel = i + 1;
              return StreamBuilder<bool>(
                stream: _firebaseService.getLightChannel(channel),
                builder: (context, snapshot) {
                  final isOn = snapshot.data ?? false;
                  return GestureDetector(
                    onTap: () =>
                        _firebaseService.setLightChannel(channel, !isOn),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isOn
                            ? (isDark
                                  ? const Color(0xFF1A3A2A)
                                  : const Color(0xFFE6F4EC))
                            : (isDark ? const Color(0xFF3A3A3A) : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOn ? Colors.green : Colors.transparent,
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 18,
                            color: isOn
                                ? Colors.green
                                : (isDark
                                      ? Colors.grey[500]
                                      : Colors.grey[500]),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Channel $channel',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? const Color(0xFFE0E0E0)
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOn ? Colors.green : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          const SizedBox(height: 12),
          _buildDivider(isDark),

          // ─── Occupancy ─────────────────────────────────────────
          StreamBuilder<int>(
            stream: _firebaseService.getOccupancy(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return _buildSensorRow(
                icon: Icons.people_outline,
                title: 'Occupancy',
                subtitle: 'Estimated count',
                value: '$count',
                isDark: isDark,
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Sensor Row (read only) ────────────────────────────────────
  Widget _buildSensorRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Control Row (with switch) ─────────────────────────────────
  Widget _buildControlRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool isDark,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
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

  // ─── Info Row ──────────────────────────────────────────────────
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDark ? Colors.grey[500] : Colors.grey[500],
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── No Lecture Card ───────────────────────────────────────────
  Widget _buildNoLectureCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 60,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No more lectures today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check the timetable for upcoming lectures',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/timetable'),
            child: const Text('View Timetable'),
          ),
        ],
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
