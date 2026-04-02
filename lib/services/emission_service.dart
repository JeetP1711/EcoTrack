import '../data/emission_data.dart';
import '../models/emission_factor.dart';

/// Service for calculating carbon emissions.
class EmissionService {
  /// Calculate CO2 emission for a given activity and quantity.
  /// Returns emission in kg CO2.
  double calculateEmission(String activityName, double quantity) {
    final factor = EmissionData.allFactors.firstWhere(
      (f) => f.name == activityName,
      orElse: () => const EmissionFactor(
        category: 'Unknown',
        name: 'Unknown',
        factor: 0,
        unit: '',
        icon: '❓',
        description: '',
      ),
    );
    return factor.factor * quantity;
  }

  /// Get the emission factor for a specific activity.
  EmissionFactor? getEmissionFactor(String activityName) {
    try {
      return EmissionData.allFactors.firstWhere(
        (f) => f.name == activityName,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get impact level description.
  String getImpactLevel(double co2Kg) {
    if (co2Kg <= 0) return 'Zero Impact 🌟';
    if (co2Kg < 1) return 'Very Low 🟢';
    if (co2Kg < 3) return 'Low 🟡';
    if (co2Kg < 5) return 'Moderate 🟠';
    if (co2Kg < 10) return 'High 🔴';
    return 'Very High ⛔';
  }

  /// Get a simple explanation of the emission impact.
  String getImpactExplanation(double co2Kg) {
    if (co2Kg <= 0) {
      return 'This activity produces zero carbon emissions! Keep it up!';
    }
    if (co2Kg < 1) {
      return 'Equivalent to charging your phone ${(co2Kg / 0.008).toStringAsFixed(0)} times.';
    }
    if (co2Kg < 5) {
      return 'Equivalent to driving a petrol car ${(co2Kg / 0.21).toStringAsFixed(1)} km.';
    }
    if (co2Kg < 20) {
      return 'This is like ${(co2Kg / 2.3).toStringAsFixed(1)} loads of laundry in terms of energy.';
    }
    return 'This equals about ${(co2Kg / 21).toStringAsFixed(1)} days of average individual emissions.';
  }

  /// Format CO2 value for display.
  String formatCO2(double co2Kg) {
    if (co2Kg < 0.01) return '0 kg';
    if (co2Kg < 1) return '${(co2Kg * 1000).toStringAsFixed(0)} g';
    if (co2Kg < 100) return '${co2Kg.toStringAsFixed(2)} kg';
    return '${co2Kg.toStringAsFixed(1)} kg';
  }
}
