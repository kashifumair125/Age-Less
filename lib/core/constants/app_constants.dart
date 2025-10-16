// lib/core/constants/app_constants.dart
class AppConstants {
  // App Info
  static const String appName = 'AgeLess';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Reverse Your Biological Age';

  // Biological Age Ranges
  static const double minBiologicalAgeReduction = -15.0;
  static const double maxBiologicalAgeIncrease = 15.0;

  // Tracking Targets
  static const int dailyCalorieTarget = 2000;
  static const double dailyProteinTarget = 150.0;
  static const int dailyVegetableTarget = 7;
  static const int weeklyExerciseMinutesTarget = 180;
  static const double optimalSleepHours = 8.0;
  static const int dailyMeditationTarget = 20;

  // Assessment
  static const int assessmentSections = 8;
  static const int minAssessmentGap = 7; // days

  // Achievements Points
  static const int streak7Points = 50;
  static const int streak30Points = 200;
  static const int workout50Points = 150;
  static const int perfectWeekPoints = 100;

  // Links
  static const String privacyPolicyUrl = 'https://ageless.com/privacy';
  static const String termsOfServiceUrl = 'https://ageless.com/terms';
  static const String supportEmail = 'support@ageless.com';

  // Onboarding
  static const String hasCompletedOnboardingKey = 'hasCompletedOnboarding';
}

class AssessmentCategories {
  static const List<String> keys = [
    'nutrition',
    'exercise',
    'sleep',
    'stress',
    'social',
  ];
}
