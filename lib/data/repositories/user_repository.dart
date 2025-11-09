// lib/data/repositories/user_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_profile.dart';
import '../../core/services/error_service.dart';
import '../local/hive_config.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  /// Get user profile
  Future<UserProfile?> getUserProfile() async {
    try {
      final box = HiveConfig.userProfileBox;
      if (box.isEmpty) return null;
      return box.getAt(0);
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'UserRepository.getUserProfile',
      );
      return null;
    }
  }

  /// Save or update user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      final box = HiveConfig.userProfileBox;
      if (box.isEmpty) {
        await box.add(profile);
      } else {
        await box.putAt(0, profile);
      }
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'UserRepository.saveUserProfile',
      );
      throw DataException(
        'Failed to save user profile',
        code: 'SAVE_FAILED',
        details: error,
      );
    }
  }

  /// Update biological age metadata
  Future<void> updateBiologicalAge(double age) async {
    try {
      if (age < 0) {
        throw const ValidationException(
          'Biological age must be non-negative',
          code: 'INVALID_AGE',
        );
      }

      final profile = await getUserProfile();
      if (profile != null) {
        final box = HiveConfig.userProfileBox;
        final updated = profile.copyWith();
        // Persist updated profile fields in settings box until model extended
        await box.putAt(0, updated);
        // Track last assessment metadata in settings box for now
        HiveConfig.settingsBox.put('currentBiologicalAge', age);
        HiveConfig.settingsBox
            .put('lastAssessmentDate', DateTime.now().toIso8601String());
      }
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'UserRepository.updateBiologicalAge',
        metadata: {'age': age},
      );
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile() async {
    try {
      final box = HiveConfig.userProfileBox;
      await box.clear();
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'UserRepository.deleteUserProfile',
      );
      throw DataException(
        'Failed to delete user profile',
        code: 'DELETE_FAILED',
        details: error,
      );
    }
  }

  /// Check if user profile exists
  Future<bool> hasUserProfile() async {
    try {
      final box = HiveConfig.userProfileBox;
      return box.isNotEmpty;
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'UserRepository.hasUserProfile',
      );
      return false;
    }
  }
}
