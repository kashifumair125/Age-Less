import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/biological_age_assessment.dart';
import '../../../domain/models/progress_metrics.dart';

class MonthlyReport extends StatelessWidget {
  final List<BiologicalAgeAssessment> monthAssessments;
  final List<Achievement> monthAchievements;
  final Map<String, dynamic> monthStats;

  const MonthlyReport({
    Key? key,
    required this.monthAssessments,
    required this.monthAchievements,
    required this.monthStats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.1),
                  AppTheme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.summarize, color: AppTheme.primaryColor),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Monthly Report', style: AppTextStyles.h3),
                        Text(
                          _getCurrentMonthYear(),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () => _downloadReport(context),
                  color: AppTheme.primaryColor,
                  tooltip: 'Download PDF',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI-Generated Summary
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.05),
                    borderRadius: AppBorderRadius.medium,
                    border: Border.all(
                      color: AppTheme.secondaryColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor.withOpacity(0.2),
                          borderRadius: AppBorderRadius.small,
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: AppTheme.secondaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Insights',
                              style: AppTextStyles.body1.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              insights['summary'],
                              style: AppTextStyles.body2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Key Achievements
                Text(
                  'Achievements This Month',
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                if (monthAchievements.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: AppBorderRadius.medium,
                    ),
                    child: Center(
                      child: Text(
                        'No achievements this month yet',
                        style: AppTextStyles.body2.copyWith(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  ...monthAchievements.take(3).map(
                        (achievement) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    achievement.icon,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      achievement.title,
                                      style: AppTextStyles.body2.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      achievement.description,
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.secondaryColor.withOpacity(0.1),
                                  borderRadius: AppBorderRadius.small,
                                ),
                                child: Text(
                                  '+${achievement.points}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppTheme.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                const SizedBox(height: AppSpacing.lg),

                // Areas Needing Attention
                Text(
                  'Areas for Improvement',
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                ...insights['improvements'].map<Widget>((improvement) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          size: 20,
                          color: AppTheme.warningColor,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            improvement,
                            style: AppTextStyles.body2,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _generateInsights() {
    // AI-style summary generation based on data
    final assessmentCount = monthAssessments.length;
    final achievementCount = monthAchievements.length;

    String summary;
    if (assessmentCount == 0) {
      summary = 'No assessments completed this month. Start tracking to see your progress and unlock achievements!';
    } else if (assessmentCount == 1) {
      summary = 'You completed 1 assessment this month. Great start! Complete more assessments to track your biological age trends.';
    } else {
      final firstBioAge = monthAssessments.first.biologicalAge;
      final lastBioAge = monthAssessments.last.biologicalAge;
      final improvement = firstBioAge - lastBioAge;

      if (improvement > 0) {
        summary = 'Excellent progress! You completed $assessmentCount assessments and reduced your biological age by ${improvement.toStringAsFixed(1)} years this month. Keep up the great work!';
      } else if (improvement < 0) {
        summary = 'You completed $assessmentCount assessments this month. Your biological age increased slightly. Focus on the improvement areas below to get back on track.';
      } else {
        summary = 'You completed $assessmentCount assessments this month with consistent biological age. Focus on the key areas to see improvement.';
      }
    }

    // Generate improvement suggestions
    final improvements = <String>[];
    if (monthAssessments.isNotEmpty) {
      final latestAssessment = monthAssessments.last;
      if (latestAssessment.topWeaknesses.isNotEmpty) {
        for (var weakness in latestAssessment.topWeaknesses.take(3)) {
          improvements.add(_getImprovementSuggestion(weakness));
        }
      }
    } else {
      improvements.add('Complete your first assessment to get personalized insights');
      improvements.add('Track your daily habits to build consistency');
    }

    return {
      'summary': summary,
      'improvements': improvements,
    };
  }

  String _getImprovementSuggestion(String category) {
    final suggestions = {
      'nutrition': 'Increase vegetable intake and maintain calorie targets for better nutrition scores',
      'exercise': 'Add variety to workouts and increase session intensity for better fitness',
      'sleep': 'Maintain 7-9 hours of quality sleep consistently',
      'stress': 'Practice meditation and stress management techniques daily',
      'social': 'Engage in meaningful social connections and community activities',
    };
    return suggestions[category.toLowerCase()] ?? 'Focus on improving your $category habits';
  }

  String _getCurrentMonthYear() {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  void _downloadReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PDF report download coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
