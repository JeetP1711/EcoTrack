/// Emission factor entry used for CO2 calculations.
/// Structured so it can be replaced with API data later.
class EmissionFactor {
  final String category;   // Transport, Food, Energy
  final String name;        // e.g. "Petrol Car"
  final double factor;      // CO2 per unit (kg CO2 / unit)
  final String unit;        // "km", "kg", "kWh", "L", "m³"
  final String icon;        // emoji for UI display
  final String description; // brief explanation

  const EmissionFactor({
    required this.category,
    required this.name,
    required this.factor,
    required this.unit,
    required this.icon,
    required this.description,
  });
}
