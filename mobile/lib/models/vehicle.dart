class Vehicle {
  final String nodeId;
  final String plate;
  final double latitude;
  final double longitude;
  final int speed;
  final bool ignition;
  final String factoryCode;
  final double distanceKm;
  final int etaMin;

  Vehicle({
    required this.nodeId,
    required this.plate,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.ignition,
    required this.factoryCode,
    required this.distanceKm,
    required this.etaMin,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      nodeId: json['NodeID'] ?? '',
      plate: json['Plate'] ?? '',
      latitude: (json['Latitude'] ?? 0.0).toDouble(),
      longitude: (json['Longitude'] ?? 0.0).toDouble(),
      speed: json['Speed'] ?? 0,
      ignition: json['Ignition'] ?? false,
      factoryCode: json['FactoryCode'] ?? '',
      distanceKm: (json['DistanceKm'] ?? 0.0).toDouble(),
      etaMin: json['EtaMin'] ?? 0,
    );
  }
}
