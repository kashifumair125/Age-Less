// lib/presentation/widgets/progress/monthly_report.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/daily_tracking.dart';
import '../../../domain/models/assessment.dart';
import '../../../core/utils/animations.dart';
import '../../../core/utils/haptics.dart';

class MonthlyReport extends StatelessWidget {
  final List<DailyTracking> monthData;
  final List<Assessment> monthAssessments;
  final DateTime month;

  const MonthlyReport({
    Key? key,
    required this.monthData,
    required this.monthAssessments,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = _calculateMonthlyStats();
    final insights = _generateInsights(stats);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Report',
                    style: AppTextStyles.h2.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMMM yyyy').format(month),
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              AnimatedButton(
                onPressed: () {
                  AppHaptics.medium();
                  _exportToPDF(context, stats, insights);
                },
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppHaptics.medium();
                    _exportToPDF(context, stats, insights);
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Key Metrics
          _buildMetricRow(
            'Active Days',
            '${stats.activeDays}/${DateTime(month.year, month.month + 1, 0).day}',
            Icons.calendar_today,
            Colors.blue,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildMetricRow(
            'Total Exercise',
            '${stats.totalExerciseMinutes} min',
            Icons.fitness_center,
            Colors.orange,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildMetricRow(
            'Avg Sleep Quality',
            '${stats.avgSleepQuality.toStringAsFixed(1)}/10',
            Icons.bedtime,
            Colors.purple,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildMetricRow(
            'Bio Age Change',
            stats.bioAgeChange >= 0
                ? '+${stats.bioAgeChange.toStringAsFixed(1)} years'
                : '${stats.bioAgeChange.toStringAsFixed(1)} years',
            Icons.favorite,
            stats.bioAgeChange <= 0 ? Colors.green : Colors.red,
          ),

          const Divider(height: 32),

          // AI-Generated Insights
          Text(
            'Key Insights',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          ...insights.map((insight) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  insight.icon,
                  size: 20,
                  color: insight.color,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.message,
                    style: AppTextStyles.body2,
                  ),
                ),
              ],
            ),
          )),

          const Divider(height: 32),

          // Achievements
          Text(
            'Achievements Unlocked',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          if (stats.achievements.isEmpty)
            Text(
              'No achievements this month. Keep pushing!',
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: stats.achievements.map((achievement) => Chip(
                avatar: Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                label: Text(achievement),
                backgroundColor: Colors.amber.withOpacity(0.2),
              )).toList(),
            ),

          const Divider(height: 32),

          // Areas Needing Attention
          Text(
            'Areas for Improvement',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          ...stats.improvementAreas.map((area) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: AppBorderRadius.small,
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      area,
                      style: AppTextStyles.body2.copyWith(color: Colors.orange.shade800),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: AppBorderRadius.small,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(label, style: AppTextStyles.body2),
        ),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  MonthlyStats _calculateMonthlyStats() {
    int activeDays = monthData.where((d) =>
      d.exercise != null || d.nutrition != null || d.sleep != null
    ).length;

    int totalExerciseMinutes = monthData.fold(0, (sum, d) =>
      sum + (d.exercise?.totalMinutes ?? 0)
    );

    double totalSleepQuality = monthData.fold(0.0, (sum, d) =>
      sum + (d.sleep?.sleepQuality ?? 0).toDouble()
    );
    double avgSleepQuality = monthData.isEmpty ? 0 : totalSleepQuality / monthData.length;

    double bioAgeChange = 0;
    if (monthAssessments.length >= 2) {
      final firstAssessment = monthAssessments.first;
      final lastAssessment = monthAssessments.last;
      bioAgeChange = lastAssessment.biologicalAge - firstAssessment.biologicalAge;
    }

    List<String> achievements = _determineAchievements(
      activeDays,
      totalExerciseMinutes,
      avgSleepQuality,
      bioAgeChange,
    );

    List<String> improvementAreas = _determineImprovementAreas();

    return MonthlyStats(
      activeDays: activeDays,
      totalExerciseMinutes: totalExerciseMinutes,
      avgSleepQuality: avgSleepQuality,
      bioAgeChange: bioAgeChange,
      achievements: achievements,
      improvementAreas: improvementAreas,
    );
  }

  List<String> _determineAchievements(
    int activeDays,
    int totalExercise,
    double sleepQuality,
    double bioAgeChange,
  ) {
    List<String> achievements = [];

    if (activeDays >= 25) achievements.add('Consistency Master');
    if (totalExercise >= 600) achievements.add('Fitness Warrior');
    if (sleepQuality >= 8.0) achievements.add('Sleep Champion');
    if (bioAgeChange < -0.5) achievements.add('Age Reversal');
    if (activeDays == DateTime(month.year, month.month + 1, 0).day) {
      achievements.add('Perfect Month');
    }

    return achievements;
  }

  List<String> _determineImprovementAreas() {
    List<String> areas = [];

    int daysWithExercise = monthData.where((d) => d.exercise != null).length;
    int daysWithGoodSleep = monthData.where((d) =>
      d.sleep != null && d.sleep!.hoursSlept >= 7
    ).length;
    int daysWithLowStress = monthData.where((d) =>
      d.stress != null && d.stress!.stressLevel <= 5
    ).length;

    if (daysWithExercise < 20) {
      areas.add('Increase exercise frequency - aim for 5+ days/week');
    }
    if (daysWithGoodSleep < 20) {
      areas.add('Prioritize sleep - target 7+ hours consistently');
    }
    if (daysWithLowStress < 15) {
      areas.add('Manage stress better - try meditation or breathing exercises');
    }

    if (areas.isEmpty) {
      areas.add('Great job! Keep up the excellent work across all areas');
    }

    return areas;
  }

  List<MonthlyInsight> _generateInsights(MonthlyStats stats) {
    List<MonthlyInsight> insights = [];

    if (stats.activeDays >= 25) {
      insights.add(MonthlyInsight(
        message: 'Outstanding consistency with ${stats.activeDays} active days!',
        icon: Icons.star,
        color: Colors.amber,
      ));
    }

    if (stats.bioAgeChange < 0) {
      insights.add(MonthlyInsight(
        message: 'You reversed your biological age by ${stats.bioAgeChange.abs().toStringAsFixed(1)} years!',
        icon: Icons.trending_down,
        color: Colors.green,
      ));
    }

    if (stats.totalExerciseMinutes >= 600) {
      insights.add(MonthlyInsight(
        message: 'Logged ${stats.totalExerciseMinutes} minutes of exercise - impressive!',
        icon: Icons.fitness_center,
        color: Colors.blue,
      ));
    }

    if (insights.isEmpty) {
      insights.add(MonthlyInsight(
        message: 'Track more consistently to unlock personalized insights',
        icon: Icons.lightbulb_outline,
        color: Colors.grey,
      ));
    }

    return insights;
  }

  void _exportToPDF(BuildContext context, MonthlyStats stats, List<MonthlyInsight> insights) {
    // Show a dialog for now - full PDF implementation would require pdf package
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            const Text('Export Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Report - ${DateFormat('MMMM yyyy').format(month)}',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Text('Active Days: ${stats.activeDays}'),
            Text('Exercise: ${stats.totalExerciseMinutes} min'),
            Text('Sleep Quality: ${stats.avgSleepQuality.toStringAsFixed(1)}/10'),
            Text('Bio Age Change: ${stats.bioAgeChange.toStringAsFixed(1)} years'),
            const SizedBox(height: 16),
            Text(
              'PDF export functionality coming soon!',
              style: AppTextStyles.caption.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class MonthlyStats {
  final int activeDays;
  final int totalExerciseMinutes;
  final double avgSleepQuality;
  final double bioAgeChange;
  final List<String> achievements;
  final List<String> improvementAreas;

  MonthlyStats({
    required this.activeDays,
    required this.totalExerciseMinutes,
    required this.avgSleepQuality,
    required this.bioAgeChange,
    required this.achievements,
    required this.improvementAreas,
  });
}

class MonthlyInsight {
  final String message;
  final IconData icon;
  final Color color;

  MonthlyInsight({
    required this.message,
    required this.icon,
    required this.color,
  });
}
