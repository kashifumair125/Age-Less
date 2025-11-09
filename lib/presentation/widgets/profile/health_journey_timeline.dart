import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/biological_age_assessment.dart';
import '../../../domain/models/health_profile.dart';

class HealthJourneyTimeline extends StatelessWidget {
  final List<BiologicalAgeAssessment> assessments;
  final List<Milestone> milestones;

  const HealthJourneyTimeline({
    Key? key,
    required this.assessments,
    required this.milestones,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.timeline, color: AppTheme.primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text('Health Journey', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (assessments.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: LineChart(
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
                          if (value.toInt() < assessments.length) {
                            final date = assessments[value.toInt()].assessmentDate;
                            return Text(
                              '${date.month}/${date.day}',
                              style: AppTextStyles.caption,
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: assessments.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.biologicalAge,
                        );
                      }).toList(),
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
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          if (milestones.isNotEmpty) ...[
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Text('Milestones', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            ...milestones.take(3).map((milestone) => _MilestoneItem(milestone: milestone)),
          ] else ...[
            Center(
              child: Column(
                children: [
                  Icon(Icons.timeline, size: 48, color: Colors.grey.shade300),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Complete assessments to see your journey',
                    style: AppTextStyles.body2.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MilestoneItem extends StatelessWidget {
  final Milestone milestone;

  const _MilestoneItem({required this.milestone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                milestone.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  milestone.description,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          Text(
            '${milestone.achievedDate.month}/${milestone.achievedDate.day}',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
