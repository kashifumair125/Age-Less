// lib/presentation/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/local/hive_config.dart';
import '../../../domain/models/user_profile.dart';
import 'package:uuid/uuid.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Reverse Your Biological Age',
      description:
          'Science-based interventions to optimize longevity and feel younger',
      icon: Icons.auto_awesome,
      color: AppTheme.primaryColor,
    ),
    OnboardingPage(
      title: 'Track Your Progress',
      description: 'Monitor nutrition, exercise, sleep, stress, and more',
      icon: Icons.track_changes,
      color: AppTheme.secondaryColor,
    ),
    OnboardingPage(
      title: 'Personalized Recommendations',
      description: 'AI-powered insights based on latest longevity research',
      icon: Icons.psychology,
      color: AppTheme.accentColor,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            _buildPageIndicators(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Mark onboarding as complete
                      final box = HiveConfig.settingsBox;
                      await box.put(
                          AppConstants.hasCompletedOnboardingKey, true);

                      // Create default user profile if none exists
                      final profileBox = HiveConfig.userProfileBox;
                      if (profileBox.isEmpty) {
                        final defaultProfile = UserProfile(
                          id: const Uuid().v4(),
                          name: 'User',
                          email: '',
                          createdAt: DateTime.now(),
                          birthDate: DateTime.now().subtract(
                              const Duration(days: 365 * 30)), // 30 years old
                          heightCm: 170,
                          weightKg: 70,
                          gender: null,
                        );
                        await profileBox.add(defaultProfile);
                      }

                      if (mounted) {
                        context.go('/main');
                      }
                    }
                  },
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Next' : 'Get Started',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 100, color: page.color),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            page.title,
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            page.description,
            style: AppTextStyles.body1.copyWith(color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: _currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppTheme.primaryColor
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
