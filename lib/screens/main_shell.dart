import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/gamification_provider.dart';
import '../widgets/bottom_nav.dart';
import 'home/dashboard_screen.dart';
import 'calculator/calculator_screen.dart';
import 'activity/activity_logger_screen.dart';
import 'profile/profile_screen.dart';

/// Main shell screen with bottom navigation.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  bool _initialized = false;

  final _screens = const [
    DashboardScreen(),
    CalculatorScreen(),
    ActivityLoggerScreen(),
    ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _initProviders();
    }
  }

  Future<void> _initProviders() async {
    final authProv = context.read<AuthProvider>();
    final actProv = context.read<ActivityProvider>();
    final gamProv = context.read<GamificationProvider>();
    final user = authProv.user;
    if (user != null) {
      await actProv.initialize(user.id);
      gamProv.initialize(
        user.totalPoints,
        user.streakDays,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
