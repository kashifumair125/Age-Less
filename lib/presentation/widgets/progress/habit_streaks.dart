// lib/presentation/widgets/progress/habit_streaks.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/daily_tracking.dart';

class HabitStreaks extends StatelessWidget {
  final List<DailyTracking> trackingHistory;

  const HabitStreaks({
    Key? key,
    required this.trackingHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streaks = _calculateStreaks();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Habit Streaks', style: AppTextStyles.h3),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Track your consistency and build lasting habits',
          style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Current streaks
        ...streaks.entries.map((entry) {
          final habit = entry.key;
          final streakData = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _buildStreakCard(habit, streakData),
          );
        }),

        const SizedBox(height: AppSpacing.lg),

        // Calendar heatmap
        _buildCalendarHeatmap(),
      ],
    );
  }

  Widget _buildStreakCard(String habit, StreakData data) {
    final habitIcons = {
      'Exercise': Icons.fitness_center,
      'Sleep': Icons.bedtime,
      'Nutrition': Icons.restaurant,
      'Meditation': Icons.self_improvement,
    };

    final habitColors = {
      'Exercise': Colors.blue,
      'Sleep': Colors.purple,
      'Nutrition': Colors.green,
      'Meditation': Colors.orange,
    };

    final icon = habitIcons[habit] ?? Icons.check_circle;
    final color = habitColors[habit] ?? AppTheme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
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
                      habit,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${data.consistencyPercentage.toStringAsFixed(0)}% consistency',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Streak stats
          Row(
            children: [
              Expanded(
                child: _buildStatPill(
                  '🔥 ${data.currentStreak}',
                  'Current',
                  color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildStatPill(
                  '⭐ ${data.longestStreak}',
                  'Best',
                  color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildStatPill(
                  '✓ ${data.totalDays}',
                  'Total',
                  color,
                ),
              ),
            ],
          ),

          if (data.currentStreak >= 7) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.2),
                borderRadius: AppBorderRadius.small,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.currentStreak >= 30
                          ? 'Incredible 30-day streak! You\'re unstoppable! 🚀'
                          : 'Great ${data.currentStreak}-day streak! Keep it up! 💪',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatPill(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeatmap() {
    final now = DateTime.now();
    final daysToShow = 84; // 12 weeks
    final startDate = now.subtract(Duration(days: daysToShow));

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Heatmap',
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  _buildLegendItem(Colors.grey.shade200, 'None'),
                  const SizedBox(width: 8),
                  _buildLegendItem(Colors.green.shade200, 'Low'),
                  const SizedBox(width: 8),
                  _buildLegendItem(Colors.green.shade400, 'Med'),
                  const SizedBox(width: 8),
                  _buildLegendItem(Colors.green.shade600, 'High'),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Calendar grid
          SizedBox(
            height: 120,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: daysToShow,
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));
                final activity = _getActivityLevel(date);
                return _buildHeatmapCell(date, activity);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppBorderRadius.small,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildHeatmapCell(DateTime date, int activityLevel) {
    final colors = [
      Colors.grey.shade200,
      Colors.green.shade200,
      Colors.green.shade400,
      Colors.green.shade600,
    ];

    return Tooltip(
      message: '${DateFormat('MMM d').format(date)}\n$activityLevel activities',
      child: Container(
        decoration: BoxDecoration(
          color: colors[activityLevel.clamp(0, 3)],
          borderRadius: AppBorderRadius.small,
        ),
      ),
    );
  }

  int _getActivityLevel(DateTime date) {
    final tracking = trackingHistory.where((t) {
      return t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day;
    }).firstOrNull;

    if (tracking == null) return 0;

    int activities = 0;
    if (tracking.exercise != null) activities++;
    if (tracking.nutrition != null) activities++;
    if (tracking.sleep != null) activities++;
    if (tracking.stress != null) activities++;

    return activities; // 0-4
  }

  Map<String, StreakData> _calculateStreaks() {
    final Map<String, StreakData> streaks = {
      'Exercise': _calculateHabitStreak((t) => t.exercise != null),
      'Sleep': _calculateHabitStreak((t) => t.sleep != null && t.sleep!.hoursSlept >= 7),
      'Nutrition': _calculateHabitStreak((t) => t.nutrition != null),
      'Meditation': _calculateHabitStreak((t) => t.stress?.meditated ?? false),
    };

    return streaks;
  }

  StreakData _calculateHabitStreak(bool Function(DailyTracking) checker) {
    if (trackingHistory.isEmpty) {
      return StreakData(
        currentStreak: 0,
        longestStreak: 0,
        totalDays: 0,
        consistencyPercentage: 0,
      );
    }

    // Sort by date
    final sorted = [...trackingHistory]..sort((a, b) => b.date.compareTo(a.date));

    int currentStreak = 0;
    int longestStreak = 0;
    int totalDays = 0;
    int tempStreak = 0;

    DateTime? lastDate;

    for (final tracking in sorted.reversed) {
      if (checker(tracking)) {
        totalDays++;
        tempStreak++;

        if (lastDate != null) {
          final daysDiff = tracking.date.difference(lastDate).inDays;
          if (daysDiff > 1) {
            tempStreak = 1;
          }
        }

        if (tempStreak > longestStreak) {
          longestStreak = tempStreak;
        }

        lastDate = tracking.date;
      } else {
        tempStreak = 0;
      }
    }

    // Calculate current streak from today backwards
    final now = DateTime.now();
    for (final tracking in sorted) {
      if (checker(tracking)) {
        final daysDiff = now.difference(tracking.date).inDays;
        if (daysDiff == currentStreak) {
          currentStreak++;
        } else {
          break;
        }
      }
    }

    final consistencyPercentage = trackingHistory.isEmpty
        ? 0.0
        : (totalDays / trackingHistory.length) * 100;

    return StreakData(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalDays: totalDays,
      consistencyPercentage: consistencyPercentage,
    );
  }
}

class StreakData {
  final int currentStreak;
  final int longestStreak;
  final int totalDays;
  final double consistencyPercentage;

  StreakData({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDays,
    required this.consistencyPercentage,
  });
}
