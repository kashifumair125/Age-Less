import 'package:flutter/services.dart';

/// Service for providing haptic feedback throughout the app
class HapticFeedbackService {
  /// Light impact feedback for button presses
  static Future<void> lightImpact() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium impact feedback for selections
  static Future<void> mediumImpact() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy impact feedback for important actions
  static Future<void> heavyImpact() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection click feedback
  static Future<void> selectionClick() async {
    await HapticFeedback.selectionClick();
  }

  /// Vibrate for errors
  static Future<void> error() async {
    await HapticFeedback.vibrate();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.vibrate();
  }

  /// Vibrate for success
  static Future<void> success() async {
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.mediumImpact();
  }

  /// Vibrate for achievement unlock (celebration pattern)
  static Future<void> achievement() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

  /// Vibrate for warnings
  static Future<void> warning() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.lightImpact();
  }
}

/// Extension on VoidCallback to add haptic feedback
extension HapticVoidCallback on VoidCallback {
  VoidCallback withHaptic({HapticType type = HapticType.light}) {
    return () {
      _provideHaptic(type);
      call();
    };
  }

  void _provideHaptic(HapticType type) {
    switch (type) {
      case HapticType.light:
        HapticFeedbackService.lightImpact();
        break;
      case HapticType.medium:
        HapticFeedbackService.mediumImpact();
        break;
      case HapticType.heavy:
        HapticFeedbackService.heavyImpact();
        break;
      case HapticType.selection:
        HapticFeedbackService.selectionClick();
        break;
      case HapticType.success:
        HapticFeedbackService.success();
        break;
      case HapticType.error:
        HapticFeedbackService.error();
        break;
      case HapticType.warning:
        HapticFeedbackService.warning();
        break;
      case HapticType.achievement:
        HapticFeedbackService.achievement();
        break;
    }
  }
}

enum HapticType {
  light,
  medium,
  heavy,
  selection,
  success,
  error,
  warning,
  achievement,
}
