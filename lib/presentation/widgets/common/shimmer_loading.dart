import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Duration duration;

  const ShimmerLoading({
    Key? key,
    required this.child,
    this.isLoading = true,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                AppTheme.grey200,
                AppTheme.grey100,
                AppTheme.grey200,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent - 0.5), 0.0, 0.0);
  }
}

/// Skeleton loader widgets
class SkeletonLoader {
  static Widget card({double height = 100}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.grey200,
        borderRadius: AppBorderRadius.large,
      ),
    );
  }

  static Widget text({
    double width = double.infinity,
    double height = 16,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.grey200,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  static Widget circle({double size = 50}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppTheme.grey200,
        shape: BoxShape.circle,
      ),
    );
  }

  static Widget listItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          circle(size: 50),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(width: double.infinity, height: 16),
                const SizedBox(height: AppSpacing.xs),
                text(width: 200, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget profileHeader() {
    return Column(
      children: [
        circle(size: 100),
        const SizedBox(height: AppSpacing.md),
        text(width: 150, height: 20),
        const SizedBox(height: AppSpacing.xs),
        text(width: 100, height: 14),
      ],
    );
  }

  static Widget statsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: AppBorderRadius.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          text(width: 80, height: 14),
          const SizedBox(height: AppSpacing.sm),
          text(width: 120, height: 24),
          const SizedBox(height: AppSpacing.xs),
          text(width: 60, height: 12),
        ],
      ),
    );
  }
}

/// Loading screen with shimmer effects
class LoadingScreen extends StatelessWidget {
  final String? message;

  const LoadingScreen({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(
                message!,
                style: AppTextStyles.body2.copyWith(
                  color: AppTheme.grey600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Animated loading indicator
class LoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    Key? key,
    this.size = 24,
    this.color,
  }) : super(key: key);

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.color ?? AppTheme.primaryColor,
        ),
      ),
    );
  }
}
