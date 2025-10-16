// lib/presentation/screens/progress/progress_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Biological Age Trend', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            _BiologicalAgeTrendChart(),

            const SizedBox(height: AppSpacing.xl),

            Text('Category Scores', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),
            _CategoryScoresChart(),

            const SizedBox(height: AppSpacing.xl),

            Text('Achievements', style: AppTextStyles.h3),
            const SizedBox(height: AppSpacing.lg),

            _AchievementCard(
              icon: Icons.emoji_events,
              title: '30 Day Streak',
              description: 'Logged daily for 30 consecutive days',
              date: 'Unlocked 2 days ago',
              color: Colors.amber,
            ),

            const SizedBox(height: AppSpacing.md),

            _AchievementCard(
              icon: Icons.fitness_center,
              title: 'Workout Warrior',
              description: 'Completed 50 HIIT sessions',
              date: 'Unlocked 1 week ago',
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _BiologicalAgeTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
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
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  if (value.toInt() < months.length) {
                    return Text(
                      months[value.toInt()],
                      style: AppTextStyles.caption,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 35),
                const FlSpot(1, 34.5),
                const FlSpot(2, 34),
                const FlSpot(3, 33.2),
                const FlSpot(4, 32.8),
                const FlSpot(5, 32.4),
              ],
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
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.polygon,
          tickCount: 5,
          ticksTextStyle: AppTextStyles.caption,
          radarBorderData: const BorderSide(color: Colors.grey, width: 1),
          gridBorderData: const BorderSide(color: Colors.grey, width: 1),
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
                const RadarEntry(value: 75),
                const RadarEntry(value: 80),
                const RadarEntry(value: 85),
                const RadarEntry(value: 70),
                const RadarEntry(value: 65),
              ],
            ),
          ],
        ),
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
