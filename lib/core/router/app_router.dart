// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../data/local/hive_config.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/main/main_screen.dart';
import '../../presentation/screens/assessment/assessment_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final settingsListenable = HiveConfig.settingsBox.listenable(
    keys: [AppConstants.hasCompletedOnboardingKey],
  );

  return GoRouter(
    initialLocation: '/main',
    refreshListenable: settingsListenable,
    redirect: (context, state) {
      final box = HiveConfig.settingsBox;
      final hasCompleted = box.get(AppConstants.hasCompletedOnboardingKey,
          defaultValue: false) as bool;
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (!hasCompleted && !isOnboarding) {
        return '/onboarding';
      }

      if (hasCompleted && isOnboarding) {
        return '/main';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/main', builder: (context, state) => const MainScreen()),
      GoRoute(
        path: '/assessment',
        builder: (context, state) => const AssessmentScreen(),
      ),
    ],
  );
});
