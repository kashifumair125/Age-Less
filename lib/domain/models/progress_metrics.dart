class DataPoint {
  final DateTime date;
  final double value;

  const DataPoint({
    required this.date,
    required this.value,
  });
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji or icon key
  final DateTime unlockedAt;
  final int points;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlockedAt,
    required this.points,
  });
}

class ProgressMetrics {
  final DateTime startDate;
  final DateTime currentDate;
  final double initialBiologicalAge;
  final double currentBiologicalAge;
  final double ageReduction;
  final Map<String, List<DataPoint>> categoryTrends;
  final List<Achievement> achievements;
  final int currentStreak;
  final int longestStreak;

  const ProgressMetrics({
    required this.startDate,
    required this.currentDate,
    required this.initialBiologicalAge,
    required this.currentBiologicalAge,
    required this.ageReduction,
    required this.categoryTrends,
    required this.achievements,
    required this.currentStreak,
    required this.longestStreak,
  });
}
