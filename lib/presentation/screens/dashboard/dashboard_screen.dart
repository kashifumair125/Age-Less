// lib/presentation/screens/dashboard/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../providers/tracking_provider.dart';
import '../../providers/weekly_providers.dart';
import '../../providers/achievements_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/assessment_repository.dart';
import '../../../data/repositories/user_repository.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good morning, Alex', style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Let\'s optimize your longevity today',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Biological Age Card (wired to user profile / biological age when available)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Consumer(
                  builder: (context, ref, _) => _BiologicalAgeCard(ref: ref),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

            // Today's Goals (wired to current tracking when available)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text('Today\'s Goals', style: AppTextStyles.h3),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Goals Grid (values from providers when present)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.1,
                ),
                delegate: SliverChildListDelegate([
                  Consumer(builder: (context, ref, _) {
                    final trackingAsync = ref.watch(currentTrackingProvider);
                    return trackingAsync.maybeWhen(
                      data: (t) {
                        final calories =
                            (t?.nutrition?.caloriesConsumed ?? 0).toDouble();
                        final target = 2000.0;
                        final progress = (calories / target).clamp(0.0, 1.0);
                        return _GoalCard(
                          title: 'Nutrition',
                          progress: progress,
                          current: calories.toStringAsFixed(0),
                          target: target.toStringAsFixed(0),
                          unit: 'kcal',
                          color: AppTheme.secondaryColor,
                          icon: Icons.restaurant,
                        );
                      },
                      orElse: () => const _GoalCard(
                        title: 'Nutrition',
                        progress: 0,
                        current: '0',
                        target: '2000',
                        unit: 'kcal',
                        color: AppTheme.secondaryColor,
                        icon: Icons.restaurant,
                      ),
                    );
                  }),
                  Consumer(builder: (context, ref, _) {
                    final trackingAsync = ref.watch(currentTrackingProvider);
                    return trackingAsync.maybeWhen(
                      data: (t) {
                        final minutes =
                            (t?.exercise?.totalMinutes ?? 0).toDouble();
                        const target = 60.0;
                        final progress = (minutes / target).clamp(0.0, 1.0);
                        return _GoalCard(
                          title: 'Exercise',
                          progress: progress,
                          current: minutes.toStringAsFixed(0),
                          target: target.toStringAsFixed(0),
                          unit: 'min',
                          color: AppTheme.primaryColor,
                          icon: Icons.fitness_center,
                        );
                      },
                      orElse: () => const _GoalCard(
                        title: 'Exercise',
                        progress: 0,
                        current: '0',
                        target: '60',
                        unit: 'min',
                        color: AppTheme.primaryColor,
                        icon: Icons.fitness_center,
                      ),
                    );
                  }),
                  Consumer(builder: (context, ref, _) {
                    final trackingAsync = ref.watch(currentTrackingProvider);
                    return trackingAsync.maybeWhen(
                      data: (t) {
                        final hours = (t?.sleep?.hoursSlept ?? 0).toDouble();
                        const target = 8.0;
                        final progress = (hours / target).clamp(0.0, 1.0);
                        return _GoalCard(
                          title: 'Sleep',
                          progress: progress,
                          current: hours.toStringAsFixed(1),
                          target: target.toStringAsFixed(0),
                          unit: 'hrs',
                          color: Colors.blue,
                          icon: Icons.bed,
                        );
                      },
                      orElse: () => const _GoalCard(
                        title: 'Sleep',
                        progress: 0,
                        current: '0.0',
                        target: '8',
                        unit: 'hrs',
                        color: Colors.blue,
                        icon: Icons.bed,
                      ),
                    );
                  }),
                  Consumer(builder: (context, ref, _) {
                    final trackingAsync = ref.watch(currentTrackingProvider);
                    return trackingAsync.maybeWhen(
                      data: (t) {
                        final mins =
                            (t?.stress?.meditationMinutes ?? 0).toDouble();
                        const target = 20.0;
                        final progress = (mins / target).clamp(0.0, 1.0);
                        return _GoalCard(
                          title: 'Stress',
                          progress: progress,
                          current: mins.toStringAsFixed(0),
                          target: target.toStringAsFixed(0),
                          unit: 'min',
                          color: AppTheme.accentColor,
                          icon: Icons.self_improvement,
                        );
                      },
                      orElse: () => const _GoalCard(
                        title: 'Stress',
                        progress: 0,
                        current: '0',
                        target: '20',
                        unit: 'min',
                        color: AppTheme.accentColor,
                        icon: Icons.self_improvement,
                      ),
                    );
                  }),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Weekly Summary + Adherence Chart
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text('This Week', style: AppTextStyles.h3),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _WeeklySummaryCard(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _AdherenceBarRow(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Achievements
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text('Achievements', style: AppTextStyles.h3),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _AchievementsRow(),
              ),
            ),

            // Top Recommendations
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recommended for You', style: AppTextStyles.h3),
                    TextButton(onPressed: () {}, child: const Text('See All')),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Recommendations List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _RecommendationCard(
                    title: 'Start HIIT Training',
                    description:
                        'High-intensity intervals can reverse cellular aging',
                    impact: 'High Impact',
                    evidence: 'Strong Evidence',
                    category: 'Exercise',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RecommendationCard(
                    title: 'Mediterranean Diet',
                    description: 'Proven to reduce biological age by 2-4 years',
                    impact: 'High Impact',
                    evidence: 'Strong Evidence',
                    category: 'Nutrition',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _RecommendationCard(
                    title: 'Daily Meditation',
                    description:
                        'Reduces cortisol and improves heart rate variability',
                    impact: 'Medium Impact',
                    evidence: 'Strong Evidence',
                    category: 'Stress',
                  ),
                ]),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }
}

