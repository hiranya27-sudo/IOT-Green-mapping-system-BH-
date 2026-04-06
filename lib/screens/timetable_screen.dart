import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_service.dart';
import '../models/lecture_slot.dart';

class TimeTableScreen extends StatefulWidget {
  const TimeTableScreen({super.key});

  @override
  State<TimeTableScreen> createState() => _TimeTableScreenState();
}

class _TimeTableScreenState extends State<TimeTableScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<LectureSlot> _slots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    setState(() => _isLoading = true);
    final slots = await _firebaseService.getTodayLectures();
    if (!mounted) return;
    setState(() {
      _slots = slots;
      _isLoading = false;
    });
  }

  // ─── Today's date string ───────────────────────────────────────
  String _getTodayString() {
    return DateFormat('EEEE, MMMM d').format(DateTime.now());
  }

  // ─── Is lecture currently running ─────────────────────────────
  bool _isCurrentlyRunning(LectureSlot slot) {
    final now = DateTime.now();
    final currentTime = DateFormat('HH:mm').format(now);
    return slot.startTime.compareTo(currentTime) <= 0 &&
        slot.endTime.compareTo(currentTime) > 0;
  }

  // ─── Is lecture already done ───────────────────────────────────
  bool _isDone(LectureSlot slot) {
    final currentTime = DateFormat('HH:mm').format(DateTime.now());
    return slot.endTime.compareTo(currentTime) <= 0;
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
          'Time Table',
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
      body: RefreshIndicator(
        onRefresh: _loadTimetable,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── Date ──────────────────────────────
                          Text(
                            _getTodayString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: isDark
                                  ? Colors.grey[500]
                                  : Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Today's Schedule",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFFE0E0E0)
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // ─── Summary Row ───────────────────────
                          _buildSummaryRow(isDark),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // ─── Slot List or Empty State ──────────────────
                  _slots.isEmpty
                      ? SliverFillRemaining(child: _buildEmptyState(isDark))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                              child: _buildSlotCard(_slots[index], isDark),
                            );
                          }, childCount: _slots.length),
                        ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              ),
      ),
    );
  }

  // ─── Summary Row ───────────────────────────────────────────────
  Widget _buildSummaryRow(bool isDark) {
    final total = _slots.length;
    final done = _slots.where((s) => _isDone(s)).length;
    final iotSlots = _slots.where((s) => s.isIoTHall).length;

    return Row(
      children: [
        _buildSummaryChip(
          '$total',
          'Total',
          Icons.calendar_today_outlined,
          isDark,
        ),
        const SizedBox(width: 12),
        _buildSummaryChip('$done', 'Done', Icons.check_circle_outline, isDark),
        const SizedBox(width: 12),
        _buildSummaryChip(
          '$iotSlots',
          'IoT Hall',
          Icons.sensors,
          isDark,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildSummaryChip(
    String value,
    String label,
    IconData icon,
    bool isDark, {
    Color? color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: color ?? (isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    color ??
                    (isDark
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF1A1A1A)),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Slot Card ─────────────────────────────────────────────────
  Widget _buildSlotCard(LectureSlot slot, bool isDark) {
    final isRunning = _isCurrentlyRunning(slot);
    final isDone = _isDone(slot);

    return Opacity(
      opacity: isDone ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF1F3F5),
          borderRadius: BorderRadius.circular(16),
          border: isRunning
              ? Border.all(color: const Color(0xFF1A1A1A), width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Top Row ────────────────────────────────────────
            Row(
              children: [
                // Time badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF3A3A3A) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${slot.startTime} – ${slot.endTime}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                const Spacer(),

                // Status badge
                if (isRunning)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'Now',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (isDone)
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // ─── Subject ─────────────────────────────────────────
            Text(
              slot.subject,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF1A1A1A),
              ),
            ),

            const SizedBox(height: 10),

            // ─── Venue Row ───────────────────────────────────────
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 15,
                  color: isDark ? Colors.grey[500] : Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  slot.venue,
                  style: TextStyle(
                    fontSize: 14,
                    color: slot.venue == 'Venue TBA'
                        ? Colors.orange
                        : (isDark ? Colors.grey[400] : Colors.grey[600]),
                    fontWeight: slot.venue == 'Venue TBA'
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                if (slot.isIoTHall) ...[
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sensors, size: 11, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          'IoT',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty State ───────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_outlined,
            size: 64,
            color: isDark ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No lectures today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enjoy your free day!',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
