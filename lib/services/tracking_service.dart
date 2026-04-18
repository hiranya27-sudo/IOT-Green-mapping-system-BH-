import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class TrackingService {
  static DatabaseReference get _ref => FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://nsbm-smart-faculty-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('tracking');

  // ─── Update destination (called when user picks a room on map) ───
  static Future<void> setDestination(String zoneId) async {
    try {
      print('[Tracking] Attempting to write: $zoneId');
      print('[Tracking] Database ref path: ${_ref.path}');
      await _ref.update({'destination': zoneId});
      print('[Tracking] ✅ Write successful');
    } catch (e) {
      print('[Tracking] ❌ Write failed: $e');
    }
  }

  // ─── Listen to zone changes in real time ─────────────────────────
  static Stream<TrackingState> trackingStream() {
    return _ref.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return TrackingState.empty();

      return TrackingState(
        currentZone: data['current_zone']?.toString() ?? 'none',
        previousZone: data['previous_zone']?.toString() ?? 'none',
        destination: data['destination']?.toString() ?? 'none',
      );
    });
  }
}

// ══════════════════════════════════════════════════════════════════
// TRACKING STATE MODEL
// ══════════════════════════════════════════════════════════════════
class TrackingState {
  final String currentZone;
  final String previousZone;
  final String destination;

  TrackingState({
    required this.currentZone,
    required this.previousZone,
    required this.destination,
  });

  factory TrackingState.empty() => TrackingState(
    currentZone: 'none',
    previousZone: 'none',
    destination: 'none',
  );

  static const List<String> fullPath = ['zone_a', 'zone_b', 'zone_c'];

  int indexOfZone(String zoneId) => fullPath.indexOf(zoneId);

  List<String> get completedZones {
    final currentIndex = indexOfZone(currentZone);
    if (currentIndex < 0) return [];
    return fullPath.sublist(0, currentIndex + 1);
  }

  List<String> get remainingZones {
    final currentIndex = indexOfZone(currentZone);
    final destIndex = indexOfZone(destination);
    if (currentIndex < 0 || destIndex < 0) return [];
    if (currentIndex >= destIndex) return [];
    return fullPath.sublist(currentIndex + 1, destIndex + 1);
  }

  bool get hasArrived => currentZone == destination && destination != 'none';

  @override
  String toString() =>
      'TrackingState(current: $currentZone, dest: $destination)';
}
