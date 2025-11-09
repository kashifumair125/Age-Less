import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/biological_age_assessment.dart';

class BioAgeHistoryGraph extends StatefulWidget {
  final List<BiologicalAgeAssessment> assessments;
  final VoidCallback? onExport;

  const BioAgeHistoryGraph({
    Key? key,
    required this.assessments,
    this.onExport,
  }) : super(key: key);

  @override
  State<BioAgeHistoryGraph> createState() => _BioAgeHistoryGraphState();
}

class _BioAgeHistoryGraphState extends State<BioAgeHistoryGraph> {
  int? _selectedIndex;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    if (widget.assessments.isEmpty) {
      return _buildEmptyState();
    }

    final spots = widget.assessments.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.biologicalAge,
      );
    }).toList();

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
                    Icon(Icons.show_chart, color: AppTheme.primaryColor),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Bio-Age History', style: AppTextStyles.h3),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline, size: 20),
                      onPressed: () {
                        setState(() => _showDetails = !_showDetails);
                      },
                      color: AppTheme.primaryColor,
                    ),
                    if (widget.onExport != null)
                      IconButton(
                        icon: const Icon(Icons.download, size: 20),
                        onPressed: widget.onExport,
                        color: AppTheme.primaryColor,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          GestureDetector(
            onTapDown: (details) => _handleTapDown(details, spots.length),
            child: Container(
              height: 280,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                  ),
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
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < widget.assessments.length) {
                            final date = widget.assessments[index].assessmentDate;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.month}/${date.day}',
                                style: AppTextStyles.caption,
                              ),
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
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.spotIndex;
                          if (index < widget.assessments.length) {
                            final assessment = widget.assessments[index];
                            return LineTooltipItem(
                              '${assessment.biologicalAge.toStringAsFixed(1)} years\n${assessment.assessmentDate.month}/${assessment.assessmentDate.day}/${assessment.assessmentDate.year}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          return null;
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: AppTheme.primaryColor,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: index == _selectedIndex ? 6 : 4,
                            color: index == _selectedIndex
                                ? AppTheme.secondaryColor
                                : Colors.white,
                            strokeWidth: 2,
                            strokeColor: AppTheme.primaryColor,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.3),
                            AppTheme.primaryColor.withOpacity(0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_selectedIndex != null && _selectedIndex! < widget.assessments.length)
            _buildSelectedDetails(widget.assessments[_selectedIndex!]),
          if (_showDetails) _buildStatsSummary(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.show_chart, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No assessment data yet',
              style: AppTextStyles.h3.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Complete assessments to track your bio-age journey',
              style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedDetails(BiologicalAgeAssessment assessment) {
    final improvement = assessment.chronologicalAge - assessment.biologicalAge;
    final isImproving = improvement > 0;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isImproving
              ? [AppTheme.successColor.withOpacity(0.1), AppTheme.successColor.withOpacity(0.05)]
              : [AppTheme.warningColor.withOpacity(0.1), AppTheme.warningColor.withOpacity(0.05)],
        ),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(
          color: isImproving ? AppTheme.successColor : AppTheme.warningColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Assessment',
                style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _selectedIndex = null),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _DetailChip(
                label: 'Bio-Age',
                value: '${assessment.biologicalAge.toStringAsFixed(1)} yrs',
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: AppSpacing.sm),
              _DetailChip(
                label: 'Chrono-Age',
                value: '${assessment.chronologicalAge.toStringAsFixed(1)} yrs',
                color: Colors.grey,
              ),
              const SizedBox(width: AppSpacing.sm),
              _DetailChip(
                label: isImproving ? 'Younger by' : 'Older by',
                value: '${improvement.abs().toStringAsFixed(1)} yrs',
                color: isImproving ? AppTheme.successColor : AppTheme.warningColor,
              ),
            ],
          ),
          if (assessment.topWeaknesses.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Focus areas: ${assessment.topWeaknesses.join(', ')}',
              style: AppTextStyles.caption.copyWith(color: Colors.grey.shade700),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatsSummary() {
    final firstAssessment = widget.assessments.first;
    final lastAssessment = widget.assessments.last;
    final totalImprovement = firstAssessment.biologicalAge - lastAssessment.biologicalAge;
    final avgBioAge = widget.assessments
            .map((a) => a.biologicalAge)
            .reduce((a, b) => a + b) /
        widget.assessments.length;

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
            'Journey Summary',
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  label: 'Total Change',
                  value: '${totalImprovement >= 0 ? '+' : ''}${totalImprovement.toStringAsFixed(1)} yrs',
                  color: totalImprovement >= 0 ? AppTheme.successColor : AppTheme.errorColor,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Average Bio-Age',
                  value: '${avgBioAge.toStringAsFixed(1)} yrs',
                  color: AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _StatItem(
                  label: 'Assessments',
                  value: '${widget.assessments.length}',
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTapDown(TapDownDetails details, int dataPointsCount) {
    // Simple tap detection - in production you'd use the chart's touch callback
    final localX = details.localPosition.dx;
    final chartWidth = context.size!.width - 100; // Approximate
    final pointWidth = chartWidth / dataPointsCount;
    final tappedIndex = (localX / pointWidth).floor().clamp(0, dataPointsCount - 1);

    setState(() {
      _selectedIndex = tappedIndex;
    });
  }
}

class _DetailChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(color: color),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
