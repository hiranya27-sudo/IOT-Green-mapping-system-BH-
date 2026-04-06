class HallStatus {
  final double temperature;
  final int occupancy;
  final bool lightsOn;

  HallStatus({
    required this.temperature,
    required this.occupancy,
    required this.lightsOn,
  });

  factory HallStatus.fromMap(Map<String, dynamic> map) {
    return HallStatus(
      temperature: (map['temperature'] as num?)?.toDouble() ?? 0.0,
      occupancy: (map['occupancy'] as num?)?.toInt() ?? 0,
      lightsOn: map['lights'] as bool? ?? false,
    );
  }

  // Empty state when no data available
  factory HallStatus.empty() {
    return HallStatus(temperature: 0.0, occupancy: 0, lightsOn: false);
  }
}
