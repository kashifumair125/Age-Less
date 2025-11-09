// lib/presentation/widgets/progress/before_after_comparison.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/assessment.dart';
import '../../../core/utils/animations.dart';
import '../../../core/utils/haptics.dart';

class BeforeAfterComparison extends StatelessWidget {
  final Assessment? firstAssessment;
  final Assessment? latestAssessment;

  const BeforeAfterComparison({
    Key? key,
    this.firstAssessment,
    this.latestAssessment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (firstAssessment == null || latestAssessment == null) {
      return _buildEmptyState();
    }

    final daysBetween = latestAssessment!.assessmentDate
        .difference(firstAssessment!.assessmentDate)
        .inDays;

    final bioAgeChange = latestAssessment!.biologicalAge - firstAssessment!.biologicalAge;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.green.withOpacity(0.1),
          ],
        ),
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Transformation',
                style: AppTextStyles.h2.copyWith(fontWeight: FontWeight.bold),
              ),
              AnimatedButton(
                onPressed: () {
                  AppHaptics.light();
                  _shareProgress(context, bioAgeChange, daysBetween);
                },
                child: IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    AppHaptics.light();
                    _shareProgress(context, bioAgeChange, daysBetween);
                  },
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$daysBetween days of progress',
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Side-by-side comparison
          Row(
            children: [
              Expanded(
                child: _buildComparisonCard(
                  title: 'Before',
                  date: DateFormat('MMM d, yyyy').format(firstAssessment!.assessmentDate),
                  bioAge: firstAssessment!.biologicalAge,
                  chronologicalAge: firstAssessment!.chronologicalAge,
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
              ),
              Expanded(
                child: _buildComparisonCard(
                  title: 'After',
                  date: DateFormat('MMM d, yyyy').format(latestAssessment!.assessmentDate),
                  bioAge: latestAssessment!.biologicalAge,
                  chronologicalAge: latestAssessment!.chronologicalAge,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Change summary
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: bioAgeChange <= 0
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
              borderRadius: AppBorderRadius.medium,
              border: Border.all(
                color: bioAgeChange <= 0
                    ? Colors.green.withOpacity(0.5)
                    : Colors.orange.withOpacity(0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  bioAgeChange <= 0 ? Icons.trending_down : Icons.trending_up,
                  color: bioAgeChange <= 0 ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bioAgeChange <= 0 ? 'Age Reduced!' : 'Age Increased',
                      style: AppTextStyles.h3.copyWith(
                        color: bioAgeChange <= 0 ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${bioAgeChange > 0 ? '+' : ''}${bioAgeChange.toStringAsFixed(1)} years',
                      style: AppTextStyles.h2.copyWith(
                        color: bioAgeChange <= 0 ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Category improvements
          Text(
            'Category Changes',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.md),
          ..._buildCategoryComparisons(),

          const SizedBox(height: AppSpacing.lg),

          // Progress photos placeholder
          _buildPhotoSection(),
        ],
      ),
    );
  }

  Widget _buildComparisonCard({
    required String title,
    required String date,
    required double bioAge,
    required int chronologicalAge,
    required Color color,
  }) {
    final difference = bioAge - chronologicalAge;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: AppTextStyles.caption.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            bioAge.toStringAsFixed(1),
            style: AppTextStyles.h1.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Bio Age',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: difference <= 0
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: AppBorderRadius.small,
            ),
            child: Text(
              '${difference > 0 ? '+' : ''}${difference.toStringAsFixed(1)} vs actual',
              style: AppTextStyles.caption.copyWith(
                color: difference <= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCategoryComparisons() {
    if (firstAssessment == null || latestAssessment == null) return [];

    final categories = ['nutrition', 'exercise', 'sleep', 'stress', 'social'];
    final categoryNames = {
      'nutrition': 'Nutrition',
      'exercise': 'Exercise',
      'sleep': 'Sleep',
      'stress': 'Stress Management',
      'social': 'Social Connection',
    };

    return categories.map((category) {
      final before = firstAssessment!.categoryScores[category] ?? 5.0;
      final after = latestAssessment!.categoryScores[category] ?? 5.0;
      final change = after - before;

      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: _buildCategoryBar(
          categoryNames[category]!,
          before,
          after,
          change,
        ),
      );
    }).toList();
  }

  Widget _buildCategoryBar(String name, double before, double after, double change) {
    final isImproved = change > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: AppTextStyles.body2),
            Row(
              children: [
                Text(
                  '${before.toStringAsFixed(1)} → ${after.toStringAsFixed(1)}',
                  style: AppTextStyles.body2.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isImproved ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isImproved ? Colors.green : Colors.red,
                ),
                Text(
                  change.abs().toStringAsFixed(1),
                  style: AppTextStyles.caption.copyWith(
                    color: isImproved ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: AppBorderRadius.small,
          child: LinearProgressIndicator(
            value: after / 10,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation(
              isImproved ? Colors.green : Colors.orange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.camera_alt, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Text(
                'Progress Photos',
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _buildPhotoPlaceholder('Before'),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildPhotoPlaceholder('After'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: () {
              // TODO: Implement photo upload
            },
            icon: const Icon(Icons.add_photo_alternate),
            label: const Text('Add Progress Photos'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder(String label) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: AppBorderRadius.large,
      ),
      child: Column(
        children: [
          Icon(Icons.compare_arrows, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Comparison Data Yet',
            style: AppTextStyles.h3.copyWith(color: Colors.grey.shade700),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Complete at least two assessments to see your transformation',
            textAlign: TextAlign.center,
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  void _shareProgress(BuildContext context, double bioAgeChange, int days) {
    final message = bioAgeChange <= 0
        ? '🎉 Amazing progress! I reduced my biological age by ${bioAgeChange.abs().toStringAsFixed(1)} years in just $days days using Age-Less! #AgeLess #HealthJourney'
        : 'Tracking my health journey with Age-Less for $days days! #AgeLess #HealthJourney';

    Share.share(message);
  }
}
