import 'package:flutter/material.dart';

class FacultyMapScreen extends StatefulWidget {
  const FacultyMapScreen({super.key});

  @override
  State<FacultyMapScreen> createState() => _FacultyMapScreenState();
}

class _FacultyMapScreenState extends State<FacultyMapScreen> {
  String? _selectedRoom;

  // ─── Room Definitions ──────────────────────────────────────────
  final List<RoomData> _rooms = [
    RoomData(
      id: 'lh_a',
      name: 'Lecture Hall A',
      type: RoomType.lectureHall,
      isIoT: true,
      floor: 2,
      rect: const Rect.fromLTWH(20, 20, 160, 100),
    ),
    RoomData(
      id: 'lh_b',
      name: 'Lecture Hall B',
      type: RoomType.lectureHall,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(200, 20, 160, 100),
    ),
    RoomData(
      id: 'lab_01',
      name: 'Lab 01',
      type: RoomType.lab,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(20, 140, 100, 80),
    ),
    RoomData(
      id: 'lab_02',
      name: 'Lab 02',
      type: RoomType.lab,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(140, 140, 100, 80),
    ),
    RoomData(
      id: 'staff_room',
      name: 'Staff Room',
      type: RoomType.staffRoom,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(260, 140, 100, 80),
    ),
    RoomData(
      id: 'corridor',
      name: 'Corridor',
      type: RoomType.corridor,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(20, 240, 340, 40),
    ),
    RoomData(
      id: 'toilet_m',
      name: "Restroom",
      type: RoomType.restroom,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(20, 300, 80, 60),
    ),
    RoomData(
      id: 'staircase',
      name: 'Staircase',
      type: RoomType.staircase,
      isIoT: false,
      floor: 2,
      rect: const Rect.fromLTWH(280, 300, 80, 60),
    ),
  ];

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
          // ─── Floor Label ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                Text(
                  'Floor 2 — Faculty of Computing',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
                const Spacer(),
                // IoT legend
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
                  child: CustomPaint(
                    size: const Size(400, 400),
                    painter: FloorPlanPainter(
                      rooms: _rooms,
                      selectedRoomId: _selectedRoom,
                      isDark: isDark,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ─── Selected Room Info ────────────────────────────────
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

  // ─── Handle Map Tap ────────────────────────────────────────────
  void _handleMapTap(Offset position, bool isDark, BuildContext context) {
    // Scale factor to match CustomPaint size vs screen size
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

          // Navigate button (for IoT hall)
          if (room.isIoT)
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/cabin'),
              style: TextButton.styleFrom(
                backgroundColor: isDark
                    ? const Color(0xFF3A3A3A)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              child: Text(
                'Controls',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF1A1A1A),
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

  FloorPlanPainter({
    required this.rooms,
    required this.selectedRoomId,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 400;
    final scaleY = size.width / 400;

    for (final room in rooms) {
      final scaledRect = Rect.fromLTWH(
        room.rect.left * scaleX,
        room.rect.top * scaleY,
        room.rect.width * scaleX,
        room.rect.height * scaleY,
      );

      final isSelected = room.id == selectedRoomId;

      // ─── Room Fill Color ───────────────────────────────────────
      Color fillColor = _getRoomColor(room.type, isDark);
      if (isSelected) {
        fillColor = fillColor.withOpacity(0.6);
      }

      // ─── Draw Room ────────────────────────────────────────────
      final fillPaint = Paint()
        ..color = fillColor
        ..style = PaintingStyle.fill;

      final borderPaint = Paint()
        ..color = isSelected
            ? (isDark ? Colors.white : Colors.black)
            : (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 2.0 : 1.0;

      final rRect = RRect.fromRectAndRadius(
        scaledRect,
        const Radius.circular(8),
      );

      canvas.drawRRect(rRect, fillPaint);
      canvas.drawRRect(rRect, borderPaint);

      // ─── IoT Indicator ────────────────────────────────────────
      if (room.isIoT) {
        final dotPaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(scaledRect.right - 10 * scaleX, scaledRect.top + 10 * scaleY),
          5 * scaleX,
          dotPaint,
        );
      }

      // ─── Room Label ───────────────────────────────────────────
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
        // Corridor label
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
        oldDelegate.isDark != isDark;
  }
}
