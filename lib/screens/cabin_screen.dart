import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

// ─── Light State Enum ──────────────────────────────────────────
enum LightState { unknown, dark, natural, artificial }

class CabinScreen extends StatefulWidget {
  const CabinScreen({super.key});

  @override
  State<CabinScreen> createState() => _CabinScreenState();
}

class _CabinScreenState extends State<CabinScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  // Local slider state to avoid jank while dragging
  int _localTemp = 22;
  bool _tempInitialized = false;

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
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),

            const SizedBox(height: 24),

            // ─── Location Info Card ───────────────────────────────
            _buildLocationCard(isDark),

            const SizedBox(height: 32),

            // ─── Sensor Data ──────────────────────────────────────
            _buildSectionLabel('Sensor Data', isDark),
            const SizedBox(height: 12),

            // Temperature
            StreamBuilder<double>(
              stream: _firebaseService.getTemperature(),
              builder: (context, snapshot) {
                final temp = snapshot.data ?? 0.0;
                final active =
                    snapshot.connectionState == ConnectionState.active;
                return _buildSensorCard(
                  icon: Icons.thermostat_outlined,
                  title: 'Temperature',
                  value: active ? '${temp.toStringAsFixed(1)}°C' : '—',
                  subtitle: _getTempStatus(temp),
                  isDark: isDark,
                );
              },
            ),

            const SizedBox(height: 12),

            // Humidity
            StreamBuilder<double>(
              stream: _firebaseService.getHumidity(),
              builder: (context, snapshot) {
                final humidity = snapshot.data ?? 0.0;
                final active =
                    snapshot.connectionState == ConnectionState.active;
                return _buildSensorCard(
                  icon: Icons.water_drop_outlined,
                  title: 'Humidity',
                  value: active ? '${humidity.toStringAsFixed(0)}%' : '—',
                  subtitle: _getHumidityStatus(humidity),
                  isDark: isDark,
                );
              },
            ),

            const SizedBox(height: 12),

            // Ambient Light (LDR + lights sensor combined)
            StreamBuilder<bool>(
              stream: _firebaseService.getLDRStatus(),
              builder: (context, ldrSnapshot) {
                return StreamBuilder<bool>(
                  stream: _firebaseService.getLightSensorStatus(),
                  builder: (context, lightsSnapshot) {
                    final ldr = ldrSnapshot.data ?? false;
                    final lights = lightsSnapshot.data ?? false;
                    final isConnected =
                        ldrSnapshot.connectionState == ConnectionState.active;

                    final LightState state;
                    if (!isConnected) {
                      state = LightState.unknown;
                    } else if (!ldr) {
                      state = LightState.dark;
                    } else if (ldr && lights) {
                      state = LightState.artificial;
                    } else {
                      state = LightState.natural;
                    }

                    return _buildLightLevelCard(state, isDark);
                  },
                );
              },
            ),

            const SizedBox(height: 12),

            // Occupancy
            StreamBuilder<int>(
              stream: _firebaseService.getOccupancy(),
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                final active =
                    snapshot.connectionState == ConnectionState.active;
                return _buildSensorCard(
                  icon: Icons.people_outline,
                  title: 'Occupancy',
                  value: active ? '$count' : '—',
                  subtitle: _getOccupancyStatus(count),
                  isDark: isDark,
                );
              },
            ),

            const SizedBox(height: 32),

            // ─── Lights ───────────────────────────────────────────
            _buildSectionLabel(
              'Lights — Simulated from 4 Channel Relay',
              isDark,
            ),
            const SizedBox(height: 12),
            _buildLightsCard(isDark),

            const SizedBox(height: 32),

            // ─── Air Conditioner ──────────────────────────────────
            _buildSectionLabel(
              'Air Conditioner — Simulated from Single Channel Relay',
              isDark,
            ),
            const SizedBox(height: 12),
            _buildACCard(isDark),

            const SizedBox(height: 32),

            // ─── Projector ────────────────────────────────────────
            _buildSectionLabel(
              'Projector — Simulated from Single Channel Relay',
              isDark,
            ),
            const SizedBox(height: 12),
            _buildProjectorCard(isDark),

            const SizedBox(height: 32),

            // ─── Map Navigation ───────────────────────────────────
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
                        'Direction on Faculty Map',
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

  // ─── Ambient Light Card ────────────────────────────────────────
  Widget _buildLightLevelCard(LightState state, bool isDark) {
    final String label;
    final String subtitle;
    final int filledBulbs;
    final Color bulbColor;

    switch (state) {
      case LightState.dark:
        label = 'Dark';
        subtitle = 'No light detected';
        filledBulbs = 0;
        bulbColor = Colors.grey;
        break;
      case LightState.natural:
        label = 'Natural Light';
        subtitle = 'Ambient / window light';
        filledBulbs = 1;
        bulbColor = Colors.orange;
        break;
      case LightState.artificial:
        label = 'Lights On';
        subtitle = 'Artificial light detected';
        filledBulbs = 3;
        bulbColor = Colors.yellow[700]!;
        break;
      case LightState.unknown:
        label = '—';
        subtitle = 'Sensor connecting...';
        filledBulbs = 0;
        bulbColor = Colors.grey;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.brightness_6_outlined,
              size: 24,
              color: isDark ? Colors.grey[400] : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 16),

          // Label + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ambient Light',
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
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          // Bulb indicator + label
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: filledBulbs > 0 ? bulbColor : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: List.generate(3, (i) {
                  final filled = i < filledBulbs;
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      filled ? Icons.lightbulb : Icons.lightbulb_outline,
                      size: 20,
                      color: filled ? bulbColor : Colors.grey[400],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Lights Card (4 channels) ──────────────────────────────────
  Widget _buildLightsCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.count(
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
                onTap: () => _firebaseService.setLightChannel(channel, !isOn),
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
                            : (isDark ? Colors.grey[500] : Colors.grey[500]),
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
                            Text(
                              'Row $channel',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.grey[500]
                                    : Colors.grey[500],
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
    );
  }

  // ─── AC Card (toggle + temperature slider) ─────────────────────
  Widget _buildACCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // On/Off toggle
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

          // Temperature slider
          StreamBuilder<int>(
            stream: _firebaseService.getACTemperature(),
            builder: (context, snapshot) {
              if (!_tempInitialized && snapshot.hasData) {
                _localTemp = snapshot.data!;
                _tempInitialized = true;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.thermostat_outlined,
                          size: 22,
                          color: isDark
                              ? Colors.grey[400]
                              : const Color(0xFF1A1A1A),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Set Temperature',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFE0E0E0)
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ),
                        Text(
                          '$_localTemp°C',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? const Color(0xFFE0E0E0)
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 9,
                        ),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 18,
                        ),
                        activeTrackColor: Colors.blue,
                        inactiveTrackColor: isDark
                            ? const Color(0xFF4A4A4A)
                            : Colors.grey[300],
                        thumbColor: Colors.blue,
                        overlayColor: Colors.blue.withOpacity(0.15),
                      ),
                      child: Slider(
                        value: _localTemp.toDouble(),
                        min: 16,
                        max: 30,
                        divisions: 14,
                        onChanged: (val) {
                          setState(() => _localTemp = val.round());
                        },
                        onChangeEnd: (val) {
                          _firebaseService.setACTemperature(val.round());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '16°C',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '23°C',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            '30°C',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─── Projector Card ────────────────────────────────────────────
  Widget _buildProjectorCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: StreamBuilder<bool>(
        stream: _firebaseService.getProjectorStatus(),
        builder: (context, snapshot) {
          final isOn = snapshot.data ?? false;
          return _buildControlRow(
            icon: Icons.videocam_outlined,
            title: 'Projector',
            subtitle: isOn ? 'Currently ON' : 'Currently OFF',
            value: isOn,
            isDark: isDark,
            onChanged: (val) => _firebaseService.setProjector(val),
          );
        },
      ),
    );
  }

  // ─── Location Card ─────────────────────────────────────────────
  Widget _buildLocationCard(bool isDark) {
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
              Icons.location_on_outlined,
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
                  'Lecture Hall L106',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  'Floor 1 · Faculty of Computing',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
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
    );
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
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
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
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
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

  // ─── Helpers ───────────────────────────────────────────────────
  String _getTempStatus(double temp) {
    if (temp == 0.0) return 'Sensor connecting...';
    if (temp < 18) return 'Too cold';
    if (temp <= 24) return 'Comfortable';
    if (temp <= 28) return 'Warm';
    return 'Too hot';
  }

  String _getHumidityStatus(double humidity) {
    if (humidity == 0.0) return 'Sensor connecting...';
    if (humidity < 30) return 'Dry';
    if (humidity <= 60) return 'Optimal';
    return 'Humid';
  }

  String _getOccupancyStatus(int count) {
    if (count == 0) return 'Hall is empty';
    if (count <= 20) return 'Low occupancy';
    if (count <= 60) return 'Moderate occupancy';
    return 'High occupancy';
  }
}
