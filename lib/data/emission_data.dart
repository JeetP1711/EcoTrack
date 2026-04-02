import '../models/emission_factor.dart';

/// Mock emission factor dataset.
/// Structured as typed objects so it can be replaced with API data later.
class EmissionData {
  static const List<EmissionFactor> allFactors = [
    // ─── Transport ──────────────────────────────────────────────────
    EmissionFactor(
      category: 'Transport',
      name: 'Petrol Car',
      factor: 0.21,
      unit: 'km',
      icon: '🚗',
      description: 'Average petrol car emits ~0.21 kg CO₂ per km',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Diesel Car',
      factor: 0.27,
      unit: 'km',
      icon: '🚙',
      description: 'Diesel vehicles have higher NOx but similar CO₂',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Electric Vehicle',
      factor: 0.05,
      unit: 'km',
      icon: '⚡',
      description: 'EVs produce ~75% less CO₂ than petrol cars',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Motorcycle',
      factor: 0.11,
      unit: 'km',
      icon: '🏍️',
      description: 'Motorcycles are more fuel-efficient per km',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Bus',
      factor: 0.089,
      unit: 'km',
      icon: '🚌',
      description: 'Public buses share emissions among passengers',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Train',
      factor: 0.041,
      unit: 'km',
      icon: '🚆',
      description: 'Trains are one of the most efficient transport modes',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Bicycle',
      factor: 0.0,
      unit: 'km',
      icon: '🚲',
      description: 'Zero direct emissions — the greenest option!',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Walking',
      factor: 0.0,
      unit: 'km',
      icon: '🚶',
      description: 'Zero emissions and great for health!',
    ),
    EmissionFactor(
      category: 'Transport',
      name: 'Flight (Domestic)',
      factor: 0.255,
      unit: 'km',
      icon: '✈️',
      description: 'Domestic flights have high per-km emissions',
    ),

    // ─── Food ───────────────────────────────────────────────────────
    EmissionFactor(
      category: 'Food',
      name: 'Beef',
      factor: 27.0,
      unit: 'kg',
      icon: '🥩',
      description: 'Beef is the most carbon-intensive food',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Lamb',
      factor: 24.0,
      unit: 'kg',
      icon: '🍖',
      description: 'Lamb production has significant methane emissions',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Chicken',
      factor: 6.9,
      unit: 'kg',
      icon: '🍗',
      description: 'Poultry has lower emissions than red meat',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Fish',
      factor: 5.4,
      unit: 'kg',
      icon: '🐟',
      description: 'Fish emissions vary by catch method',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Eggs',
      factor: 4.8,
      unit: 'kg',
      icon: '🥚',
      description: 'Eggs have moderate carbon footprint',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Dairy (Milk/Cheese)',
      factor: 3.2,
      unit: 'kg',
      icon: '🧀',
      description: 'Dairy production involves methane from cattle',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Rice',
      factor: 2.7,
      unit: 'kg',
      icon: '🍚',
      description: 'Rice paddies release methane during flooding',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Vegetables',
      factor: 2.0,
      unit: 'kg',
      icon: '🥗',
      description: 'Vegetables are among the lowest emission foods',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Fruits',
      factor: 1.1,
      unit: 'kg',
      icon: '🍎',
      description: 'Locally sourced fruits have minimal footprint',
    ),
    EmissionFactor(
      category: 'Food',
      name: 'Lentils & Beans',
      factor: 0.9,
      unit: 'kg',
      icon: '🫘',
      description: 'Legumes are protein-rich with very low emissions',
    ),

    // ─── Energy ─────────────────────────────────────────────────────
    EmissionFactor(
      category: 'Energy',
      name: 'Electricity',
      factor: 0.5,
      unit: 'kWh',
      icon: '💡',
      description: 'Grid electricity average (varies by source)',
    ),
    EmissionFactor(
      category: 'Energy',
      name: 'Natural Gas',
      factor: 2.0,
      unit: 'm³',
      icon: '🔥',
      description: 'Natural gas for heating and cooking',
    ),
    EmissionFactor(
      category: 'Energy',
      name: 'LPG',
      factor: 1.5,
      unit: 'L',
      icon: '🛢️',
      description: 'LPG used for cooking and heating',
    ),
    EmissionFactor(
      category: 'Energy',
      name: 'Solar Energy',
      factor: 0.0,
      unit: 'kWh',
      icon: '☀️',
      description: 'Solar produces zero direct emissions!',
    ),
  ];

  /// Get factors by category.
  static List<EmissionFactor> getByCategory(String category) {
    return allFactors.where((f) => f.category == category).toList();
  }

  /// Search factors by name.
  static List<EmissionFactor> search(String query) {
    final q = query.toLowerCase();
    return allFactors
        .where((f) =>
            f.name.toLowerCase().contains(q) ||
            f.category.toLowerCase().contains(q))
        .toList();
  }

  /// Get all unique categories.
  static List<String> get categories =>
      allFactors.map((f) => f.category).toSet().toList();
}
