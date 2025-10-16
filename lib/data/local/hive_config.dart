// lib/data/local/hive_config.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/daily_tracking.dart';

class HiveConfig {
  static const String userProfileBoxKey = 'userProfile';
  static const String dailyTrackingBoxKey = 'dailyTracking';
  static const String assessmentsBoxKey = 'assessments';
  static const String settingsBoxKey = 'settings';

  static Future<void> initialize() async {
    // Register adapters
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(DailyTrackingAdapter());
    Hive.registerAdapter(NutritionLogAdapter());
    Hive.registerAdapter(ExerciseLogAdapter());
    Hive.registerAdapter(WorkoutSessionAdapter());
    Hive.registerAdapter(SleepLogAdapter());
    Hive.registerAdapter(StressLogAdapter());
    Hive.registerAdapter(SupplementLogAdapter());

    // Open boxes (unencrypted; TODO: add secure key when available)
    await Hive.openBox<UserProfile>(userProfileBoxKey);
    await Hive.openBox<DailyTracking>(dailyTrackingBoxKey);
    await Hive.openBox(assessmentsBoxKey);
    await Hive.openBox(settingsBoxKey);
  }

  static Box<UserProfile> get userProfileBox =>
      Hive.box<UserProfile>(HiveConfig.userProfileBoxKey);

  static Box<DailyTracking> get dailyTrackingBox =>
      Hive.box<DailyTracking>(HiveConfig.dailyTrackingBoxKey);

  static Box get assessmentsBox => Hive.box(HiveConfig.assessmentsBoxKey);

  static Box get settingsBox => Hive.box(HiveConfig.settingsBoxKey);
}
