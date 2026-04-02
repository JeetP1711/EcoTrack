import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/activity_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../services/emission_service.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/activity_tile.dart';
import '../../widgets/suggestion_card.dart';
import '../../widgets/charts/emission_bar_chart.dart';
import '../../widgets/charts/category_pie_chart.dart';
import '../../core/constants.dart';

/// Home dashboard screen showing emission stats, charts, and suggestions.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final EmissionService _emissionService = EmissionService();

  @override
  void initState() {
    super.initState();
    // Refresh suggestions on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final activityProvider = context.read<ActivityProvider>();
      context
          .read<DashboardProvider>()
          .refreshSuggestions(activityProvider.activities);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EcoTheme.darkGradient),
        child: SafeArea(
          child: Consumer2<ActivityProvider, DashboardProvider>(
            builder: (context, activityProv, dashProv, _) {
              final period = dashProv.selectedPeriod;
              final categoryData =
                  activityProv.getEmissionsByCategory(period: period);
              final weeklyData = activityProv.getDailyEmissionsForWeek();
              final recentActivities =
                  activityProv.getRecentActivities(limit: 5);

              double currentEmissions;
              switch (period) {
                case 'Weekly':
                  currentEmissions = activityProv.weeklyEmissions;
                  break;
                case 'Monthly':
                  currentEmissions = activityProv.monthlyEmissions;
                  break;
                default:
                  currentEmissions = activityProv.todayEmissions;
              }

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ─── Header ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dashboard',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Track your carbon footprint',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: EcoTheme.surfaceBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.notifications_none_rounded,
                              color: EcoTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Period Selector ────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: EcoTheme.surfaceBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: AppConstants.periods.map((p) {
                            final isSelected = p == period;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => dashProv.setPeriod(p),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? EcoTheme.greenPrimary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                  child: Center(
                                    child: Text(
                                      p,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : EcoTheme.textMuted,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // ─── Stat Cards ─────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: '$period Emissions',
                              value: _emissionService
                                  .formatCO2(currentEmissions),
                              subtitle: _emissionService
                                  .getImpactLevel(currentEmissions)
                                  .split(' ')
                                  .first,
                              icon: Icons.cloud_rounded,
                              isAccent: true,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: StatCard(
                              title: 'Activities',
                              value: activityProv.totalActivitiesCount
                                  .toString(),
                              subtitle: 'Total',
                              icon: Icons.timeline_rounded,
                              iconColor: EcoTheme.info,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Bar Chart ──────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: EmissionBarChart(data: weeklyData),
                    ),
                  ),

                  // ─── Pie Chart ──────────────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                      child: CategoryPieChart(data: categoryData),
                    ),
                  ),

                  // ─── Smart Suggestions ──────────────────────────
                  if (dashProv.suggestions.isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Text(
                          '💡 Smart Suggestions',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 190,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                          itemCount: dashProv.suggestions.length,
                          itemBuilder: (context, index) {
                            return SuggestionCard(
                              suggestion: dashProv.suggestions[index],
                            );
                          },
                        ),
                      ),
                    ),
                  ],

                  // ─── Recent Activities ──────────────────────────
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Activities',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (recentActivities.isNotEmpty)
                            Text(
                              'Last ${recentActivities.length}',
                              style: const TextStyle(
                                color: EcoTheme.textMuted,
                                fontSize: 13,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  if (recentActivities.isEmpty)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: EcoTheme.glassCard,
                          child: Column(
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                size: 48,
                                color: EcoTheme.greenPrimary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No activities yet',
                                style: TextStyle(
                                  color: EcoTheme.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Start logging your daily activities\nto track your carbon footprint',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: EcoTheme.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => ActivityTile(
                            activity: recentActivities[index],
                          ),
                          childCount: recentActivities.length,
                        ),
                      ),
                    ),

                  // Bottom padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 20),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
