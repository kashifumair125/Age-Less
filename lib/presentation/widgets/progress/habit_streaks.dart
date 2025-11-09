import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/daily_tracking.dart';

class HabitStreaks extends StatelessWidget {
  final List<DailyTracking> trackingHistory;
  final int currentStreak;
  final int longestStreak;

  const HabitStreaks({
    Key? key,
    required this.trackingHistory,
    required this.currentStreak,
    required this.longestStreak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitStreaks = _calculateHabitStreaks();

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
              children: [
                Icon(Icons.local_fire_department, color: AppTheme.accentColor),
                const SizedBox(width: AppSpacing.sm),
                Text('Habit Streaks', style: AppTextStyles.h3),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall streak stats
                Row(
                  children: [
                    Expanded(
                      child: _StreakCard(
                        icon: Icons.local_fire_department,
                        label: 'Current Streak',
                        value: '$currentStreak',
                        color: AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _StreakCard(
                        icon: Icons.emoji_events,
                        label: 'Best Streak',
                        value: '$longestStreak',
                        color: AppTheme.secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Calendar heatmap
                Text(
                  'Activity Heatmap',
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                _CalendarHeatmap(trackingHistory: trackingHistory),
                const SizedBox(height: AppSpacing.lg),

                // Individual habit streaks
                Text(
                  'Habit Breakdown',
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                _HabitStreakRow(
                  habit: 'Nutrition',
                  icon: Icons.restaurant,
                  streak: habitStreaks['nutrition'] ?? 0,
                  consistency: _calculateConsistency('nutrition'),
                  color: AppTheme.accentColor,
                ),
                const SizedBox(height: AppSpacing.sm),
                _HabitStreakRow(
                  habit: 'Exercise',
                  icon: Icons.fitness_center,
                  streak: habitStreaks['exercise'] ?? 0,
                  consistency: _calculateConsistency('exercise'),
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(height: AppSpacing.sm),
                _HabitStreakRow(
                  habit: 'Sleep',
                  icon: Icons.bedtime,
                  streak: habitStreaks['sleep'] ?? 0,
                  consistency: _calculateConsistency('sleep'),
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(height: AppSpacing.sm),
                _HabitStreakRow(
                  habit: 'Stress Management',
                  icon: Icons.self_improvement,
                  streak: habitStreaks['stress'] ?? 0,
                  consistency: _calculateConsistency('stress'),
                  color: AppTheme.warningColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateHabitStreaks() {
    final streaks = <String, int>{
      'nutrition': 0,
      'exercise': 0,
      'sleep': 0,
      'stress': 0,
    };

    if (trackingHistory.isEmpty) return streaks;

    // Calculate current streak for each habit
    final sorted = trackingHistory.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // Most recent first

    for (var entry in streaks.keys) {
      int streak = 0;
      DateTime? lastDate;

      for (var tracking in sorted) {
        bool hasData = false;

        switch (entry) {
          case 'nutrition':
            hasData = tracking.nutrition != null;
            break;
          case 'exercise':
            hasData = tracking.exercise != null;
            break;
          case 'sleep':
            hasData = tracking.sleep != null;
            break;
          case 'stress':
            hasData = tracking.stress != null;
            break;
        }

        if (!hasData) break;

        if (lastDate == null || tracking.date.difference(lastDate).inDays.abs() == 1) {
          streak++;
          lastDate = tracking.date;
        } else {
          break;
        }
      }

      streaks[entry] = streak;
    }

    return streaks;
  }

  double _calculateConsistency(String habit) {
    if (trackingHistory.isEmpty) return 0.0;

    int count = 0;
    for (var tracking in trackingHistory) {
      bool hasData = false;

      switch (habit) {
        case 'nutrition':
          hasData = tracking.nutrition != null;
          break;
        case 'exercise':
          hasData = tracking.exercise != null;
          break;
        case 'sleep':
          hasData = tracking.sleep != null;
          break;
        case 'stress':
          hasData = tracking.stress != null;
          break;
      }

      if (hasData) count++;
    }

    return count / trackingHistory.length;
  }
}

class _StreakCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StreakCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
        ),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: color),
          ),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CalendarHeatmap extends StatelessWidget {
  final List<DailyTracking> trackingHistory;

  const _CalendarHeatmap({required this.trackingHistory});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final daysToShow = 56; // 8 weeks
    final startDate = today.subtract(Duration(days: daysToShow - 1));

    // Create a map of dates to activity levels
    final activityMap = <String, int>{};
    for (var tracking in trackingHistory) {
      final dateKey = _getDateKey(tracking.date);
      int activity = 0;
      if (tracking.nutrition != null) activity++;
      if (tracking.exercise != null) activity++;
      if (tracking.sleep != null) activity++;
      if (tracking.stress != null) activity++;
      activityMap[dateKey] = activity;
    }

    return Column(
      children: [
        // Weekday labels
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                .map((day) => Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(fontSize: 10),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Heatmap grid
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8, // 8 weeks
            itemBuilder: (context, weekIndex) {
              return Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  children: List.generate(7, (dayIndex) {
                    final date = startDate.add(
                      Duration(days: weekIndex * 7 + dayIndex),
                    );
                    final dateKey = _getDateKey(date);
                    final activity = activityMap[dateKey] ?? 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: _HeatmapCell(
                        activity: activity,
                        date: date,
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),

        // Legend
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Less', style: AppTextStyles.caption),
            const SizedBox(width: AppSpacing.sm),
            _HeatmapCell(activity: 0, date: DateTime.now()),
            const SizedBox(width: 2),
            _HeatmapCell(activity: 1, date: DateTime.now()),
            const SizedBox(width: 2),
            _HeatmapCell(activity: 2, date: DateTime.now()),
            const SizedBox(width: 2),
            _HeatmapCell(activity: 3, date: DateTime.now()),
            const SizedBox(width: 2),
            _HeatmapCell(activity: 4, date: DateTime.now()),
            const SizedBox(width: AppSpacing.sm),
            Text('More', style: AppTextStyles.caption),
          ],
        ),
      ],
    );
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _HeatmapCell extends StatelessWidget {
  final int activity;
  final DateTime date;

  const _HeatmapCell({
    required this.activity,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: _getColor(),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.grey.shade200),
      ),
    );
  }

  Color _getColor() {
    switch (activity) {
      case 0:
        return Colors.grey.shade200;
      case 1:
        return AppTheme.primaryColor.withOpacity(0.3);
      case 2:
        return AppTheme.primaryColor.withOpacity(0.5);
      case 3:
        return AppTheme.primaryColor.withOpacity(0.7);
      case 4:
        return AppTheme.primaryColor;
      default:
        return Colors.grey.shade200;
    }
  }
}

class _HabitStreakRow extends StatelessWidget {
  final String habit;
  final IconData icon;
  final int streak;
  final double consistency;
  final Color color;

  const _HabitStreakRow({
    required this.habit,
    required this.icon,
    required this.streak,
    required this.consistency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit,
                    style: AppTextStyles.body2,
                  ),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        '$streak day${streak != 1 ? 's' : ''}',
                        style: AppTextStyles.body2.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: consistency,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${(consistency * 100).toInt()}%',
                    style: AppTextStyles.caption.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
