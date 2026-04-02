import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'core/constants.dart';
import 'providers/auth_provider.dart';
import 'providers/activity_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/gamification_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcoTrackApp());
}

/// Root application widget.
class EcoTrackApp extends StatelessWidget {
  const EcoTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: EcoTheme.darkTheme,
        initialRoute: AppConstants.splashRoute,
        routes: {
          AppConstants.splashRoute: (_) => const SplashScreen(),
          AppConstants.loginRoute: (_) => const LoginScreen(),
          AppConstants.signupRoute: (_) => const SignupScreen(),
          AppConstants.homeRoute: (_) => const MainShell(),
        },
      ),
    );
  }
}
