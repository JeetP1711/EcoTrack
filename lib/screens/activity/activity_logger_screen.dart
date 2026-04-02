import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../data/emission_data.dart';
import '../../models/emission_factor.dart';
import '../../providers/activity_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/activity_tile.dart';

/// Activity logger screen for quick-logging emissions.
class ActivityLoggerScreen extends StatefulWidget {
  const ActivityLoggerScreen({super.key});

  @override
  State<ActivityLoggerScreen> createState() => _ActivityLoggerScreenState();
}

class _ActivityLoggerScreenState extends State<ActivityLoggerScreen> {
  String _selectedCategory = 'Transport';
  EmissionFactor? _selectedFactor;
  final _valueController = TextEditingController();
  String _filter = 'All';

  final categories = ['Transport', 'Food', 'Energy'];

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
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

  void _showLogDialog() {
    _selectedFactor = null;
    _valueController.clear();
    _selectedCategory = 'Transport';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final factors = EmissionData.getByCategory(_selectedCategory);
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: EcoTheme.cardBg,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: EcoTheme.textMuted,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Log Activity',
                    style: TextStyle(color: EcoTheme.white, fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  // Category chips
                  Row(
                    children: categories.map((c) {
                      final sel = c == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setModalState(() {
                            _selectedCategory = c;
                            _selectedFactor = null;
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: sel ? _catColor(c) : EcoTheme.surfaceBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(_catIcon(c), size: 16,
                                  color: sel ? Colors.white : EcoTheme.textMuted),
                                const SizedBox(width: 6),
                                Text(c, style: TextStyle(
                                  color: sel ? Colors.white : EcoTheme.textMuted,
                                  fontWeight: FontWeight.w500, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Activity dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedFactor?.name,
                    dropdownColor: EcoTheme.surfaceBg,
                    style: const TextStyle(color: EcoTheme.white),
                    decoration: const InputDecoration(labelText: 'Select Activity',
                      labelStyle: TextStyle(color: EcoTheme.textSecondary)),
                    items: factors.map((f) => DropdownMenuItem(
                      value: f.name,
                      child: Text('${f.icon} ${f.name}'),
                    )).toList(),
                    onChanged: (v) => setModalState(() {
                      _selectedFactor = factors.firstWhere((f) => f.name == v);
                    }),
                  ),
                  const SizedBox(height: 16),
                  // Value input
                  TextField(
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: EcoTheme.white),
                    decoration: InputDecoration(
                      labelText: _selectedFactor != null
                        ? 'Amount (${_selectedFactor!.unit})' : 'Amount',
                      labelStyle: const TextStyle(color: EcoTheme.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 54,
                    child: ElevatedButton(
                      onPressed: _selectedFactor == null ? null : () async {
                        final val = double.tryParse(_valueController.text);
                        if (val == null || val <= 0) return;
                        final actProv = context.read<ActivityProvider>();
                        final authProv = context.read<AuthProvider>();
                        final gamProv = context.read<GamificationProvider>();
                        final dashProv = context.read<DashboardProvider>();
                        final nav = Navigator.of(ctx);
                        await actProv.logActivity(
                          category: _selectedFactor!.category,
                          name: _selectedFactor!.name,
                          value: val,
                          unit: _selectedFactor!.unit,
                        );
                        final user = authProv.user;
                        if (user != null && actProv.activities.isNotEmpty) {
                          final pts = gamProv.awardPoints(actProv.activities.first);
                          await authProv.addPoints(pts);
                        }
                        dashProv.refreshSuggestions(actProv.activities);
                        if (mounted) nav.pop();
                      },
                      child: const Text('Log Activity', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EcoTheme.darkGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Activity Log', style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 4),
                      Text('Your emission history', style: Theme.of(context).textTheme.bodyMedium),
                    ]),
                    GestureDetector(
                      onTap: _showLogDialog,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: EcoTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.add_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // Filter chips
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', ...categories].map((c) {
                      final sel = c == _filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _filter = c),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: sel ? (c == 'All' ? EcoTheme.greenPrimary : _catColor(c)) : EcoTheme.surfaceBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(c, style: TextStyle(
                              color: sel ? Colors.white : EcoTheme.textMuted,
                              fontWeight: FontWeight.w500, fontSize: 13)),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Activity list
              Expanded(
                child: Consumer<ActivityProvider>(
                  builder: (context, prov, _) {
                    final activities = _filter == 'All'
                      ? prov.activities
                      : prov.getActivitiesByCategory(_filter);
                    if (activities.isEmpty) {
                      return Center(child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_rounded, size: 56, color: EcoTheme.textMuted.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          const Text('No activities logged', style: TextStyle(color: EcoTheme.textSecondary, fontSize: 16)),
                          const SizedBox(height: 8),
                          const Text('Tap + to log your first activity', style: TextStyle(color: EcoTheme.textMuted, fontSize: 13)),
                        ],
                      ));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                      itemCount: activities.length,
                      itemBuilder: (ctx, i) => ActivityTile(
                        activity: activities[i],
                        onDelete: () => prov.deleteActivity(activities[i].id),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
