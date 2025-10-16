// lib/presentation/providers/achievements_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../data/local/hive_config.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final DateTime unlockedAt;
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.unlockedAt,
  });
}

class AchievementsRepository {
  Box get _box => HiveConfig.settingsBox;

  List<Achievement> getAll() {
    final list = (_box.get('achievements') as List?) ?? [];
    return list
        .cast<Map>()
        .map((m) => Achievement(
              id: m['id'] as String,
              title: m['title'] as String,
              description: m['description'] as String,
              unlockedAt: DateTime.parse(m['unlockedAt'] as String),
            ))
        .toList();
  }

  Future<void> add(Achievement a) async {
    final list = (_box.get('achievements') as List?)?.cast<Map>() ?? <Map>[];
    if (list.any((m) => m['id'] == a.id)) return;
    list.add({
      'id': a.id,
      'title': a.title,
      'description': a.description,
      'unlockedAt': a.unlockedAt.toIso8601String(),
    });
    await _box.put('achievements', list);
  }
}

final achievementsRepositoryProvider =
    Provider((ref) => AchievementsRepository());

final achievementsProvider =
    StateNotifierProvider<AchievementsController, List<Achievement>>((ref) =>
        AchievementsController(ref.read(achievementsRepositoryProvider)));

class AchievementsController extends StateNotifier<List<Achievement>> {
  final AchievementsRepository _repo;
  AchievementsController(this._repo) : super([]) {
    state = _repo.getAll();
  }

  Future<void> unlockIfNeeded(
      {required int streakDays, required double weeklyAdherence}) async {
    if (streakDays >= 3 && !_has('streak_3')) {
      await _unlock(
        Achievement(
          id: 'streak_3',
          title: 'Consistency Starter',
          description: 'Logged 3 days in a row',
          unlockedAt: DateTime.now(),
        ),
      );
    }
    if (weeklyAdherence >= 0.8 && !_has('adherence_80')) {
      await _unlock(
        Achievement(
          id: 'adherence_80',
          title: 'On Track',
          description: '80% weekly adherence',
          unlockedAt: DateTime.now(),
        ),
      );
    }
  }

  bool _has(String id) => state.any((a) => a.id == id);

  Future<void> _unlock(Achievement a) async {
    await _repo.add(a);
    state = [...state, a];
  }
}
