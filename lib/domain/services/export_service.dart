// lib/domain/services/export_service.dart
import 'dart:convert';
import '../models/daily_tracking.dart';
import '../models/biological_age_assessment.dart';
import '../models/user_profile.dart';

class ExportService {
  /// Export all user data to JSON format
  String exportAsJson({
    UserProfile? profile,
    required List<DailyTracking> trackingHistory,
    required List<BiologicalAgeAssessment> assessments,
  }) {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
      'profile': profile != null
          ? {
              'name': profile.name,
              'email': profile.email,
              'birthDate': profile.birthDate?.toIso8601String(),
              'heightCm': profile.heightCm,
              'weightKg': profile.weightKg,
              'gender': profile.gender,
            }
          : null,
      'trackingHistory': trackingHistory
          .map(
            (t) => {
              'date': t.date.toIso8601String(),
              'nutrition': t.nutrition != null
                  ? {
                      'caloriesConsumed': t.nutrition!.caloriesConsumed,
                      'proteinGrams': t.nutrition!.proteinGrams,
                      'vegetables': t.nutrition!.vegetables,
                      'fastingCompleted': t.nutrition!.fastingCompleted,
                    }
                  : null,
              'exercise': t.exercise != null
                  ? {
                      'totalMinutes': t.exercise!.totalMinutes,
                      'sessions': t.exercise!.sessions
                          .map((s) => {
                                'type': s.type,
                                'durationMinutes': s.minutes,
                                'intensity': s.intensity,
                              })
                          .toList(),
                    }
                  : null,
              'sleep': t.sleep != null
                  ? {
                      'hoursSlept': t.sleep!.hoursSlept,
                      'sleepQuality': t.sleep!.sleepQuality,
                    }
                  : null,
              'stress': t.stress != null
                  ? {
                      'stressLevel': t.stress!.stressLevel,
                      'meditationMinutes': t.stress!.meditationMinutes,
                    }
                  : null,
              'supplements': t.supplements,
            },
          )
          .toList(),
      'assessments': assessments
          .map(
            (a) => {
              'date': a.assessmentDate.toIso8601String(),
              'biologicalAge': a.biologicalAge,
              'chronologicalAge': a.chronologicalAge,
              'ageDifference': a.ageDifference,
              'topWeaknesses': a.topWeaknesses,
              'categoryScores': a.categoryScores,
            },
          )
          .toList(),
    };

    return JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export tracking data as CSV
  String exportAsCSV(List<DailyTracking> trackingHistory) {
    final buffer = StringBuffer();

    // Headers
    buffer.writeln(
      'Date,Calories,Protein (g),Vegetables,Fasting,Exercise (min),Sleep (hrs),Sleep Quality,Stress Level,Meditation (min)',
    );

    // Data rows
    for (var tracking in trackingHistory) {
      buffer.writeln(
        [
          tracking.date.toIso8601String().split('T')[0],
          tracking.nutrition?.caloriesConsumed ?? '',
          tracking.nutrition?.proteinGrams ?? '',
          tracking.nutrition?.vegetables ?? '',
          tracking.nutrition?.fastingCompleted ?? '',
          tracking.exercise?.totalMinutes ?? '',
          tracking.sleep?.hoursSlept ?? '',
          tracking.sleep?.sleepQuality ?? '',
          tracking.stress?.stressLevel ?? '',
          tracking.stress?.meditationMinutes ?? '',
        ].join(','),
      );
    }

    return buffer.toString();
  }

