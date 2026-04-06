class LectureSlot {
  final String id;
  final String subject;
  final String startTime;
  final String endTime;
  final String lecturerId;
  final String venue;
  final bool isIoTHall;

  LectureSlot({
    required this.id,
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.lecturerId,
    this.venue = 'Venue TBA',
    this.isIoTHall = false,
  });

  // ─── From base timetable only ──────────────────────────────────
  factory LectureSlot.fromBase(Map<String, dynamic> map, String id) {
    return LectureSlot(
      id: id,
      subject: map['subject'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      lecturerId: map['lecturerId'] ?? '',
    );
  }

  // ─── Merge base + daily allocation ────────────────────────────
  LectureSlot withVenue(Map<String, dynamic>? dailyData) {
    if (dailyData == null) return this;
    return LectureSlot(
      id: id,
      subject: subject,
      startTime: startTime,
      endTime: endTime,
      lecturerId: lecturerId,
      venue: dailyData['venue'] ?? 'Venue TBA',
      isIoTHall: dailyData['isIoTHall'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'startTime': startTime,
      'endTime': endTime,
      'lecturerId': lecturerId,
      'venue': venue,
      'isIoTHall': isIoTHall,
    };
  }
}
