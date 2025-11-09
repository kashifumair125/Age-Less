import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_theme.dart';

class UserStatsCard extends StatelessWidget {
  final int totalDays;
  final int currentStreak;
  final int totalAssessments;
  final double bioAgeImprovement;
  final double profileCompletion;

  const UserStatsCard({
    Key? key,
    required this.totalDays,
    required this.currentStreak,
    required this.totalAssessments,
    required this.bioAgeImprovement,
    required this.profileCompletion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppBorderRadius.large,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Journey',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularPercentIndicator(
                radius: 30,
                lineWidth: 4,
                percent: profileCompletion / 100,
                center: Text(
                  '${profileCompletion.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: Colors.white,
                backgroundColor: Colors.white24,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.calendar_today,
                  label: 'Days Active',
                  value: totalDays.toString(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatItem(
                  icon: Icons.local_fire_department,
                  label: 'Current Streak',
                  value: currentStreak.toString(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.assignment_turned_in,
                  label: 'Assessments',
                  value: totalAssessments.toString(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatItem(
                  icon: Icons.trending_down,
                  label: 'Age Reduced',
                  value: bioAgeImprovement > 0
                      ? '${bioAgeImprovement.toStringAsFixed(1)} yrs'
                      : 'N/A',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: AppBorderRadius.medium,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
