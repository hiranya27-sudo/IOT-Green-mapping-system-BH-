import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/lecture_slot.dart';
import '../models/hall_status.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ─── Singleton ─────────────────────────────────────────────────
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  // ══════════════════════════════════════════════════════════════
  // USER PROFILE (Firestore)
  // ══════════════════════════════════════════════════════════════

  Stream<Map<String, dynamic>?> getUserProfile() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return Stream.value(null);
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  Future<Map<String, dynamic>?> getUserProfileOnce() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  // ══════════════════════════════════════════════════════════════
  // TIMETABLE (Firestore)
  // ══════════════════════════════════════════════════════════════

  // ─── Get today's lectures for current lecturer ─────────────────
  Future<List<LectureSlot>> getTodayLectures() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final today = _getDayName(DateTime.now().weekday);
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Fetch base timetable for today
    final baseSnapshot = await _firestore
        .collection('timetable_base')
        .doc(today)
        .collection('slots')
        .orderBy('startTime')
        .get();

    // 2. Filter only this lecturer's slots
    final baseSlots = baseSnapshot.docs
        .where((doc) => doc.data()['lecturerId'] == uid)
        .map((doc) => LectureSlot.fromBase(doc.data(), doc.id))
        .toList();

    if (baseSlots.isEmpty) return [];

    // 3. Fetch today's daily venue allocation
    final dailySnapshot = await _firestore
        .collection('timetable_daily')
        .doc(todayDate)
        .collection('slots')
        .get();

    // Map daily slots by id for easy lookup
    final dailyMap = {for (var doc in dailySnapshot.docs) doc.id: doc.data()};

    // 4. Merge base + daily venue info
    return baseSlots.map((slot) => slot.withVenue(dailyMap[slot.id])).toList();
  }

  // ─── Get next lecture for current lecturer ─────────────────────
  Future<LectureSlot?> getNextLecture() async {
    final slots = await getTodayLectures();
    if (slots.isEmpty) return null;

    final now = DateTime.now();
    final currentTime = DateFormat('HH:mm').format(now);

    for (final slot in slots) {
      if (slot.endTime.compareTo(currentTime) > 0) {
        return slot;
      }
    }
    return null;
  }

  // ══════════════════════════════════════════════════════════════
  // HALL SENSOR DATA (Realtime Database)
  // ══════════════════════════════════════════════════════════════

  Stream<HallStatus> getHallStatus() {
    return _database.ref('lecture_hall/sensors').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return HallStatus.empty();
      return HallStatus.fromMap(Map<String, dynamic>.from(data));
    });
  }

  Stream<double> getTemperature() {
    return _database.ref('lecture_hall/sensors/temperature').onValue.map((
      event,
    ) {
      final value = event.snapshot.value;
      if (value == null) return 0.0;
      return (value as num).toDouble();
    });
  }

  Stream<int> getOccupancy() {
    return _database.ref('lecture_hall/sensors/occupancy').onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return 0;
      return (value as num).toInt();
    });
  }

  Stream<bool> getLightStatus() {
    return _database.ref('lecture_hall/sensors/lights').onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  // ══════════════════════════════════════════════════════════════
  // HALL CONTROLS (Realtime Database)
  // ══════════════════════════════════════════════════════════════

  Future<void> setAC(bool value) async {
    await _database.ref('lecture_hall/controls/ac_on').set(value);
  }

  Future<void> setLights(bool value) async {
    await _database.ref('lecture_hall/controls/lights_on').set(value);
  }

  Stream<bool> getACStatus() {
    return _database.ref('lecture_hall/controls/ac_on').onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  Stream<bool> getLightsControlStatus() {
    return _database.ref('lecture_hall/controls/lights_on').onValue.map((
      event,
    ) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  // ══════════════════════════════════════════════════════════════
  // HELPERS
  // ══════════════════════════════════════════════════════════════

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }
}
