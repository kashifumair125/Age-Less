// lib/presentation/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserProfile();
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
