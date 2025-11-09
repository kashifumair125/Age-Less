import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/biological_age_assessment.dart';

class CategoryPerformanceRadar extends StatefulWidget {
  final BiologicalAgeAssessment? currentAssessment;
  final BiologicalAgeAssessment? previousAssessment;

  const CategoryPerformanceRadar({
    Key? key,
    this.currentAssessment,
    this.previousAssessment,
  }) : super(key: key);

  @override
  State<CategoryPerformanceRadar> createState() => _CategoryPerformanceRadarState();
}

class _CategoryPerformanceRadarState extends State<CategoryPerformanceRadar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.currentAssessment == null) {
      return _buildEmptyState();
    }

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
                    Icon(Icons.radar, color: AppTheme.secondaryColor),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Category Performance', style: AppTextStyles.h3),
                  ],
                ),
                _buildLegend(),
              ],
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 350,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      tickCount: 5,
                      ticksTextStyle: AppTextStyles.caption,
                      radarBorderData: BorderSide(color: Colors.grey.shade300, width: 2),
                      gridBorderData: BorderSide(color: Colors.grey.shade200, width: 1),
                      tickBorderData: const BorderSide(color: Colors.transparent),
                      getTitle: (index, angle) {
                        final categories = _getCategories();
                        return RadarChartTitle(
                          text: categories[index],
                          angle: angle,
                        );
                      },
                      dataSets: _buildDataSets(),
                      radarBackgroundColor: Colors.transparent,
                      borderData: FlBorderData(show: false),
                    ),
                  );
                },
              ),
            ),
          ),
          _buildCategoryDetails(),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.radar, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No category data available',
              style: AppTextStyles.h3.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Complete an assessment to see your performance',
              style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _LegendItem(
          color: AppTheme.primaryColor,
          label: 'Current',
        ),
        if (widget.previousAssessment != null) ...[
          const SizedBox(width: AppSpacing.sm),
          _LegendItem(
            color: AppTheme.accentColor.withOpacity(0.5),
            label: 'Previous',
          ),
        ],
      ],
    );
  }

  List<String> _getCategories() {
    if (widget.currentAssessment == null) return [];
    return widget.currentAssessment!.categoryScores.keys.toList();
  }

  List<RadarDataSet> _buildDataSets() {
    final dataSets = <RadarDataSet>[];

    // Current assessment
    if (widget.currentAssessment != null) {
      final currentEntries = widget.currentAssessment!.categoryScores.values
          .map((score) => RadarEntry(value: score * 10 * _animation.value))
          .toList();

      dataSets.add(
        RadarDataSet(
          fillColor: AppTheme.primaryColor.withOpacity(0.2),
          borderColor: AppTheme.primaryColor,
          borderWidth: 3,
          dataEntries: currentEntries,
        ),
      );
    }

    // Previous assessment
    if (widget.previousAssessment != null) {
      final previousEntries = widget.previousAssessment!.categoryScores.values
          .map((score) => RadarEntry(value: score * 10 * _animation.value))
          .toList();

      dataSets.add(
        RadarDataSet(
          fillColor: AppTheme.accentColor.withOpacity(0.1),
          borderColor: AppTheme.accentColor.withOpacity(0.5),
          borderWidth: 2,
          dataEntries: previousEntries,
        ),
      );
    }

    return dataSets;
  }

  Widget _buildCategoryDetails() {
    if (widget.currentAssessment == null) return const SizedBox.shrink();

    final categories = widget.currentAssessment!.categoryScores;
    final improvements = <String, double>{};

    if (widget.previousAssessment != null) {
      categories.forEach((key, value) {
        final prevValue = widget.previousAssessment!.categoryScores[key] ?? 0;
        improvements[key] = value - prevValue;
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Category Breakdown',
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          ...categories.entries.map((entry) {
            final improvement = improvements[entry.key] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _CategoryDetailRow(
                category: _formatCategoryName(entry.key),
                score: entry.value,
                improvement: improvement,
                hasPrevious: widget.previousAssessment != null,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatCategoryName(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

class _CategoryDetailRow extends StatelessWidget {
  final String category;
  final double score;
  final double improvement;
  final bool hasPrevious;

  const _CategoryDetailRow({
    required this.category,
    required this.score,
    required this.improvement,
    required this.hasPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final isImproving = improvement > 0;
    final isNeutral = improvement == 0;

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            category,
            style: AppTextStyles.body2,
          ),
        ),
        Expanded(
          child: LinearProgressIndicator(
            value: score / 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getScoreColor(score),
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 40,
          child: Text(
            '${score.toStringAsFixed(1)}',
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
        if (hasPrevious)
          SizedBox(
            width: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isNeutral)
                  Icon(
                    isImproving ? Icons.trending_up : Icons.trending_down,
                    size: 16,
                    color: isImproving ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                const SizedBox(width: 4),
                Text(
                  improvement > 0 ? '+${improvement.toStringAsFixed(1)}' : improvement.toStringAsFixed(1),
                  style: AppTextStyles.caption.copyWith(
                    color: isNeutral
                        ? Colors.grey
                        : isImproving
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8) return AppTheme.successColor;
    if (score >= 6) return AppTheme.secondaryColor;
    if (score >= 4) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }
}
