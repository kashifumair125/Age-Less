import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/progress_metrics.dart';

class AchievementGallery extends StatelessWidget {
  final List<Achievement> achievements;
  final List<Achievement> availableAchievements;
  final int? leaderboardPosition;

  const AchievementGallery({
    Key? key,
    required this.achievements,
    required this.availableAchievements,
    this.leaderboardPosition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPoints = achievements.fold<int>(0, (sum, a) => sum + a.points);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.emoji_events, color: AppTheme.secondaryColor),
                  const SizedBox(width: AppSpacing.sm),
                  Text('Achievements', style: AppTextStyles.h3),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: AppBorderRadius.small,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppTheme.secondaryColor),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '$totalPoints pts',
                      style: AppTextStyles.body2.copyWith(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (achievements.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Icon(Icons.emoji_events_outlined, size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No achievements yet',
                      style: AppTextStyles.body2.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Complete tasks to unlock achievements!',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.85,
              ),
              itemCount: achievements.length + (availableAchievements.length > 0 ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < achievements.length) {
                  return _AchievementBadge(
                    achievement: achievements[index],
                    isUnlocked: true,
                    onShare: () => _shareAchievement(achievements[index]),
                  );
                } else {
                  // Show next achievement to unlock
                  return _NextAchievementBadge(
                    achievement: availableAchievements.first,
                  );
                }
              },
            ),
          if (leaderboardPosition != null) ...[
            const SizedBox(height: AppSpacing.lg),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.leaderboard, color: AppTheme.primaryColor, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Leaderboard Position: #$leaderboardPosition',
                  style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _shareAchievement(Achievement achievement) {
    Share.share(
      'I just unlocked "${achievement.title}" in AgeLess! ${achievement.description}',
      subject: 'AgeLess Achievement',
    );
  }
}

class _AchievementBadge extends StatefulWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final VoidCallback? onShare;

  const _AchievementBadge({
    required this.achievement,
    required this.isUnlocked,
    this.onShare,
  });

  @override
  State<_AchievementBadge> createState() => _AchievementBadgeState();
}

class _AchievementBadgeState extends State<_AchievementBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    if (widget.isUnlocked) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: widget.onShare,
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.isUnlocked
                ? LinearGradient(
                    colors: [AppTheme.secondaryColor, AppTheme.secondaryColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isUnlocked ? null : Colors.grey.shade200,
            borderRadius: AppBorderRadius.medium,
            boxShadow: widget.isUnlocked
                ? [
                    BoxShadow(
                      color: AppTheme.secondaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.achievement.icon,
                style: TextStyle(
                  fontSize: 32,
                  color: widget.isUnlocked ? null : Colors.grey,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                widget.achievement.title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: widget.isUnlocked ? Colors.white : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${widget.achievement.points} pts',
                style: TextStyle(
                  fontSize: 10,
                  color: widget.isUnlocked ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextAchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const _NextAchievementBadge({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: AppTheme.primaryColor, width: 2, style: BorderStyle.solid),
      ),
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, color: AppTheme.primaryColor, size: 28),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Next Goal',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            achievement.title,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