  /// Export assessment history to CSV format
  String exportAssessmentsAsCSV(List<BiologicalAgeAssessment> assessments) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
        'Date,Biological Age,Chronological Age,Age Difference,Nutrition Score,Exercise Score,Sleep Score,Stress Score,Social Score,Top Weaknesses');

    // Data rows
    for (var assessment in assessments) {
      final date = assessment.assessmentDate.toIso8601String().split('T')[0];
      final bioAge = assessment.biologicalAge.toStringAsFixed(1);
      final chronAge = assessment.chronologicalAge.toStringAsFixed(1);
      final diff = assessment.ageDifference.toStringAsFixed(1);
      final nutrition =
          (assessment.categoryScores['nutrition'] ?? 0).toStringAsFixed(1);
      final exercise =
          (assessment.categoryScores['exercise'] ?? 0).toStringAsFixed(1);
      final sleep =
          (assessment.categoryScores['sleep'] ?? 0).toStringAsFixed(1);
      final stress =
          (assessment.categoryScores['stress'] ?? 0).toStringAsFixed(1);
      final social =
          (assessment.categoryScores['social'] ?? 0).toStringAsFixed(1);
      final weaknesses = assessment.topWeaknesses.join(';');

      buffer.writeln(
          '$date,$bioAge,$chronAge,$diff,$nutrition,$exercise,$sleep,$stress,$social,"$weaknesses"');
    }

    return buffer.toString();
  }

  /// Create a backup (same as JSON export but optimized for restore)
  String createBackup({
    UserProfile? profile,
    required List<DailyTracking> trackingHistory,
    required List<BiologicalAgeAssessment> assessments,
  }) {
    return exportAsJson(
      profile: profile,
      trackingHistory: trackingHistory,
      assessments: assessments,
    );
  }

  /// Restore data from JSON backup
  /// Returns a map with 'profile', 'trackingHistory', and 'assessments'
  Map<String, dynamic> restoreFromBackup(String jsonBackup) {
    try {
      final data = jsonDecode(jsonBackup) as Map<String, dynamic>;

      // Parse profile
      UserProfile? profile;
      if (data['profile'] != null) {
        final profileData = data['profile'] as Map<String, dynamic>;
        profile = UserProfile(
          name: profileData['name'] as String? ?? '',
          email: profileData['email'] as String? ?? '',
          birthDate: profileData['birthDate'] != null
              ? DateTime.parse(profileData['birthDate'] as String)
              : null,
          heightCm: (profileData['heightCm'] as num?)?.toDouble(),
          weightKg: (profileData['weightKg'] as num?)?.toDouble(),
          gender: profileData['gender'] as String?,
        );
      }

      // Parse tracking history
      final trackingList = <DailyTracking>[];
      if (data['trackingHistory'] != null) {
        for (final t in data['trackingHistory'] as List) {
          final tMap = t as Map<String, dynamic>;
          trackingList.add(DailyTracking(
            date: DateTime.parse(tMap['date'] as String),
            nutrition: tMap['nutrition'] != null
                ? _parseNutrition(tMap['nutrition'] as Map<String, dynamic>)
                : null,
            exercise: tMap['exercise'] != null
                ? _parseExercise(tMap['exercise'] as Map<String, dynamic>)
                : null,
            sleep: tMap['sleep'] != null
                ? _parseSleep(tMap['sleep'] as Map<String, dynamic>)
                : null,
            stress: tMap['stress'] != null
                ? _parseStress(tMap['stress'] as Map<String, dynamic>)
                : null,
            supplements: tMap['supplements'] != null
                ? _parseSupplements(tMap['supplements'] as List)
                : null,
          ));
        }
      }

      // Parse assessments
      final assessmentList = <BiologicalAgeAssessment>[];
      if (data['assessments'] != null) {
        for (final a in data['assessments'] as List) {
          final aMap = a as Map<String, dynamic>;
          assessmentList.add(BiologicalAgeAssessment(
            assessmentDate: DateTime.parse(aMap['date'] as String),
            biologicalAge: (aMap['biologicalAge'] as num).toDouble(),
            chronologicalAge: (aMap['chronologicalAge'] as num).toDouble(),
            ageDifference: (aMap['ageDifference'] as num).toDouble(),
            topWeaknesses: (aMap['topWeaknesses'] as List).cast<String>(),
            categoryScores: Map<String, double>.from(
              (aMap['categoryScores'] as Map).map(
                (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
              ),
            ),
          ));
        }
      }

      return {
        'profile': profile,
        'trackingHistory': trackingList,
        'assessments': assessmentList,
      };
    } catch (e) {
      throw Exception('Failed to restore backup: $e');
    }
  }

  NutritionLog _parseNutrition(Map<String, dynamic> data) {
    return NutritionLog(
      caloriesConsumed: (data['caloriesConsumed'] as num?)?.toInt() ?? 0,
      proteinGrams: (data['proteinGrams'] as num?)?.toDouble() ?? 0.0,
      vegetables: (data['vegetables'] as num?)?.toInt() ?? 0,
      fastingCompleted: data['fastingCompleted'] as bool? ?? false,
    );
  }

  ExerciseLog _parseExercise(Map<String, dynamic> data) {
    final sessions = <WorkoutSession>[];
    if (data['sessions'] != null) {
      for (final s in data['sessions'] as List) {
        final sMap = s as Map<String, dynamic>;
        sessions.add(WorkoutSession(
          type: sMap['type'] as String? ?? 'General',
          minutes: (sMap['durationMinutes'] as num?)?.toInt() ?? 0,
          intensity: (sMap['intensity'] as num?)?.toInt() ?? 5,
        ));
      }
    }
    return ExerciseLog(
      totalMinutes: (data['totalMinutes'] as num?)?.toInt() ?? 0,
      sessions: sessions,
    );
  }

  SleepLog _parseSleep(Map<String, dynamic> data) {
    return SleepLog(
      hoursSlept: (data['hoursSlept'] as num?)?.toDouble() ?? 0.0,
      sleepQuality: (data['sleepQuality'] as num?)?.toInt() ?? 5,
    );
  }

  StressLog _parseStress(Map<String, dynamic> data) {
    return StressLog(
      stressLevel: (data['stressLevel'] as num?)?.toInt() ?? 5,
      meditated: data['meditated'] as bool? ?? false,
      meditationMinutes: (data['meditationMinutes'] as num?)?.toInt() ?? 0,
    );
  }

  SupplementLog? _parseSupplements(List data) {
    if (data.isEmpty) return null;
    return SupplementLog(
      supplementsTaken: data.cast<String>(),
    );
  }
}
