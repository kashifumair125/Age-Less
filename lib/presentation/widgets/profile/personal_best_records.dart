import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class PersonalBestRecords extends StatelessWidget {
  final int longestStreak;
  final double bestBioAge;
  final String mostActiveWeek;
  final double consistencyScore;

  const PersonalBestRecords({
    Key? key,
    required this.longestStreak,
    required this.bestBioAge,
    required this.mostActiveWeek,
    required this.consistencyScore,
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
              Icon(Icons.military_tech, color: AppTheme.accentColor),
              const SizedBox(width: AppSpacing.sm),
              Text('Personal Bests', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _RecordItem(
            icon: Icons.local_fire_department,
            label: 'Longest Streak',
            value: '$longestStreak days',
            color: AppTheme.accentColor,
          ),
          const Divider(height: AppSpacing.lg),
          _RecordItem(
            icon: Icons.trending_down,
            label: 'Best Biological Age',
            value: bestBioAge > 0 ? '${bestBioAge.toStringAsFixed(1)} yrs' : 'N/A',
            color: AppTheme.successColor,
          ),
          const Divider(height: AppSpacing.lg),
          _RecordItem(
            icon: Icons.calendar_view_week,
            label: 'Most Active Week',
            value: mostActiveWeek,
            color: AppTheme.primaryColor,
          ),
          const Divider(height: AppSpacing.lg),
          _RecordItem(
            icon: Icons.insights,
            label: 'Consistency Score',
            value: '${(consistencyScore * 100).toStringAsFixed(0)}%',
            color: AppTheme.secondaryColor,
            trailing: LinearProgressIndicator(
              value: consistencyScore,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.secondaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Widget? trailing;

  const _RecordItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.body2),
                  Text(
                    value,
                    style: AppTextStyles.h3.copyWith(color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (trailing != null) ...[
          const SizedBox(height: AppSpacing.sm),
          trailing!,
        ],
      ],
    );
  }
}
