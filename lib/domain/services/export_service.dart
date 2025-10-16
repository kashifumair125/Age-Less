// lib/domain/services/export_service.dart
import 'dart:convert';
import '../models/daily_tracking.dart';
import '../models/biological_age_assessment.dart';

class ExportService {
  /// Export data as JSON
  String exportAsJson({
    required List<DailyTracking> trackingHistory,
    required List<BiologicalAgeAssessment> assessments,
  }) {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'trackingHistory': trackingHistory
          .map(
            (t) => {
              'date': t.date.toIso8601String(),
              'nutrition': t.nutrition != null
                  ? {
                      'calories': t.nutrition!.caloriesConsumed,
                      'protein': t.nutrition!.proteinGrams,
                      'vegetables': t.nutrition!.vegetables,
                      'fastingCompleted': t.nutrition!.fastingCompleted,
                    }
                  : null,
              'exercise': t.exercise != null
                  ? {
                      'totalMinutes': t.exercise!.totalMinutes,
                      'sessions': t.exercise!.sessions.length,
                    }
                  : null,
              'sleep': t.sleep != null
                  ? {
                      'hours': t.sleep!.hoursSlept,
                      'quality': t.sleep!.sleepQuality,
                    }
                  : null,
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
            },
          )
          .toList(),
    };

    return JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export data as CSV
  String exportAsCSV(List<DailyTracking> trackingHistory) {
    final buffer = StringBuffer();

    // Headers
    buffer.writeln(
      'Date,Calories,Protein,Carbs,Fat,Exercise Minutes,Sleep Hours,Sleep Quality,Stress Level',
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
        ].join(','),
      );
    }

    return buffer.toString();
  }
}
