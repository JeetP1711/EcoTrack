import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/emission_data.dart';
import '../../models/emission_factor.dart';
import '../../services/emission_service.dart';

/// Carbon emission calculator screen.
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EmissionService _emissionService = EmissionService();
  final _valueController = TextEditingController();
  EmissionFactor? _selectedFactor;
  double? _calculatedCO2;
  String _searchQuery = '';
  final List<String> _categories = ['Transport', 'Food', 'Energy'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedFactor = null;
        _calculatedCO2 = null;
        _valueController.clear();
        _searchQuery = '';
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_selectedFactor == null || _valueController.text.isEmpty) return;
    final value = double.tryParse(_valueController.text);
    if (value == null || value <= 0) return;
    setState(() {
      _calculatedCO2 = _emissionService.calculateEmission(_selectedFactor!.name, value);
    });
  }

  Color _catColor(String c) {
    switch (c) {
      case 'Transport': return EcoTheme.transportColor;
      case 'Food': return EcoTheme.foodColor;
      case 'Energy': return EcoTheme.energyColor;
      default: return EcoTheme.greenPrimary;
    }
  }

  IconData _catIcon(String c) {
    switch (c) {
      case 'Transport': return Icons.directions_car_rounded;
      case 'Food': return Icons.restaurant_rounded;
      case 'Energy': return Icons.bolt_rounded;
      default: return Icons.eco_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCat = _categories[_tabController.index];
    var factors = EmissionData.getByCategory(currentCat);
    if (_searchQuery.isNotEmpty) {
      factors = factors.where((f) => f.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EcoTheme.darkGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Text('Carbon Calculator', style: Theme.of(context).textTheme.headlineMedium),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                child: Text('Calculate CO₂ emissions for any activity', style: Theme.of(context).textTheme.bodyMedium),
              ),

              // Category Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(color: EcoTheme.surfaceBg, borderRadius: BorderRadius.circular(14)),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(color: _catColor(currentCat), borderRadius: BorderRadius.circular(11)),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: EcoTheme.textMuted,
                  labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  padding: const EdgeInsets.all(4),
                  tabs: _categories.map((c) => Tab(
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(_catIcon(c), size: 16), const SizedBox(width: 6), Text(c),
                    ]),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  style: const TextStyle(color: EcoTheme.white),
                  decoration: InputDecoration(
                    hintText: 'Search ${currentCat.toLowerCase()}...',
                    prefixIcon: const Icon(Icons.search_rounded, color: EcoTheme.textMuted),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onChanged: (v) => setState(() => _searchQuery = v),
                ),
              ),
              const SizedBox(height: 16),

              // Activity List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: factors.length,
                  itemBuilder: (context, index) {
                    final factor = factors[index];
                    final isSelected = _selectedFactor?.name == factor.name;
                    final color = _catColor(factor.category);
                    return GestureDetector(
                      onTap: () => setState(() { _selectedFactor = factor; _calculatedCO2 = null; }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? color.withValues(alpha: 0.12) : EcoTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? color.withValues(alpha: 0.5) : Colors.transparent, width: 1.5),
                        ),
                        child: Row(children: [
                          Text(factor.icon, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(factor.name, style: TextStyle(
                              color: isSelected ? color : EcoTheme.white, fontWeight: FontWeight.w600, fontSize: 15)),
                            const SizedBox(height: 3),
                            Text(factor.description, style: const TextStyle(color: EcoTheme.textMuted, fontSize: 12),
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          ])),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('${factor.factor}', style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 16)),
                            Text('kg/${factor.unit}', style: const TextStyle(color: EcoTheme.textMuted, fontSize: 11)),
                          ]),
                        ]),
                      ),
                    );
                  },
                ),
              ),

              // Calculator Input & Result
              if (_selectedFactor != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: EcoTheme.cardBg,
                    border: Border(top: BorderSide(color: _catColor(_selectedFactor!.category).withValues(alpha: 0.2))),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Row(children: [
                        Expanded(child: TextField(
                          controller: _valueController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: EcoTheme.white),
                          decoration: InputDecoration(
                            hintText: 'Enter ${_selectedFactor!.unit}...',
                            suffixText: _selectedFactor!.unit,
                            suffixStyle: const TextStyle(color: EcoTheme.textSecondary),
                          ),
                          onChanged: (_) => _calculate(),
                        )),
                        const SizedBox(width: 14),
                        ElevatedButton(
                          onPressed: _calculate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _catColor(_selectedFactor!.category),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          ),
                          child: const Text('Calculate'),
                        ),
                      ]),
                      if (_calculatedCO2 != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _catColor(_selectedFactor!.category).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(_emissionService.formatCO2(_calculatedCO2!),
                                style: TextStyle(color: _catColor(_selectedFactor!.category), fontSize: 26, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(_emissionService.getImpactLevel(_calculatedCO2!),
                                style: const TextStyle(color: EcoTheme.textSecondary, fontSize: 13)),
                            ]),
                            const Spacer(),
                            Expanded(child: Text(_emissionService.getImpactExplanation(_calculatedCO2!),
                              style: const TextStyle(color: EcoTheme.textMuted, fontSize: 12), textAlign: TextAlign.right)),
                          ]),
                        ),
                      ],
                    ]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
