import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  final DateTime? birthDate;

  @HiveField(5)
  final double heightCm;

  @HiveField(6)
  final double weightKg;

  @HiveField(7)
  final String? gender;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.birthDate,
    required this.heightCm,
    required this.weightKg,
    this.gender,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? createdAt,
    DateTime? birthDate,
    double? heightCm,
    double? weightKg,
    String? gender,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      birthDate: birthDate ?? this.birthDate,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      gender: gender ?? this.gender,
    );
  }
}

