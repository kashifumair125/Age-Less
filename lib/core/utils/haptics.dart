// lib/core/utils/haptics.dart
import 'package:flutter/services.dart';

/// Haptic feedback utilities for the Age-Less app
class AppHaptics {
  /// Light haptic feedback for subtle interactions
  static Future<void> light() async {
    await HapticFeedback.lightImpact();
  }

  /// Medium haptic feedback for standard interactions
  static Future<void> medium() async {
    await HapticFeedback.mediumImpact();
  }

  /// Heavy haptic feedback for important interactions
  static Future<void> heavy() async {
    await HapticFeedback.heavyImpact();
  }

  /// Selection haptic feedback for picking items
  static Future<void> selection() async {
    await HapticFeedback.selectionClick();
  }

  /// Success haptic feedback (double tap pattern)
  static Future<void> success() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  /// Error haptic feedback (heavy vibration)
  static Future<void> error() async {
    await HapticFeedback.heavyImpact();
  }

  /// Achievement unlock haptic feedback (celebration pattern)
  static Future<void> achievement() async {
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await HapticFeedback.heavyImpact();
  }

  /// Button press haptic feedback
  static Future<void> buttonPress() async {
    await HapticFeedback.lightImpact();
  }

  /// Toggle switch haptic feedback
  static Future<void> toggle() async {
    await HapticFeedback.selectionClick();
  }

  /// Slider change haptic feedback
  static Future<void> sliderChange() async {
    await HapticFeedback.selectionClick();
  }
}

/// Extension on BuildContext to easily access haptic feedback
extension HapticContext on void Function() {
  /// Wraps a callback with light haptic feedback
  void Function() withLightHaptic() {
    return () {
      AppHaptics.light();
      this();
    };
  }

  /// Wraps a callback with medium haptic feedback
  void Function() withMediumHaptic() {
    return () {
      AppHaptics.medium();
      this();
    };
  }

  /// Wraps a callback with heavy haptic feedback
  void Function() withHeavyHaptic() {
    return () {
      AppHaptics.heavy();
      this();
    };
  }

  /// Wraps a callback with button press haptic feedback
  void Function() withButtonHaptic() {
    return () {
      AppHaptics.buttonPress();
      this();
    };
  }
}
