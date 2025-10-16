class BiologicalAgeAssessment {
  final DateTime assessmentDate;
  final double biologicalAge;
  final double chronologicalAge;
  final double ageDifference; // biological - chronological
  final List<String> topWeaknesses; // e.g., ['nutrition','sleep']

  const BiologicalAgeAssessment({
    required this.assessmentDate,
    required this.biologicalAge,
    required this.chronologicalAge,
    required this.ageDifference,
    required this.topWeaknesses,
  });
}
