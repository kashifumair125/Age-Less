// lib/presentation/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';
import '../../core/services/error_service.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  try {
    // Keep provider alive for caching
    ref.keepAlive();

    final repository = ref.watch(userRepositoryProvider);
    final profile = await repository.getUserProfile();

    return profile;
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'userProfileProvider');
    rethrow;
  }
});

class BiologicalAgeNotifier extends Notifier<double?> {
  @override
  double? build() {
    return null;
  }

  void updateAge(double? newAge) {
    state = newAge;
  }
}

final biologicalAgeProvider = NotifierProvider<BiologicalAgeNotifier, double?>(
  () => BiologicalAgeNotifier(),
);
