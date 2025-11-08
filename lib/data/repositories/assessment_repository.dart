// lib/data/repositories/assessment_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/models/biological_age_assessment.dart';
import '../local/hive_config.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository(HiveConfig.assessmentsBox);
});

class AssessmentRepository {
  final Box _box;
  AssessmentRepository(this._box);

  Future<void> saveAssessment(BiologicalAgeAssessment assessment) async {
    await _box.add({
      'date': assessment.assessmentDate.toIso8601String(),
      'biologicalAge': assessment.biologicalAge,
      'chronologicalAge': assessment.chronologicalAge,
      'ageDifference': assessment.ageDifference,
      'weaknesses': assessment.topWeaknesses,
      'categoryScores': assessment.categoryScores,
    });
  }

  Future<List<BiologicalAgeAssessment>> getAssessments() async {
    final items = <BiologicalAgeAssessment>[];
    for (final v in _box.values) {
      if (v is Map) {
        // Parse category scores with fallback for old data
        final categoryScoresRaw = v['categoryScores'];
        final Map<String, double> categoryScores;
        if (categoryScoresRaw is Map) {
          categoryScores = Map<String, double>.from(
            categoryScoresRaw.map((key, value) =>
              MapEntry(key.toString(), (value as num).toDouble())
            ),
          );
        } else {
          // Fallback for old assessments without category scores
          categoryScores = {
            'nutrition': 5.0,
            'exercise': 5.0,
            'sleep': 5.0,
            'stress': 5.0,
            'social': 5.0,
          };
        }

        items.add(BiologicalAgeAssessment(
          assessmentDate: DateTime.parse(v['date'] as String),
          biologicalAge: (v['biologicalAge'] as num).toDouble(),
          chronologicalAge: (v['chronologicalAge'] as num).toDouble(),
          ageDifference: (v['ageDifference'] as num).toDouble(),
          topWeaknesses:
              (v['weaknesses'] as List?)?.cast<String>() ?? const <String>[],
          categoryScores: categoryScores,
        ));
      }
    }
    // sort by date ascending
    items.sort((a, b) => a.assessmentDate.compareTo(b.assessmentDate));
    return items;
  }

  Future<BiologicalAgeAssessment?> getLatestAssessment() async {
    final list = await getAssessments();
    return list.isEmpty ? null : list.last;
  }
}
