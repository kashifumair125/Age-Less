import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/biological_age_assessment.dart';

class BeforeAfterComparison extends StatelessWidget {
  final BiologicalAgeAssessment? firstAssessment;
  final BiologicalAgeAssessment? latestAssessment;
  final double? initialWeight;
  final double? currentWeight;

  const BeforeAfterComparison({
    Key? key,
    this.firstAssessment,
    this.latestAssessment,
    this.initialWeight,
    this.currentWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (firstAssessment == null || latestAssessment == null) {
      return _buildEmptyState();
    }

    final bioAgeChange = firstAssessment!.biologicalAge - latestAssessment!.biologicalAge;
    final weightChange = initialWeight != null && currentWeight != null
        ? initialWeight! - currentWeight!
        : 0.0;

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
                    Icon(Icons.compare_arrows, color: AppTheme.accentColor),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Before & After', style: AppTextStyles.h3),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareProgress(bioAgeChange, weightChange),
                  color: AppTheme.primaryColor,
                  tooltip: 'Share Progress',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                // Photo comparison placeholder
                Row(
                  children: [
                    Expanded(
                      child: _PhotoCard(
                        label: 'Before',
                        date: firstAssessment!.assessmentDate,
                        onTap: () => _uploadPhoto(context, 'before'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _PhotoCard(
                        label: 'After',
                        date: latestAssessment!.assessmentDate,
                        onTap: () => _uploadPhoto(context, 'after'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Measurement changes
                Text(
                  'Progress Summary',
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),

                _ProgressMetric(
                  label: 'Biological Age',
                  before: firstAssessment!.biologicalAge,
                  after: latestAssessment!.biologicalAge,
                  unit: 'years',
                  inversed: true, // Lower is better
                ),
                const SizedBox(height: AppSpacing.md),

                if (initialWeight != null && currentWeight != null)
                  _ProgressMetric(
                    label: 'Weight',
                    before: initialWeight!,
                    after: currentWeight!,
                    unit: 'kg',
                    inversed: true, // Lower is better (assuming weight loss goal)
                  ),
                const SizedBox(height: AppSpacing.lg),

                // Time period
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.05),
                    borderRadius: AppBorderRadius.medium,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: AppTheme.primaryColor),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Journey Duration: ${_calculateDuration(firstAssessment!.assessmentDate, latestAssessment!.assessmentDate)}',
                        style: AppTextStyles.body2.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.compare_arrows, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No comparison data yet',
              style: AppTextStyles.h3.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Complete multiple assessments to see your progress',
              style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateDuration(DateTime start, DateTime end) {
    final diff = end.difference(start);
    final days = diff.inDays;

    if (days < 7) {
      return '$days days';
    } else if (days < 30) {
      final weeks = (days / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'}';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'}';
    } else {
      final years = (days / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
  }

  void _shareProgress(double bioAgeChange, double weightChange) {
    final message = '''
🎯 AgeLess Progress Update!

Biological Age: ${bioAgeChange > 0 ? 'Reduced by ${bioAgeChange.toStringAsFixed(1)} years!' : 'Working on improvement'}
${weightChange != 0 ? 'Weight: ${weightChange > 0 ? 'Lost' : 'Gained'} ${weightChange.abs().toStringAsFixed(1)} kg' : ''}

Keep tracking your health journey! 💪
    ''';

    Share.share(message, subject: 'My AgeLess Progress');
  }

  void _uploadPhoto(BuildContext context, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Upload $type photo - Coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _PhotoCard({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: AppBorderRadius.medium,
          border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.body1.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            Text(
              '${date.month}/${date.day}/${date.year}',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap to upload',
              style: AppTextStyles.caption.copyWith(color: AppTheme.primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final double before;
  final double after;
  final String unit;
  final bool inversed;

  const _ProgressMetric({
    required this.label,
    required this.before,
    required this.after,
    required this.unit,
    this.inversed = false,
  });

  @override
  Widget build(BuildContext context) {
    final change = after - before;
    final isImprovement = inversed ? change < 0 : change > 0;
    final color = isImprovement ? AppTheme.successColor : AppTheme.warningColor;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.body2),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Before', style: AppTextStyles.caption),
                        Text(
                          '${before.toStringAsFixed(1)} $unit',
                          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('After', style: AppTextStyles.caption),
                        Text(
                          '${after.toStringAsFixed(1)} $unit',
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: AppBorderRadius.small,
            ),
            child: Row(
              children: [
                Icon(
                  isImprovement ? Icons.trending_up : Icons.trending_down,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}',
                  style: AppTextStyles.body1.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
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
