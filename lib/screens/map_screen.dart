import 'dart:async';
import 'package:flutter/material.dart';
import '../services/tracking_service.dart';

class FacultyMapScreen extends StatefulWidget {
  const FacultyMapScreen({super.key});

  @override
  State<FacultyMapScreen> createState() => _FacultyMapScreenState();
}

class _FacultyMapScreenState extends State<FacultyMapScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedRoom;
  TrackingState _trackingState = TrackingState.empty();
  StreamSubscription? _trackingSub;

  // ─── Animation for pulsing current zone dot ───────────────────
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // ─── Room Definitions ──────────────────────────────────────────
  final List<RoomData> _rooms = [
    // ─── IoT Tracking Zones (Checkpoints) ───
    RoomData(
      id: 'zone_a',
      name: 'Zone A',
      type: RoomType.lectureHall,
      isIoT: true,
      floor: 2,
      rect: const Rect.fromLTWH(260, 40, 120, 70),
    ),
    RoomData(
      id: 'zone_b',
      name: 'Zone B',
      type: RoomType.lectureHall,
      isIoT: true,
      floor: 2,
      rect: const Rect.fromLTWH(200, 240, 180, 140),
    ),
    RoomData(
      id: 'zone_c',
      name: 'Zone C',
      type: RoomType.lab,
      isIoT: true,
      floor: 2,
      rect: const Rect.fromLTWH(80, 240, 120, 40),
    ),

    // ─── Structural/Static Rooms ───
    RoomData(
      id: 'main_hall_left',
      name: 'Main Hall',
      type: RoomType.staffRoom,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(20, 120, 180, 120),
    ),
    RoomData(
      id: 'top_mid_office',
      name: 'Office',
      type: RoomType.staffRoom,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(200, 40, 60, 70),
    ),
    RoomData(
      id: 'right_mid_hall',
      name: 'hallway',
      type: RoomType.lab,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(260, 110, 120, 130),
    ),
    RoomData(
      id: 'center_corridor',
      name: 'Corridor',
      type: RoomType.corridor,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(200, 110, 60, 130),
    ),
  ];

  @override
  void initState() {
    super.initState();

    // ─── Pulse animation for current zone indicator ────────────
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 4.0, end: 8.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ─── Listen to Firebase tracking updates ───────────────────
    _trackingSub = TrackingService.trackingStream().listen((state) {
      if (mounted) {
        setState(() => _trackingState = state);
        print('[Map] Tracking update: $state');

        // Show arrival snackbar
        if (state.hasArrived) {
          _showArrivalSnackbar(state.destination);
        }
      }
    });
  }

  @override
  void dispose() {
    _trackingSub?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // ─── Arrival notification ──────────────────────────────────────
  void _showArrivalSnackbar(String zoneId) {
    final room = _rooms.firstWhere(
      (r) => r.id == zoneId,
      orElse: () => _rooms.first,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('You have arrived at ${room.name}!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
        centerTitle: true,
        title: Text(
          'Faculty Map',
          style: TextStyle(
            color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Floor Label + IoT Legend ──────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Row(
              children: [
                Text(
                  'Floor 2 — Faculty of Computing',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'IoT Enabled',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Tracking Status Bar ───────────────────────────────
          _buildTrackingBar(isDark),

          // ─── Map Area ──────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(80),
                minScale: 0.8,
                maxScale: 3.0,
                child: GestureDetector(
                  onTapDown: (details) {
                    _handleMapTap(details.localPosition, isDark, context);
                  },
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return CustomPaint(
                        size: const Size(400, 400),
                        painter: FloorPlanPainter(
                          rooms: _rooms,
                          selectedRoomId: _selectedRoom,
                          isDark: isDark,
                          trackingState: _trackingState,
                          pulseRadius: _pulseAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // ─── Selected Room Info / Legend ───────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _selectedRoom != null
                ? _buildRoomInfoPanel(isDark)
                : _buildLegend(isDark),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── Tracking Status Bar ───────────────────────────────────────
  Widget _buildTrackingBar(bool isDark) {
    final isTracking = _trackingState.currentZone != 'none';
    final hasDestination = _trackingState.destination != 'none';

    if (!isTracking && !hasDestination) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        child: Text(
          'Tap an IoT zone to set your destination',
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[500] : Colors.grey[500],
          ),
        ),
      );
    }

    final currentRoom = isTracking
        ? _rooms.firstWhere(
            (r) => r.id == _trackingState.currentZone,
            orElse: () => _rooms.first,
          )
        : null;

    final destRoom = hasDestination
        ? _rooms.firstWhere(
            (r) => r.id == _trackingState.destination,
            orElse: () => _rooms.first,
          )
        : null;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Current location
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You are at',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
              Text(
                isTracking ? currentRoom!.name : '—',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          // Arrow
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.arrow_forward,
              size: 16,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ),

          // Destination
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Destination',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
              ),
              Text(
                hasDestination ? destRoom!.name : '—',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Arrived badge
          if (_trackingState.hasArrived)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '✅ Arrived',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Handle Map Tap ────────────────────────────────────────────
  void _handleMapTap(Offset position, bool isDark, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 32;
    final scaleX = screenWidth / 400;
    final scaleY = screenWidth / 400;
    final scaledPos = Offset(position.dx / scaleX, position.dy / scaleY);

    for (final room in _rooms) {
      if (room.type == RoomType.corridor) continue;
      if (room.rect.contains(scaledPos)) {
        setState(() {
          _selectedRoom = _selectedRoom == room.id ? null : room.id;
        });
        return;
      }
    }
    setState(() => _selectedRoom = null);
  }

  // ─── Room Info Panel ───────────────────────────────────────────
  Widget _buildRoomInfoPanel(bool isDark) {
    final room = _rooms.firstWhere((r) => r.id == _selectedRoom);
    final isDestination = _trackingState.destination == room.id;

    return Container(
      key: ValueKey(_selectedRoom),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Room icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getRoomIcon(room.type),
              size: 22,
              color: isDark ? Colors.grey[400] : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(width: 14),

          // Room details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      room.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF1A1A1A),
                      ),
                    ),
                    if (room.isIoT) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '🟢 IoT',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Floor ${room.floor} · ${_getRoomTypeName(room.type)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // Navigate / Set Destination button (IoT zones only)
          if (room.isIoT)
            TextButton(
              onPressed: isDestination
                  ? null
                  : () async {
                      print('[DEBUG] Navigate tapped for room: ${room.id}');
                      await TrackingService.setDestination(room.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Navigating to ${room.name}'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
              style: TextButton.styleFrom(
                backgroundColor: isDestination
                    ? Colors.green.withOpacity(0.15)
                    : (isDark ? const Color(0xFF3A3A3A) : Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: Text(
                isDestination ? '📍 Set' : 'Navigate',
                style: TextStyle(
                  fontSize: 13,
                  color: isDestination
                      ? Colors.green
                      : (isDark
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF1A1A1A)),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ─── Legend ────────────────────────────────────────────────────
  Widget _buildLegend(bool isDark) {
    return Container(
      key: const ValueKey('legend'),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(
            color: isDark ? const Color(0xFF4A90D9) : const Color(0xFFD6E8FF),
            label: 'Lecture Hall',
            isDark: isDark,
          ),
          _buildLegendItem(
            color: isDark ? const Color(0xFF7B68EE) : const Color(0xFFE8E0FF),
            label: 'Lab',
            isDark: isDark,
          ),
          _buildLegendItem(
            color: isDark ? const Color(0xFF5BA85A) : const Color(0xFFDCF5DC),
            label: 'Staff Room',
            isDark: isDark,
          ),
          _buildLegendItem(
            color: isDark ? const Color(0xFF888888) : const Color(0xFFEEEEEE),
            label: 'Other',
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ─── Room Icon ─────────────────────────────────────────────────
  IconData _getRoomIcon(RoomType type) {
    switch (type) {
      case RoomType.lectureHall:
        return Icons.school_outlined;
      case RoomType.lab:
        return Icons.computer_outlined;
      case RoomType.staffRoom:
        return Icons.people_outline;
      case RoomType.restroom:
        return Icons.wc_outlined;
      case RoomType.staircase:
        return Icons.stairs_outlined;
      default:
        return Icons.room_outlined;
    }
  }

  // ─── Room Type Name ────────────────────────────────────────────
  String _getRoomTypeName(RoomType type) {
    switch (type) {
      case RoomType.lectureHall:
        return 'Lecture Hall';
      case RoomType.lab:
        return 'Computer Lab';
      case RoomType.staffRoom:
        return 'Staff Room';
      case RoomType.restroom:
        return 'Restroom';
      case RoomType.staircase:
        return 'Staircase';
      default:
        return 'Room';
    }
  }
}

// ══════════════════════════════════════════════════════════════════
// ROOM DATA MODEL
// ══════════════════════════════════════════════════════════════════
enum RoomType { lectureHall, lab, staffRoom, corridor, restroom, staircase }

class RoomData {
  final String id;
  final String name;
  final RoomType type;
  final bool isIoT;
  final int floor;
  final Rect rect;

  RoomData({
    required this.id,
    required this.name,
    required this.type,
    required this.isIoT,
    required this.floor,
    required this.rect,
  });
}

// ══════════════════════════════════════════════════════════════════
// FLOOR PLAN PAINTER
// ══════════════════════════════════════════════════════════════════
class FloorPlanPainter extends CustomPainter {
  final List<RoomData> rooms;
  final String? selectedRoomId;
  final bool isDark;
  final TrackingState trackingState;
  final double pulseRadius;

  FloorPlanPainter({
    required this.rooms,
    required this.selectedRoomId,
    required this.isDark,
    required this.trackingState,
    required this.pulseRadius,
  });

  // ─── Zone center points for path drawing ──────────────────────
  // These are the center points the path line passes through
  static const Map<String, Offset> _zoneCenters = {
    'zone_a': Offset(320, 75), // center of zone_a rect
    'zone_b': Offset(290, 310), // center of zone_b rect
    'zone_c': Offset(140, 260), // center of zone_c rect
  };

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 400;
    final scaleY = size.width / 400;

    // ─── Draw rooms first ─────────────────────────────────────
    for (final room in rooms) {
      final scaledRect = Rect.fromLTWH(
        room.rect.left * scaleX,
        room.rect.top * scaleY,
        room.rect.width * scaleX,
        room.rect.height * scaleY,
      );

      final isSelected = room.id == selectedRoomId;
      final isCurrentZone = room.id == trackingState.currentZone;
      final isDestination = room.id == trackingState.destination;
      final isCompleted = trackingState.completedZones.contains(room.id);

      // ─── Room Fill Color ─────────────────────────────────────
      Color fillColor = _getRoomColor(room.type, isDark);
      if (isCurrentZone) {
        fillColor = Colors.green.withOpacity(0.25);
      } else if (isDestination) {
        fillColor = Colors.blue.withOpacity(0.25);
      } else if (isCompleted && room.isIoT) {
        fillColor = Colors.green.withOpacity(0.12);
      } else if (isSelected) {
        fillColor = fillColor.withOpacity(0.6);
      }

      // ─── Draw Room ───────────────────────────────────────────
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill;

      Color borderColor;
      double borderWidth;
      if (isCurrentZone) {
        borderColor = Colors.green;
        borderWidth = 2.0;
      } else if (isDestination) {
        borderColor = Colors.blue;
        borderWidth = 2.0;
      } else if (isSelected) {
        borderColor = isDark ? Colors.white : Colors.black;
        borderWidth = 2.0;
      } else {
        borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade400;
        borderWidth = 1.0;
      }

      final borderPaint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      final rRect = RRect.fromRectAndRadius(
        scaledRect,
        const Radius.circular(8),
      );

      canvas.drawRRect(rRect, fillPaint);
      canvas.drawRRect(rRect, borderPaint);

      // ─── IoT dot (green = current, blue = destination) ───────
      if (room.isIoT) {
        Color dotColor = Colors.green;
        if (isDestination && !isCurrentZone) dotColor = Colors.blue;

        final dotPaint = Paint()
          ..color = dotColor
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(scaledRect.right - 10 * scaleX, scaledRect.top + 10 * scaleY),
          5 * scaleX,
          dotPaint,
        );
      }

      // ─── Room Label ──────────────────────────────────────────
      if (room.type != RoomType.corridor) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: _getShortName(room.name),
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[800],
              fontSize: 10 * scaleX,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );
        textPainter.layout(maxWidth: scaledRect.width - 8);
        textPainter.paint(
          canvas,
          Offset(
            scaledRect.center.dx - textPainter.width / 2,
            scaledRect.center.dy - textPainter.height / 2,
          ),
        );
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'CORRIDOR',
            style: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[500],
              fontSize: 9 * scaleX,
              letterSpacing: 2,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            scaledRect.center.dx - textPainter.width / 2,
            scaledRect.center.dy - textPainter.height / 2,
          ),
        );
      }
    }

    // ─── Draw path lines on top of rooms ──────────────────────
    _drawPath(canvas, scaleX, scaleY);

    // ─── Draw pulsing ring on current zone ────────────────────
    _drawCurrentZonePulse(canvas, scaleX, scaleY);
  }

  // ─── Path Drawing ─────────────────────────────────────────────
  void _drawPath(Canvas canvas, double scaleX, double scaleY) {
    if (trackingState.destination == 'none') return;

    final destIndex = TrackingState.fullPath.indexOf(trackingState.destination);
    if (destIndex < 0) return;

    // Draw segments from zone_a to destination
    for (int i = 0; i < destIndex; i++) {
      final fromId = TrackingState.fullPath[i];
      final toId = TrackingState.fullPath[i + 1];

      final from = _zoneCenters[fromId]!;
      final to = _zoneCenters[toId]!;

      final scaledFrom = Offset(from.dx * scaleX, from.dy * scaleY);
      final scaledTo = Offset(to.dx * scaleX, to.dy * scaleY);

      final currentIndex = TrackingState.fullPath.indexOf(
        trackingState.currentZone,
      );
      final isCompleted = currentIndex >= 0 && i < currentIndex;
      final isActive = currentIndex >= 0 && i == currentIndex;

      if (isCompleted) {
        // Solid green line — user has passed this segment
        _drawSolidLine(canvas, scaledFrom, scaledTo, Colors.green, 3.0);
      } else if (isActive) {
        // Animated blue line — user is on this segment now
        _drawSolidLine(canvas, scaledFrom, scaledTo, Colors.blue, 3.0);
      } else {
        // Dashed grey line — upcoming segment
        _drawDashedLine(
          canvas,
          scaledFrom,
          scaledTo,
          isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          2.0,
        );
      }

      // ─── Arrow head at destination end ──────────────────────
      if (i == destIndex - 1) {
        _drawArrowHead(
          canvas,
          scaledFrom,
          scaledTo,
          isCompleted ? Colors.green : Colors.blue,
        );
      }
    }
  }

  void _drawSolidLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Color color,
    double width,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(from, to, paint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset from,
    Offset to,
    Color color,
    double width,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const dashLength = 8.0;
    const gapLength = 5.0;

    final direction = (to - from);
    final totalLength = direction.distance;
    final unitDir = direction / totalLength;

    double drawn = 0;
    bool drawing = true;

    while (drawn < totalLength) {
      final segLength = drawing ? dashLength : gapLength;
      final end = drawn + segLength > totalLength
          ? totalLength
          : drawn + segLength;

      if (drawing) {
        canvas.drawLine(from + unitDir * drawn, from + unitDir * end, paint);
      }

      drawn = end;
      drawing = !drawing;
    }
  }

  void _drawArrowHead(Canvas canvas, Offset from, Offset to, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const arrowSize = 10.0;
    final direction = (to - from);
    final angle = direction.direction; // radians

    final path = Path();
    path.moveTo(to.dx, to.dy);
    path.lineTo(
      to.dx -
          arrowSize *
              (1.5 *
                      (direction.dx.abs() > direction.dy.abs()
                          ? direction.dx / direction.distance
                          : 0) +
                  0.5 * (-direction.dy / direction.distance)),
      to.dy -
          arrowSize *
              (1.5 *
                      (direction.dx.abs() > direction.dy.abs()
                          ? 0
                          : direction.dy / direction.distance) +
                  0.5 * (direction.dx / direction.distance)),
    );
    path.lineTo(
      to.dx -
          arrowSize *
              (1.5 *
                      (direction.dx.abs() > direction.dy.abs()
                          ? direction.dx / direction.distance
                          : 0) -
                  0.5 * (-direction.dy / direction.distance)),
      to.dy -
          arrowSize *
              (1.5 *
                      (direction.dx.abs() > direction.dy.abs()
                          ? 0
                          : direction.dy / direction.distance) -
                  0.5 * (direction.dx / direction.distance)),
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  // ─── Pulsing ring on current zone ─────────────────────────────
  void _drawCurrentZonePulse(Canvas canvas, double scaleX, double scaleY) {
    if (trackingState.currentZone == 'none') return;

    final center = _zoneCenters[trackingState.currentZone];
    if (center == null) return;

    final scaledCenter = Offset(center.dx * scaleX, center.dy * scaleY);

    final pulsePaint = Paint()
      ..color = Colors.green.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(scaledCenter, pulseRadius * scaleX, pulsePaint);
  }

  // ─── Room Color ────────────────────────────────────────────────
  Color _getRoomColor(RoomType type, bool isDark) {
    switch (type) {
      case RoomType.lectureHall:
        return isDark
            ? const Color(0xFF4A90D9).withOpacity(0.3)
            : const Color(0xFFD6E8FF);
      case RoomType.lab:
        return isDark
            ? const Color(0xFF7B68EE).withOpacity(0.3)
            : const Color(0xFFE8E0FF);
      case RoomType.staffRoom:
        return isDark
            ? const Color(0xFF5BA85A).withOpacity(0.3)
            : const Color(0xFFDCF5DC);
      case RoomType.corridor:
        return isDark ? const Color(0xFF333333) : const Color(0xFFEEEEEE);
      case RoomType.restroom:
        return isDark
            ? const Color(0xFF888888).withOpacity(0.3)
            : const Color(0xFFEEEEEE);
      case RoomType.staircase:
        return isDark
            ? const Color(0xFF888888).withOpacity(0.3)
            : const Color(0xFFEEEEEE);
    }
  }

  // ─── Short Room Name ───────────────────────────────────────────
  String _getShortName(String name) {
    if (name.length <= 10) return name;
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0]}\n${words.sublist(1).join(' ')}';
    }
    return name;
  }

  @override
  bool shouldRepaint(FloorPlanPainter oldDelegate) {
    return oldDelegate.selectedRoomId != selectedRoomId ||
        oldDelegate.isDark != isDark ||
        oldDelegate.trackingState.currentZone != trackingState.currentZone ||
        oldDelegate.trackingState.destination != trackingState.destination ||
        oldDelegate.pulseRadius != pulseRadius;
  }
}
