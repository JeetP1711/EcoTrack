/// Represents a logged user activity with its carbon emission.
class ActivityModel {
  final String id;
  final String category;    // Transport, Food, Energy
  final String name;         // e.g. "Petrol Car", "Beef", "Electricity"
  final double value;        // quantity (km, kg, kWh)
  final String unit;         // "km", "kg", "kWh"
  final double co2Emission;  // calculated CO2 in kg
  final DateTime timestamp;

  const ActivityModel({
    required this.id,
    required this.category,
    required this.name,
    required this.value,
    required this.unit,
    required this.co2Emission,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'name': name,
    'value': value,
    'unit': unit,
    'co2Emission': co2Emission,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
    id: json['id'] as String,
    category: json['category'] as String,
    name: json['name'] as String,
    value: (json['value'] as num).toDouble(),
    unit: json['unit'] as String,
    co2Emission: (json['co2Emission'] as num).toDouble(),
    timestamp: DateTime.parse(json['timestamp'] as String),
  );
}
