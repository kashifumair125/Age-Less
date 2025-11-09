// lib/presentation/widgets/common/animated_card.dart
import 'package:flutter/material.dart';
import '../../../core/utils/animations.dart';
import '../../../core/utils/haptics.dart';

/// Animated card with fade-in and slide-up animation
class AnimatedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Duration delay;
  final bool enableHaptic;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.onTap,
    this.delay = Duration.zero,
    this.enableHaptic = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = child;

    if (onTap != null) {
      card = GestureDetector(
        onTap: () {
          if (enableHaptic) AppHaptics.light();
          onTap?.call();
        },
        child: card,
      );
    }

    return AppAnimations.slideInFromBottom(
      duration: AppAnimations.medium,
      child: AppAnimations.fadeIn(
        duration: AppAnimations.medium,
        delay: delay,
        child: card,
      ),
    );
  }
}

/// Animated list item with staggered animation
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration baseDelay;

  const AnimatedListItem({
    Key? key,
    required this.child,
    required this.index,
    this.baseDelay = const Duration(milliseconds: 50),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppAnimations.slideInFromBottom(
      duration: AppAnimations.medium,
      child: AppAnimations.fadeIn(
        duration: AppAnimations.medium,
        delay: baseDelay * index,
        child: child,
      ),
    );
  }
}

/// Haptic-enabled elevated button
class HapticElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const HapticElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: () {
        AppHaptics.buttonPress();
        onPressed?.call();
      },
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    );
  }
}

/// Haptic-enabled icon button
class HapticIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Icon icon;
  final String? tooltip;

  const HapticIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: () {
        AppHaptics.light();
        onPressed?.call();
      },
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
      ),
    );
  }
}

/// Haptic-enabled floating action button
class HapticFAB extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  final Color? backgroundColor;

  const HapticFAB({
    Key? key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onPressed: () {
        AppHaptics.medium();
        onPressed?.call();
      },
      child: FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }
}
