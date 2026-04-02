import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/activity_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../services/emission_service.dart';
import '../../widgets/eco_progress_bar.dart';

/// Profile screen with user info, gamification stats, and settings.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emissionService = EmissionService();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: EcoTheme.darkGradient),
        child: SafeArea(
          child: Consumer3<AuthProvider, ActivityProvider, GamificationProvider>(
            builder: (context, authProv, actProv, gamProv, _) {
              final user = authProv.user;
              if (user == null) return const SizedBox.shrink();

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Avatar
                    Container(
                      width: 90, height: 90,
                      decoration: BoxDecoration(
                        gradient: EcoTheme.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                          color: EcoTheme.greenPrimary.withValues(alpha: 0.3),
                          blurRadius: 20, offset: const Offset(0, 8),
                        )],
                      ),
                      child: Center(
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 4),
                    Text(user.email, style: Theme.of(context).textTheme.bodyMedium),

                    const SizedBox(height: 28),

                    // Level card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: EcoTheme.accentCard,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('Current Level', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 4),
                                Text(gamProv.levelName, style: const TextStyle(
                                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                              ]),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text('🌿', style: const TextStyle(fontSize: 28)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          EcoProgressBar(
                            progress: gamProv.progressToNextLevel,
                            label: 'Progress to next level',
                            trailingText: '${gamProv.pointsToNextLevel} pts to go',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Stats grid
                    Row(children: [
                      _StatBox(label: 'Total Points', value: '${gamProv.totalPoints}',
                        icon: Icons.stars_rounded, color: EcoTheme.warning),
                      const SizedBox(width: 12),
                      _StatBox(label: 'Activities', value: '${actProv.totalActivitiesCount}',
                        icon: Icons.timeline_rounded, color: EcoTheme.info),
                    ]),
                    const SizedBox(height: 12),
                    Row(children: [
                      _StatBox(label: 'Total CO₂', value: emissionService.formatCO2(actProv.totalEmissions),
                        icon: Icons.cloud_rounded, color: EcoTheme.greenLight),
                      const SizedBox(width: 12),
                      _StatBox(label: 'Streak', value: '${gamProv.streakDays} days',
                        icon: Icons.local_fire_department_rounded, color: EcoTheme.foodColor),
                    ]),

                    const SizedBox(height: 28),

                    // Eco tips
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: EcoTheme.glassCard,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('🌍 Daily Eco Tip', style: TextStyle(
                            color: EcoTheme.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 12),
                          const Text(
                            'Did you know? If everyone chose plant-based meals one day a week, '
                            'it could reduce global food emissions by 5-10%. '
                            'Start with Meatless Mondays!',
                            style: TextStyle(color: EcoTheme.textSecondary, fontSize: 14, height: 1.5),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Logout button
                    SizedBox(
                      width: double.infinity, height: 54,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await authProv.logout();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacementNamed(AppConstants.loginRoute);
                          }
                        },
                        icon: const Icon(Icons.logout_rounded, color: EcoTheme.error),
                        label: const Text('Sign Out', style: TextStyle(color: EcoTheme.error, fontSize: 16)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: EcoTheme.error.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: EcoTheme.glassCard,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(color: EcoTheme.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: EcoTheme.textSecondary, fontSize: 12)),
        ]),
      ),
    );
  }
}
