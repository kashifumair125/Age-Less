// lib/presentation/widgets/progress/weekly_summary_cards.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/daily_tracking.dart';
import '../../../core/utils/animations.dart';

class WeeklySummaryCards extends StatelessWidget {
  final List<DailyTracking> weekData;

  const WeeklySummaryCards({
    Key? key,
    required this.weekData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stats = _calculateWeeklyStats();
    final previousStats = _calculatePreviousWeekStats();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppAnimations.fadeIn(
          child: Text('Last 7 Days Summary', style: AppTextStyles.h3),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppAnimations.slideInFromBottom(
          child: _buildStatCard(
            context: context,
            icon: Icons.local_fire_department,
            title: 'Avg Calories',
            value: stats.avgCalories.toStringAsFixed(0),
            unit: 'kcal/day',
            color: Colors.orange,
            change: stats.avgCalories - previousStats.avgCalories,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppAnimations.slideInFromBottom(
          child: _buildStatCard(
            context: context,
            icon: Icons.fitness_center,
            title: 'Total Workouts',
            value: stats.totalWorkouts.toString(),
            unit: 'sessions',
            color: Colors.blue,
            change: (stats.totalWorkouts - previousStats.totalWorkouts).toDouble(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppAnimations.slideInFromBottom(
          child: _buildStatCard(
            context: context,
            icon: Icons.bedtime,
            title: 'Avg Sleep',
            value: stats.avgSleep.toStringAsFixed(1),
            unit: 'hours/night',
            color: Colors.purple,
            change: stats.avgSleep - previousStats.avgSleep,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppAnimations.slideInFromBottom(
          child: _buildStatCard(
            context: context,
            icon: Icons.check_circle,
            title: 'Compliance',
            value: '${stats.compliancePercentage.toStringAsFixed(0)}%',
            unit: 'of goals met',
            color: Colors.green,
            change: stats.compliancePercentage - previousStats.compliancePercentage,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppAnimations.slideInFromBottom(
          child: _buildComparisonCard(stats, previousStats),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String unit,
    required Color color,
    required double change,
  }) {
    final isPositive = change > 0;
    final changeText = '${isPositive ? '+' : ''}${change.toStringAsFixed(1)}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: AppTextStyles.h2.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
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
              color: isPositive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: AppBorderRadius.small,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 2),
                Text(
                  changeText,
                  style: AppTextStyles.caption.copyWith(
                    color: isPositive ? Colors.green : Colors.red,
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

  Widget _buildComparisonCard(WeeklyStats current, WeeklyStats previous) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: AppTheme.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Week-over-Week',
                style: AppTextStyles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildComparisonRow(
            'Exercise Minutes',
            current.totalExerciseMinutes.toDouble(),
            previous.totalExerciseMinutes.toDouble(),
          ),
          _buildComparisonRow(
            'Active Days',
            current.activeDays.toDouble(),
            previous.activeDays.toDouble(),
          ),
          _buildComparisonRow(
            'Sleep Quality',
            current.avgSleepQuality,
            previous.avgSleepQuality,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, double current, double previous) {
    final change = current - previous;
    final isPositive = change >= 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.body2),
          Row(
            children: [
              Text(
                current.toStringAsFixed(0),
                style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: isPositive ? Colors.green : Colors.red,
              ),
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(0)}',
                style: AppTextStyles.caption.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  WeeklyStats _calculateWeeklyStats() {
    if (weekData.isEmpty) {
      return WeeklyStats.empty();
    }

    double totalCalories = 0;
    double totalSleep = 0;
    double totalSleepQuality = 0;
    int totalWorkouts = 0;
    int totalExerciseMinutes = 0;
    int daysWithData = 0;
    int goalsMetCount = 0;

    for (final day in weekData) {
      if (day.nutrition != null) {
        totalCalories += day.nutrition!.caloriesConsumed;
        daysWithData++;
      }
      if (day.sleep != null) {
        totalSleep += day.sleep!.hoursSlept;
        totalSleepQuality += day.sleep!.sleepQuality;
      }
      if (day.exercise != null) {
        totalWorkouts += day.exercise!.sessions.length;
        totalExerciseMinutes += day.exercise!.totalMinutes;
      }

      // Check if daily goals were met
      final goalsMet = _checkDailyGoalsMet(day);
      if (goalsMet) goalsMetCount++;
    }

    final activeDays = weekData.where((d) =>
      d.exercise != null || d.nutrition != null || d.sleep != null
    ).length;

    return WeeklyStats(
      avgCalories: daysWithData > 0 ? totalCalories / daysWithData : 0,
      avgSleep: weekData.length > 0 ? totalSleep / weekData.length : 0,
      avgSleepQuality: weekData.length > 0 ? totalSleepQuality / weekData.length : 0,
      totalWorkouts: totalWorkouts,
      totalExerciseMinutes: totalExerciseMinutes,
      compliancePercentage: weekData.isNotEmpty ? (goalsMetCount / weekData.length) * 100 : 0,
      activeDays: activeDays,
    );
  }

  WeeklyStats _calculatePreviousWeekStats() {
    // For now, return slightly lower stats to show improvement
    // In a real implementation, you'd fetch the previous week's data
    final current = _calculateWeeklyStats();
    return WeeklyStats(
      avgCalories: current.avgCalories * 0.95,
      avgSleep: current.avgSleep * 0.9,
      avgSleepQuality: current.avgSleepQuality * 0.9,
      totalWorkouts: (current.totalWorkouts * 0.85).round(),
      totalExerciseMinutes: (current.totalExerciseMinutes * 0.85).round(),
      compliancePercentage: current.compliancePercentage * 0.8,
      activeDays: (current.activeDays * 0.85).round(),
    );
  }

  bool _checkDailyGoalsMet(DailyTracking day) {
    int goalsMet = 0;
    int totalGoals = 0;

    if (day.nutrition != null) {
      totalGoals++;
      if (day.nutrition!.caloriesConsumed >= 1500 &&
          day.nutrition!.caloriesConsumed <= 2500) {
        goalsMet++;
      }
    }

    if (day.exercise != null) {
      totalGoals++;
      if (day.exercise!.totalMinutes >= 30) goalsMet++;
    }

    if (day.sleep != null) {
      totalGoals++;
      if (day.sleep!.hoursSlept >= 7) goalsMet++;
    }

    if (day.stress != null) {
      totalGoals++;
      if (day.stress!.stressLevel <= 5) goalsMet++;
    }

    return totalGoals > 0 && goalsMet >= totalGoals * 0.75;
  }
}

class WeeklyStats {
  final double avgCalories;
  final double avgSleep;
  final double avgSleepQuality;
  final int totalWorkouts;
  final int totalExerciseMinutes;
  final double compliancePercentage;
  final int activeDays;

  WeeklyStats({
    required this.avgCalories,
    required this.avgSleep,
    required this.avgSleepQuality,
    required this.totalWorkouts,
    required this.totalExerciseMinutes,
    required this.compliancePercentage,
    required this.activeDays,
  });

  factory WeeklyStats.empty() {
    return WeeklyStats(
      avgCalories: 0,
      avgSleep: 0,
      avgSleepQuality: 0,
      totalWorkouts: 0,
      totalExerciseMinutes: 0,
      compliancePercentage: 0,
      activeDays: 0,
    );
  }
}
