// lib/data/repositories/user_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_profile.dart';
import '../local/hive_config.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  Future<UserProfile?> getUserProfile() async {
    final box = HiveConfig.userProfileBox;
    if (box.isEmpty) return null;
    return box.getAt(0);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final box = HiveConfig.userProfileBox;
    if (box.isEmpty) {
      await box.add(profile);
    } else {
      await box.putAt(0, profile);
    }
  }

  Future<void> updateBiologicalAge(double age) async {
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
  }
}
