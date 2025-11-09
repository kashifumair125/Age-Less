import 'package:hive/hive.dart';

part 'health_profile.g.dart';

@HiveType(typeId: 10)
class HealthProfile {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final List<MedicalCondition> medicalHistory;

  @HiveField(2)
  final List<Medication> currentMedications;

  @HiveField(3)
  final List<String> allergies;

  @HiveField(4)
  final String? doctorNotes;

  @HiveField(5)
  final DateTime lastUpdated;

  const HealthProfile({
    required this.userId,
    required this.medicalHistory,
    required this.currentMedications,
    required this.allergies,
    this.doctorNotes,
    required this.lastUpdated,
  });

  HealthProfile copyWith({
    String? userId,
    List<MedicalCondition>? medicalHistory,
    List<Medication>? currentMedications,
    List<String>? allergies,
    String? doctorNotes,
    DateTime? lastUpdated,
  }) {
    return HealthProfile(
      userId: userId ?? this.userId,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      currentMedications: currentMedications ?? this.currentMedications,
      allergies: allergies ?? this.allergies,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

@HiveType(typeId: 11)
class MedicalCondition {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime diagnosedDate;

  @HiveField(2)
  final String? notes;

  const MedicalCondition({
    required this.name,
    required this.diagnosedDate,
    this.notes,
  });
}

@HiveType(typeId: 12)
class Medication {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String dosage;

  @HiveField(2)
  final String frequency;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final String? notes;

  const Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    this.notes,
  });
}

@HiveType(typeId: 13)
class WeightMeasurement {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final double weightKg;

  @HiveField(2)
  final double? bodyFatPercentage;

  const WeightMeasurement({
    required this.date,
    required this.weightKg,
    this.bodyFatPercentage,
  });
}

@HiveType(typeId: 14)
class Milestone {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime achievedDate;

  @HiveField(4)
  final String icon;

  const Milestone({
    required this.id,
    required this.title,
    required this.description,
    required this.achievedDate,
    required this.icon,
  });
}
