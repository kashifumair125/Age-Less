// lib/presentation/providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_profile.dart';
import '../../data/repositories/user_repository.dart';

final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return await repository.getUserProfile();
});

final biologicalAgeProvider = StateProvider<double?>((ref) {
  return null;
});
