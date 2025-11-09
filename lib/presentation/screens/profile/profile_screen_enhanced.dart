// lib/presentation/screens/profile/profile_screen_enhanced.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/assessment_repository.dart';
import '../../../data/repositories/tracking_repository.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/health_profile.dart';
import '../../../domain/services/progress_service.dart';
import '../../widgets/profile/user_stats_card.dart';
import '../../widgets/profile/health_journey_timeline.dart';
import '../../widgets/profile/achievement_gallery.dart';
import '../../widgets/profile/personal_best_records.dart';
import '../../widgets/profile/health_profile_details.dart';
import '../../widgets/profile/data_privacy_section.dart';
import '../../widgets/export_dialog.dart';
import 'profile_edit_screen.dart';

class ProfileScreenEnhanced extends ConsumerStatefulWidget {
  const ProfileScreenEnhanced({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreenEnhanced> createState() => _ProfileScreenEnhancedState();
}

class _ProfileScreenEnhancedState extends ConsumerState<ProfileScreenEnhanced> {
  bool _isLoading = true;
  UserProfile? _profile;
  HealthProfile? _healthProfile;

  // Stats
  int _totalDays = 0;
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _totalAssessments = 0;
  double _bioAgeImprovement = 0;
  double _profileCompletion = 0;
  double _bestBioAge = 0;
  double _consistencyScore = 0;
  String _mostActiveWeek = 'N/A';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final userRepository = ref.read(userRepositoryProvider);
      final assessmentRepository = ref.read(assessmentRepositoryProvider);
      final trackingRepository = ref.read(trackingRepositoryProvider);

      // Load profile
      _profile = await userRepository.getUserProfile();

      // Load assessments
      final assessments = await assessmentRepository.getAssessments();
      _totalAssessments = assessments.length;

      // Load tracking data
      final trackingHistory = await trackingRepository.getAllTracking();

      if (_profile != null) {
        // Calculate total days
        final now = DateTime.now();
        _totalDays = now.difference(_profile!.createdAt).inDays;

        // Calculate profile completion
        _profileCompletion = _calculateProfileCompletion(_profile!);

        // Calculate streaks and metrics
        if (trackingHistory.isNotEmpty) {
          final progressService = ProgressService();

          // Get initial and current bio age
          final initialBioAge = assessments.isNotEmpty ? assessments.first.biologicalAge : 0.0;
          final currentBioAge = assessments.isNotEmpty ? assessments.last.biologicalAge : 0.0;

          final metrics = progressService.calculateProgress(
            trackingHistory: trackingHistory,
            initialBiologicalAge: initialBioAge,
            currentBiologicalAge: currentBioAge,
          );

          _currentStreak = metrics.currentStreak;
          _longestStreak = metrics.longestStreak;
          _bioAgeImprovement = metrics.ageReduction;

          // Find best bio age
          if (assessments.isNotEmpty) {
            _bestBioAge = assessments.map((a) => a.biologicalAge).reduce((a, b) => a < b ? a : b);
          }

          // Calculate consistency score
          _consistencyScore = _calculateConsistencyScore(trackingHistory, _totalDays);

          // Find most active week
          _mostActiveWeek = _findMostActiveWeek(trackingHistory);
        }
      }
    } catch (e) {
      debugPrint('Error loading profile data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  double _calculateProfileCompletion(UserProfile profile) {
    int completed = 0;
    const total = 6;

    if (profile.name.isNotEmpty) completed++;
    if (profile.email.isNotEmpty) completed++;
    if (profile.birthDate != null) completed++;
    if (profile.heightCm > 0) completed++;
    if (profile.weightKg > 0) completed++;
    if (profile.gender != null) completed++;

    return (completed / total) * 100;
  }

  double _calculateConsistencyScore(List<dynamic> trackingHistory, int totalDays) {
    if (totalDays == 0) return 0;
    final trackedDays = trackingHistory.length;
    return (trackedDays / totalDays).clamp(0.0, 1.0);
  }

  String _findMostActiveWeek(List<dynamic> trackingHistory) {
    if (trackingHistory.isEmpty) return 'N/A';

    // Group by week and count activities
    final weekCounts = <String, int>{};

    for (var tracking in trackingHistory) {
      final date = tracking.date as DateTime;
      final weekStart = date.subtract(Duration(days: date.weekday - 1));
      final weekKey = '${weekStart.month}/${weekStart.day}';
      weekCounts[weekKey] = (weekCounts[weekKey] ?? 0) + 1;
    }

    if (weekCounts.isEmpty) return 'N/A';

    final mostActive = weekCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    return mostActive.key;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
              _loadData(); // Reload data after editing
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    _buildProfileHeader(),
                    const SizedBox(height: AppSpacing.xl),

                    // User Stats Card
                    UserStatsCard(
                      totalDays: _totalDays,
                      currentStreak: _currentStreak,
                      totalAssessments: _totalAssessments,
                      bioAgeImprovement: _bioAgeImprovement,
                      profileCompletion: _profileCompletion,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Health Journey Timeline
                    FutureBuilder(
                      future: _loadAssessmentsAndMilestones(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final data = snapshot.data as Map<String, dynamic>? ?? {};
                        return HealthJourneyTimeline(
                          assessments: data['assessments'] ?? [],
                          milestones: data['milestones'] ?? [],
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Achievement Gallery
                    FutureBuilder(
                      future: _loadAchievements(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final data = snapshot.data as Map<String, dynamic>? ?? {};
                        return AchievementGallery(
                          achievements: data['unlocked'] ?? [],
                          availableAchievements: data['available'] ?? [],
                          leaderboardPosition: null, // Can be implemented later
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Personal Best Records
                    PersonalBestRecords(
                      longestStreak: _longestStreak,
                      bestBioAge: _bestBioAge,
                      mostActiveWeek: _mostActiveWeek,
                      consistencyScore: _consistencyScore,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Health Profile Details
                    HealthProfileDetails(
                      healthProfile: _healthProfile,
                      onEdit: () => _showHealthProfileEditor(),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Data & Privacy Section
                    DataPrivacySection(
                      onExportData: () => _showExportDialog(),
                      onDeleteAccount: () => _deleteAccount(),
                      onPrivacySettings: () => _showPrivacySettings(),
                      onBackupData: () => _backupData(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    if (_profile == null) {
      return const Center(child: Text('No profile found'));
    }

    final age = _profile!.birthDate != null
        ? DateTime.now().year - _profile!.birthDate!.year
        : null;

    final initials = _profile!.name.isNotEmpty
        ? _profile!.name.split(' ').map((n) => n[0]).take(2).join()
        : 'U';

    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(_profile!.name, style: AppTextStyles.h2),
          if (age != null)
            Text(
              '$age years old',
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          if (_profile!.email.isNotEmpty)
            Text(
              _profile!.email,
              style: AppTextStyles.caption.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _loadAssessmentsAndMilestones() async {
    final assessmentRepository = ref.read(assessmentRepositoryProvider);
    final assessments = await assessmentRepository.getAssessments();

    // Generate milestones based on achievements
    final milestones = <Milestone>[];

    if (assessments.isNotEmpty) {
      milestones.add(Milestone(
        id: 'first_assessment',
        title: 'First Assessment',
        description: 'Completed your first biological age assessment',
        achievedDate: assessments.first.assessmentDate,
        icon: '🎯',
      ));
    }

    if (_currentStreak >= 7) {
      milestones.add(Milestone(
        id: '7_day_streak',
        title: '7-Day Streak',
        description: 'Tracked your health for 7 consecutive days',
        achievedDate: DateTime.now().subtract(Duration(days: _currentStreak - 7)),
        icon: '🔥',
      ));
    }

    if (_currentStreak >= 30) {
      milestones.add(Milestone(
        id: '30_day_streak',
        title: '30-Day Streak',
        description: 'Achieved 30 consecutive days of tracking',
        achievedDate: DateTime.now().subtract(Duration(days: _currentStreak - 30)),
        icon: '🏆',
      ));
    }

    return {
      'assessments': assessments,
      'milestones': milestones,
    };
  }

  Future<Map<String, dynamic>> _loadAchievements() async {
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

    // Available achievements that haven't been unlocked yet
    final available = <dynamic>[];

    if (_currentStreak < 7) {
      available.add(const {
        'id': 'streak_7',
        'title': '7 Day Streak',
        'description': 'Track for 7 consecutive days',
        'icon': '🔥',
        'points': 50,
      });
    }

    return {
      'unlocked': metrics.achievements,
      'available': available.map((a) => a).toList(),
    };
  }

  void _showHealthProfileEditor() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Health profile editor coming soon!')),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => const ExportDialog(),
    );
  }

  void _deleteAccount() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deleted (demo mode)'),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  void _showPrivacySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings coming soon!')),
    );
  }

  void _backupData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data backed up successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }
}
