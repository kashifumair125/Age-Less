// lib/presentation/screens/progress/progress_screen_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/assessment_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../domain/services/progress_service.dart';
import '../../widgets/progress/bio_age_history_graph.dart';
import '../../widgets/progress/category_performance_radar.dart';
import '../../widgets/progress/weekly_summary_cards.dart';
import '../../widgets/progress/monthly_report.dart';
import '../../widgets/progress/before_after_comparison.dart';
import '../../widgets/progress/habit_streaks.dart';

class ProgressScreenEnhanced extends ConsumerStatefulWidget {
  const ProgressScreenEnhanced({Key? key}) : super(key: key);

  @override
  ConsumerState<ProgressScreenEnhanced> createState() => _ProgressScreenEnhancedState();
}

class _ProgressScreenEnhancedState extends ConsumerState<ProgressScreenEnhanced>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate data loading
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Analytics', icon: Icon(Icons.analytics)),
            Tab(text: 'Reports', icon: Icon(Icons.article)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildAnalyticsTab(),
                _buildReportsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bio-Age History Graph
            FutureBuilder(
              future: ref.read(assessmentRepositoryProvider).getAssessments(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return BioAgeHistoryGraph(
                  assessments: snapshot.data ?? [],
                  onExport: () => _exportGraph(),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Weekly Summary Cards
            FutureBuilder(
              future: _getLast7Days(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return WeeklySummaryCards(
                  last7Days: snapshot.data ?? [],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Habit Streaks
            FutureBuilder(
              future: _getStreakData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data as Map<String, dynamic>? ?? {};
                return HabitStreaks(
                  trackingHistory: data['history'] ?? [],
                  currentStreak: data['currentStreak'] ?? 0,
                  longestStreak: data['longestStreak'] ?? 0,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Performance Radar
          FutureBuilder(
              future: _getAssessmentsForRadar(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final data = snapshot.data as Map<String, dynamic>? ?? {};
                return CategoryPerformanceRadar(
                  currentAssessment: data['current'],
                  previousAssessment: data['previous'],
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

          // Before/After Comparison
          FutureBuilder(
            future: _getBeforeAfterData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data as Map<String, dynamic>? ?? {};
              return BeforeAfterComparison(
                firstAssessment: data['first'],
                latestAssessment: data['latest'],
                initialWeight: data['initialWeight'],
                currentWeight: data['currentWeight'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Monthly Report
          FutureBuilder(
            future: _getMonthlyReportData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = snapshot.data as Map<String, dynamic>? ?? {};
              return MonthlyReport(
                monthAssessments: data['assessments'] ?? [],
                monthAchievements: data['achievements'] ?? [],
                monthStats: data['stats'] ?? {},
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          // Additional insights section
          _buildInsightsSection(),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: AppBorderRadius.large,
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.insights, color: AppTheme.primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Quick Insights',
                style: AppTextStyles.h3.copyWith(color: AppTheme.primaryColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _InsightItem(
            icon: Icons.tips_and_updates,
            text: 'Track consistently to see better results',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InsightItem(
            icon: Icons.trending_up,
            text: 'Focus on your weakest categories for maximum impact',
          ),
          const SizedBox(height: AppSpacing.sm),
          _InsightItem(
            icon: Icons.calendar_today,
            text: 'Complete weekly assessments to monitor progress',
          ),
        ],
      ),
    );
  }

  Future<List<dynamic>> _getLast7Days() async {
    final trackingRepository = ref.read(trackingRepositoryProvider);
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return await trackingRepository.getTrackingRange(sevenDaysAgo, now);
  }

  Future<Map<String, dynamic>> _getStreakData() async {
    final trackingRepository = ref.read(trackingRepositoryProvider);
    final trackingHistory = await trackingRepository.getAllTracking();

    final progressService = ProgressService();
    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final assessments = await assessmentRepository.getAssessments();

    final initialBioAge = assessments.isNotEmpty ? assessments.first.biologicalAge : 0.0;
    final currentBioAge = assessments.isNotEmpty ? assessments.last.biologicalAge : 0.0;

    final metrics = progressService.calculateProgress(
      trackingHistory: trackingHistory,
      initialBiologicalAge: initialBioAge,
      currentBiologicalAge: currentBioAge,
    );

    return {
      'history': trackingHistory,
      'currentStreak': metrics.currentStreak,
      'longestStreak': metrics.longestStreak,
    };
  }

  Future<Map<String, dynamic>> _getAssessmentsForRadar() async {
    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final assessments = await assessmentRepository.getAssessments();

    if (assessments.isEmpty) {
      return {'current': null, 'previous': null};
    }

    return {
      'current': assessments.last,
      'previous': assessments.length > 1 ? assessments[assessments.length - 2] : null,
    };
  }

  Future<Map<String, dynamic>> _getBeforeAfterData() async {
    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final assessments = await assessmentRepository.getAssessments();
    final userRepository = ref.read(userRepositoryProvider);
    final profile = await userRepository.getUserProfile();

    if (assessments.isEmpty) {
      return {
        'first': null,
        'latest': null,
        'initialWeight': null,
        'currentWeight': null,
      };
    }

    return {
      'first': assessments.first,
      'latest': assessments.last,
      'initialWeight': profile?.weightKg,
      'currentWeight': profile?.weightKg,
    };
  }

  Future<Map<String, dynamic>> _getMonthlyReportData() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final allAssessments = await assessmentRepository.getAssessments();

    final monthAssessments = allAssessments.where((a) {
      return a.assessmentDate.isAfter(monthStart) && a.assessmentDate.isBefore(monthEnd);
    }).toList();

    // Get achievements for the month
    final trackingRepository = ref.read(trackingRepositoryProvider);
    final trackingHistory = await trackingRepository.getAllTracking();

    final progressService = ProgressService();
    final initialBioAge = allAssessments.isNotEmpty ? allAssessments.first.biologicalAge : 0.0;
    final currentBioAge = allAssessments.isNotEmpty ? allAssessments.last.biologicalAge : 0.0;

    final metrics = progressService.calculateProgress(
      trackingHistory: trackingHistory,
      initialBiologicalAge: initialBioAge,
      currentBiologicalAge: currentBioAge,
    );

    return {
      'assessments': monthAssessments,
      'achievements': metrics.achievements,
      'stats': {},
    };
  }

  void _exportGraph() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Graph export coming soon!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}

class _InsightItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InsightItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.body2,
          ),
        ),
      ],
    );
  }
}
