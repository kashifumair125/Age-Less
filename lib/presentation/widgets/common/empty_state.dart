import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.illustration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedEntrance(
              delay: const Duration(milliseconds: 100),
              child: illustration ??
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 60,
                      color: AppTheme.primaryColor.withOpacity(0.5),
                    ),
                  ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: AppTextStyles.h3.copyWith(
                  color: AppTheme.grey700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 300),
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(
                  color: AppTheme.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 400),
                child: ElevatedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.add),
                  label: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Preset empty states for common scenarios
class EmptyStates {
  static Widget noAssessments({VoidCallback? onTakeAssessment}) {
    return EmptyState(
      icon: Icons.assignment_outlined,
      title: 'No Assessments Yet',
      message: 'Take your first biological age assessment to start tracking your health journey',
      actionLabel: 'Take Assessment',
      onAction: onTakeAssessment,
    );
  }

  static Widget noTracking({VoidCallback? onStartTracking}) {
    return EmptyState(
      icon: Icons.timeline_outlined,
      title: 'No Tracking Data',
      message: 'Start logging your daily habits to see progress and insights',
      actionLabel: 'Start Tracking',
      onAction: onStartTracking,
    );
  }

  static Widget noAchievements() {
    return EmptyState(
      icon: Icons.emoji_events_outlined,
      title: 'No Achievements Yet',
      message: 'Complete tasks and build streaks to unlock achievements',
    );
  }

  static Widget noData({required String title, required String message}) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: title,
      message: message,
    );
  }
}