class _BiologicalAgeCard extends StatelessWidget {
  final WidgetRef ref;

  const _BiologicalAgeCard({required this.ref});

  @override
  Widget build(BuildContext context) {
    final userRepository = ref.read(userRepositoryProvider);
    final assessmentRepository = ref.read(assessmentRepositoryProvider);

    return FutureBuilder(
      future: Future.wait([
        userRepository.getUserProfile(),
        assessmentRepository.getLatestAssessment(),
        assessmentRepository.getAssessments(),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        final userProfile = snapshot.hasData ? snapshot.data![0] : null;
        final latestAssessment = snapshot.hasData ? snapshot.data![1] : null;
        final allAssessments =
            snapshot.hasData ? (snapshot.data![2] as List) : [];

        // Calculate values
        final biologicalAge = latestAssessment?.biologicalAge ?? 0.0;
        final chronologicalAge =
            latestAssessment?.chronologicalAge ?? userProfile?.birthDate != null
                ? DateTime.now().year - userProfile!.birthDate!.year
                : 30.0;
        final ageDifference = latestAssessment?.ageDifference ?? 0.0;

        // Calculate days since last assessment
        final daysSinceAssessment = latestAssessment != null
            ? DateTime.now().difference(latestAssessment.assessmentDate).inDays
            : null;

        // Calculate improvement (compare with previous assessment if exists)
        double? improvement;
        if (allAssessments.length >= 2) {
          final previous = allAssessments[allAssessments.length - 2];
          improvement = previous.biologicalAge - biologicalAge;
        }

        // Calculate health score (0-100) based on age difference
        // If biological age is lower than chronological, that's good
        final healthScore = ageDifference < 0
            ? (70 + (ageDifference.abs() / chronologicalAge * 30))
                .clamp(0, 100)
            : (70 - (ageDifference / chronologicalAge * 70)).clamp(0, 100);

        final hasAssessment = latestAssessment != null;

        return Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryColor, Color(0xFF8B7CE7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: AppBorderRadius.large,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Biological Age',
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            hasAssessment
                                ? biologicalAge.toStringAsFixed(1)
                                : '--',
                            style: AppTextStyles.h1.copyWith(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'years',
                              style: AppTextStyles.body1.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (hasAssessment)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ageDifference < 0
                                ? AppTheme.successColor
                                : Colors.orange,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                ageDifference < 0
                                    ? Icons.trending_down
                                    : Icons.trending_up,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                ageDifference < 0
                                    ? '${ageDifference.abs().toStringAsFixed(1)} years younger'
                                    : '${ageDifference.toStringAsFixed(1)} years older',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Take assessment',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 10.0,
                    percent: hasAssessment ? (healthScore / 100) : 0.0,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          hasAssessment
                              ? healthScore.toStringAsFixed(0)
                              : '--',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Score',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    progressColor: Colors.white,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      label: 'Last Assessment',
                      value: daysSinceAssessment != null
                          ? daysSinceAssessment == 0
                              ? 'Today'
                              : daysSinceAssessment == 1
                                  ? '1 day ago'
                                  : '$daysSinceAssessment days ago'
                          : 'Not taken',
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  Expanded(
                    child: _StatItem(
                      label: 'Improvement',
                      value: improvement != null
                          ? improvement > 0
                              ? '-${improvement.toStringAsFixed(1)} years'
                              : '+${improvement.abs().toStringAsFixed(1)} years'
                          : 'N/A',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/assessment');
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white, width: 2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Take New Assessment'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  final String title;
  final double progress;
  final String current;
  final String target;
  final String unit;
  final Color color;
  final IconData icon;

  const _GoalCard({
    required this.title,
    required this.progress,
    required this.current,
    required this.target,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.body2.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '$current / $target $unit',
            style: AppTextStyles.caption.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String description;
  final String impact;
  final String evidence;
  final String category;

  const _RecommendationCard({
    required this.title,
    required this.description,
    required this.impact,
    required this.evidence,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: AppTextStyles.body2.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _Badge(label: category, color: AppTheme.primaryColor),
              _Badge(label: impact, color: AppTheme.errorColor),
              _Badge(label: evidence, color: AppTheme.successColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _WeeklySummaryCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weekly = ref.watch(weeklySummaryProvider);
    return weekly.when(
      data: (w) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: AppBorderRadius.large,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SummaryStat(
                label: 'Avg Calories',
                value: w.averageCalories.toStringAsFixed(0)),
            _SummaryStat(
                label: 'Avg Exercise',
                value: '${w.averageExerciseMinutes.toStringAsFixed(0)} min'),
            _SummaryStat(
                label: 'Avg Sleep',
                value: '${w.averageSleepHours.toStringAsFixed(1)} h'),
            _SummaryStat(
                label: 'Adherence',
                value: '${w.adherencePercent.toStringAsFixed(0)}%'),
          ],
        ),
      ),
      loading: () => const SizedBox(
          height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryStat({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.caption.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _AdherenceBarRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = ref.watch(adherenceSeriesProvider);
    return series.when(
      data: (points) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: points
            .map((p) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.bottomCenter,
                          child: FractionallySizedBox(
                            heightFactor: p.value.clamp(0, 1),
                            widthFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(p.dayLabel, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
      loading: () => const SizedBox(
          height: 80, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _AchievementsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    if (achievements.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: AppBorderRadius.large,
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Text('No achievements yet. Keep going!',
            style: AppTextStyles.body2),
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: achievements
            .map((a) => Container(
                  margin: const EdgeInsets.only(right: AppSpacing.md),
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: AppBorderRadius.large,
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.title,
                          style: AppTextStyles.body1
                              .copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(a.description,
                          style: AppTextStyles.caption
                              .copyWith(color: Colors.grey.shade600)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
