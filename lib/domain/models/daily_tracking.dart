import 'package:hive/hive.dart';

part 'daily_tracking.g.dart';

@HiveType(typeId: 1)
class DailyTracking {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final NutritionLog? nutrition;

  @HiveField(2)
  final ExerciseLog? exercise;

  @HiveField(3)
  final SleepLog? sleep;

  @HiveField(4)
  final StressLog? stress;

  @HiveField(5)
  final SupplementLog? supplements;

  const DailyTracking({
    required this.date,
    this.nutrition,
    this.exercise,
    this.sleep,
    this.stress,
    this.supplements,
  });
}

@HiveType(typeId: 2)
class NutritionLog {
  @HiveField(0)
  final int caloriesConsumed;

  @HiveField(1)
  final double proteinGrams;

  @HiveField(2)
  final int vegetables;

  @HiveField(3)
  final bool fastingCompleted;

  const NutritionLog({
    required this.caloriesConsumed,
    required this.proteinGrams,
    required this.vegetables,
    required this.fastingCompleted,
  });
}

@HiveType(typeId: 3)
class ExerciseLog {
  @HiveField(0)
  final int totalMinutes;

  @HiveField(1)
  final List<WorkoutSession> sessions;

  const ExerciseLog({
    required this.totalMinutes,
    required this.sessions,
  });
}

@HiveType(typeId: 4)
class WorkoutSession {
  @HiveField(0)
  final String type; // e.g., HIIT, Strength, Cardio

  @HiveField(1)
  final int minutes;

  @HiveField(2)
  final int intensity; // 1-10

  const WorkoutSession({
    required this.type,
    required this.minutes,
    required this.intensity,
  });
}

@HiveType(typeId: 5)
class SleepLog {
  @HiveField(0)
  final double hoursSlept;

  @HiveField(1)
  final int sleepQuality; // 1-10

  const SleepLog({
    required this.hoursSlept,
    required this.sleepQuality,
  });
}

@HiveType(typeId: 6)
class StressLog {
  @HiveField(0)
  final int stressLevel; // 1-10

  @HiveField(1)
  final bool meditated;

  @HiveField(2)
  final int meditationMinutes;

  const StressLog({
    required this.stressLevel,
    required this.meditated,
    required this.meditationMinutes,
  });
}

@HiveType(typeId: 7)
class SupplementLog {
  @HiveField(0)
  final List<String> supplementsTaken; // names or ids

  const SupplementLog({
    required this.supplementsTaken,
  });
}

