import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/daily_tracking.dart';

class WeeklySummaryCards extends StatelessWidget {
  final List<DailyTracking> last7Days;

  const WeeklySummaryCards({
    Key? key,
    required this.last7Days,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary = _calculateSummary();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_view_week, color: AppTheme.primaryColor),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Last 7 Days', style: AppTextStyles.h3),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: _getComplianceColor(summary['compliance']).withOpacity(0.1),
                    borderRadius: AppBorderRadius.small,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: _getComplianceColor(summary['compliance']),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${summary['compliance'].toStringAsFixed(0)}% Compliant',
                        style: AppTextStyles.body2.copyWith(
                          color: _getComplianceColor(summary['compliance']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.restaurant,
                        title: 'Calories',
                        value: summary['avgCalories'].toStringAsFixed(0),
                        unit: 'avg/day',
                        color: AppTheme.accentColor,
                        trend: summary['caloriesTrend'],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.fitness_center,
                        title: 'Workouts',
                        value: summary['totalWorkouts'].toString(),
                        unit: 'sessions',
                        color: AppTheme.secondaryColor,
                        trend: summary['workoutsTrend'],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.bedtime,
                        title: 'Sleep',
                        value: summary['avgSleep'].toStringAsFixed(1),
                        unit: 'hrs/day',
                        color: AppTheme.primaryColor,
                        trend: summary['sleepTrend'],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _SummaryCard(
                        icon: Icons.self_improvement,
                        title: 'Stress',
                        value: summary['avgStress'].toStringAsFixed(1),
                        unit: 'avg level',
                        color: AppTheme.warningColor,
                        trend: summary['stressTrend'],
                        inverseTrend: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (summary['daysTracked'] > 0) _buildWeekOverWeekComparison(summary),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateSummary() {
    if (last7Days.isEmpty) {
      return {
        'avgCalories': 0.0,
        'totalWorkouts': 0,
        'avgSleep': 0.0,
        'avgStress': 0.0,
        'compliance': 0.0,
        'daysTracked': 0,
        'caloriesTrend': 0.0,
        'workoutsTrend': 0.0,
        'sleepTrend': 0.0,
        'stressTrend': 0.0,
      };
    }

    double totalCalories = 0;
    int totalWorkouts = 0;
    double totalSleep = 0;
    double totalStress = 0;
    int daysWithData = 0;

    for (var tracking in last7Days) {
      if (tracking.nutrition != null) {
        totalCalories += tracking.nutrition!.caloriesConsumed;
        daysWithData++;
      }
      if (tracking.exercise != null) {
        totalWorkouts += tracking.exercise!.sessions.length;
      }
      if (tracking.sleep != null) {
        totalSleep += tracking.sleep!.hoursSlept;
      }
      if (tracking.stress != null) {
        totalStress += tracking.stress!.stressLevel;
      }
    }

    final avgCalories = daysWithData > 0 ? totalCalories / daysWithData : 0.0;
    final avgSleep = last7Days.where((t) => t.sleep != null).isNotEmpty
        ? totalSleep / last7Days.where((t) => t.sleep != null).length
        : 0.0;
    final avgStress = last7Days.where((t) => t.stress != null).isNotEmpty
        ? totalStress / last7Days.where((t) => t.stress != null).length
        : 0.0;

    final compliance = (daysWithData / 7) * 100;

    // Calculate trends (simplified - comparing first half vs second half)
    final firstHalf = last7Days.take(3).toList();
    final secondHalf = last7Days.skip(4).toList();

    final caloriesTrend = _calculateTrend(
      firstHalf.where((t) => t.nutrition != null).map((t) => t.nutrition!.caloriesConsumed.toDouble()).toList(),
      secondHalf.where((t) => t.nutrition != null).map((t) => t.nutrition!.caloriesConsumed.toDouble()).toList(),
    );

    final sleepTrend = _calculateTrend(
      firstHalf.where((t) => t.sleep != null).map((t) => t.sleep!.hoursSlept).toList(),
      secondHalf.where((t) => t.sleep != null).map((t) => t.sleep!.hoursSlept).toList(),
    );

    final stressTrend = _calculateTrend(
      firstHalf.where((t) => t.stress != null).map((t) => t.stress!.stressLevel.toDouble()).toList(),
      secondHalf.where((t) => t.stress != null).map((t) => t.stress!.stressLevel.toDouble()).toList(),
    );

    return {
      'avgCalories': avgCalories,
      'totalWorkouts': totalWorkouts,
      'avgSleep': avgSleep,
      'avgStress': avgStress,
      'compliance': compliance,
      'daysTracked': daysWithData,
      'caloriesTrend': caloriesTrend,
      'workoutsTrend': 0.0, // Can be calculated if needed
      'sleepTrend': sleepTrend,
      'stressTrend': stressTrend,
    };
  }

  double _calculateTrend(List<double> firstHalf, List<double> secondHalf) {
    if (firstHalf.isEmpty || secondHalf.isEmpty) return 0.0;

    final avgFirst = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
    final avgSecond = secondHalf.reduce((a, b) => a + b) / secondHalf.length;

    return avgSecond - avgFirst;
  }

  Color _getComplianceColor(double compliance) {
    if (compliance >= 80) return AppTheme.successColor;
    if (compliance >= 60) return AppTheme.secondaryColor;
    if (compliance >= 40) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  Widget _buildWeekOverWeekComparison(Map<String, dynamic> summary) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.05),
        borderRadius: AppBorderRadius.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Week Trends',
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You tracked ${summary['daysTracked']} out of 7 days this week.',
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String unit;
  final Color color;
  final double trend;
  final bool inverseTrend;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.unit,
    required this.color,
    required this.trend,
    this.inverseTrend = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositiveTrend = inverseTrend ? trend < 0 : trend > 0;
    final showTrend = trend.abs() > 0.1;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              if (showTrend)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositiveTrend
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.errorColor.withOpacity(0.1),
                    borderRadius: AppBorderRadius.small,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositiveTrend ? AppTheme.successColor : AppTheme.errorColor,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        trend.abs().toStringAsFixed(1),
                        style: AppTextStyles.caption.copyWith(
                          color: isPositiveTrend ? AppTheme.successColor : AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: color),
          ),
          Text(
            unit,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}
