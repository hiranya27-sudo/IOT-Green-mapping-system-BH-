import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../models/lecture_slot.dart';
import '../models/hall_status.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://nsbm-smart-faculty-default-rtdb.asia-southeast1.firebasedatabase.app',
  );

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

  Future<List<LectureSlot>> getTodayLectures() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    final today = _getDayName(DateTime.now().weekday);
    final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final baseSnapshot = await _firestore
        .collection('timetable_base')
        .doc(today)
        .collection('slots')
        .orderBy('startTime')
        .get();

    final baseSlots = baseSnapshot.docs
        .where((doc) => doc.data()['lecturerId'] == uid)
        .map((doc) => LectureSlot.fromBase(doc.data(), doc.id))
        .toList();

    if (baseSlots.isEmpty) return [];

    final dailySnapshot = await _firestore
        .collection('timetable_daily')
        .doc(todayDate)
        .collection('slots')
        .get();

    final dailyMap = {for (var doc in dailySnapshot.docs) doc.id: doc.data()};

    return baseSlots.map((slot) => slot.withVenue(dailyMap[slot.id])).toList();
  }

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
    return _database
        .ref('lecture_hall/sensors/temperature')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return 0.0;
      return (value as num).toDouble();
    });
  }

  Stream<double> getHumidity() {
    return _database
        .ref('lecture_hall/sensors/humidity')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return 0.0;
      return (value as num).toDouble();
    });
  }

  Stream<int> getOccupancy() {
    return _database
        .ref('lecture_hall/sensors/occupancy')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return 0;
      return (value as num).toInt();
    });
  }

  // ─── LDR (digital module — DO pin) ────────────────────────────
  // true  = light detected
  // false = dark

  Stream<bool> getLDRStatus() {
    return _database
        .ref('lecture_hall/sensors/ldr')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  // ─── Lights sensor (physical relay state feedback) ─────────────

  Stream<bool> getLightSensorStatus() {
    return _database
        .ref('lecture_hall/sensors/lights')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  // ══════════════════════════════════════════════════════════════
  // HALL CONTROLS (Realtime Database)
  // ══════════════════════════════════════════════════════════════

  // ─── AC ────────────────────────────────────────────────────────

  Stream<bool> getACStatus() {
    return _database
        .ref('lecture_hall/controls/ac_on')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  Future<void> setAC(bool value) async {
    try {
      await _database.ref('lecture_hall/controls/ac_on').set(value);
    } catch (e) {
      print('setAC error: $e');
    }
  }

  // ─── AC Temperature ────────────────────────────────────────────

  Stream<int> getACTemperature() {
    return _database
        .ref('lecture_hall/controls/ac_temperature')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return 22;
      return (value as num).toInt();
    });
  }

  Future<void> setACTemperature(int value) async {
    try {
      await _database
          .ref('lecture_hall/controls/ac_temperature')
          .set(value);
    } catch (e) {
      print('setACTemperature error: $e');
    }
  }

  // ─── Lights (4-channel relay) ──────────────────────────────────
  // Paths: lecture_hall/controls/lights/channel1 … channel4

  Stream<bool> getLightChannel(int channel) {
    return _database
        .ref('lecture_hall/controls/lights/channel$channel')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  Future<void> setLightChannel(int channel, bool value) async {
    try {
      await _database
          .ref('lecture_hall/controls/lights/channel$channel')
          .set(value);
    } catch (e) {
      print('setLightChannel$channel error: $e');
    }
  }

  // ─── Projector ─────────────────────────────────────────────────

  Stream<bool> getProjectorStatus() {
    return _database
        .ref('lecture_hall/controls/projector_on')
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null) return false;
      return value as bool;
    });
  }

  Future<void> setProjector(bool value) async {
    try {
      await _database
          .ref('lecture_hall/controls/projector_on')
          .set(value);
    } catch (e) {
      print('setProjector error: $e');
    }
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