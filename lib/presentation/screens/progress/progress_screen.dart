// lib/presentation/screens/progress/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/assessment_repository.dart';
import '../../providers/achievements_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final achievements = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Biological Age Trend', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            FutureBuilder(
              future: assessmentRepository.getAssessments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 250,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
                final assessments = snapshot.data ?? [];
                return _BiologicalAgeTrendChart(assessments: assessments);
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Category Scores', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            FutureBuilder(
              future: assessmentRepository.getLatestAssessment(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                }
                final latestAssessment = snapshot.data;
                return _CategoryScoresChart(assessment: latestAssessment);
              },
            ),

            const SizedBox(height: AppSpacing.xl),

            Text('Achievements', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),

            if (achievements.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: AppBorderRadius.large,
                ),
                child: Center(
                  child: Text(
                    'No achievements yet. Keep tracking to unlock!',
                    style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
                  ),
                ),
              )
            else
              ...achievements.map((achievement) {
                final daysSinceUnlock = DateTime.now()
                    .difference(achievement.unlockedAt)
                    .inDays;
                final dateText = daysSinceUnlock == 0
                    ? 'Unlocked today'
                    : daysSinceUnlock == 1
                        ? 'Unlocked 1 day ago'
                        : 'Unlocked $daysSinceUnlock days ago';

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: _AchievementCard(
                    icon: Icons.emoji_events,
                    title: achievement.title,
                    description: achievement.description,
                    date: dateText,
                    color: AppTheme.primaryColor,
                  ),
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

class _BiologicalAgeTrendChart extends StatelessWidget {
  final List assessments;

  const _BiologicalAgeTrendChart({required this.assessments});

  @override
  Widget build(BuildContext context) {
    // Convert assessments to chart data points
    final spots = assessments.isEmpty
        ? [const FlSpot(0, 0)]
        : assessments.asMap().entries.map((entry) {
            return FlSpot(
              entry.key.toDouble(),
              entry.value.biologicalAge,
            );
          }).toList();

    // Generate month labels from assessment dates
    final monthLabels = assessments.isEmpty
        ? ['--']
        : assessments.map((a) {
            final date = a.assessmentDate as DateTime;
            const months = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec'
            ];
            return '${months[date.month - 1]} ${date.day}';
          }).toList();

    return Container(
      height: 250,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: assessments.isEmpty
          ? Center(
              child: Text(
                'No assessment data yet.\nTake your first assessment to see progress.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
              ),
            )
          : LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: AppTextStyles.caption,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthLabels.length) {
                          return Text(
                            monthLabels[value.toInt()],
                            style: AppTextStyles.caption,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CategoryScoresChart extends StatelessWidget {
  final dynamic assessment;

  const _CategoryScoresChart({this.assessment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: assessment == null
          ? Center(
              child: Text(
                'No assessment data.\nComplete an assessment to see category breakdown.',
                textAlign: TextAlign.center,
                style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      tickCount: 5,
                      ticksTextStyle: AppTextStyles.caption,
                      radarBorderData:
                          const BorderSide(color: Colors.grey, width: 1),
                      gridBorderData:
                          const BorderSide(color: Colors.grey, width: 1),
                      tickBorderData: const BorderSide(color: Colors.transparent),
                      getTitle: (index, angle) {
                        const titles = [
                          'Nutrition',
                          'Exercise',
                          'Sleep',
                          'Stress',
                          'Social',
                        ];
                        return RadarChartTitle(text: titles[index], angle: angle);
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: AppTheme.primaryColor.withOpacity(0.2),
                          borderColor: AppTheme.primaryColor,
                          dataEntries: [
                            // Real category scores from assessment (scaled to 0-100)
                            RadarEntry(
                                value: (assessment.categoryScores['nutrition'] ??
                                        5.0) *
                                    10),
                            RadarEntry(
                                value: (assessment.categoryScores['exercise'] ??
                                        5.0) *
                                    10),
                            RadarEntry(
                                value:
                                    (assessment.categoryScores['sleep'] ?? 5.0) *
                                        10),
                            RadarEntry(
                                value:
                                    (assessment.categoryScores['stress'] ?? 5.0) *
                                        10),
                            RadarEntry(
                                value:
                                    (assessment.categoryScores['social'] ?? 5.0) *
                                        10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (assessment.topWeaknesses.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: AppBorderRadius.medium,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Focus areas: ${assessment.topWeaknesses.join(', ')}',
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.orange.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String date;
  final Color color;

  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.date,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.large,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
