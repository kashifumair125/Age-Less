class BiologicalAgeAssessment {
  final DateTime assessmentDate;
  final double biologicalAge;
  final double chronologicalAge;
  final double ageDifference; // biological - chronological
  final List<String> topWeaknesses; // e.g., ['nutrition','sleep']
  final Map<String, double> categoryScores; // e.g., {'nutrition': 7.5, 'exercise': 8.0, ...}

  const BiologicalAgeAssessment({
    required this.assessmentDate,
    required this.biologicalAge,
    required this.chronologicalAge,
    required this.ageDifference,
    required this.topWeaknesses,
    required this.categoryScores,
  });
}
