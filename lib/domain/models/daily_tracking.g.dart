// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_tracking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyTrackingAdapter extends TypeAdapter<DailyTracking> {
  @override
  final int typeId = 1;

  @override
  DailyTracking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyTracking(
      date: fields[0] as DateTime,
      nutrition: fields[1] as NutritionLog?,
      exercise: fields[2] as ExerciseLog?,
      sleep: fields[3] as SleepLog?,
      stress: fields[4] as StressLog?,
      supplements: fields[5] as SupplementLog?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyTracking obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.nutrition)
      ..writeByte(2)
      ..write(obj.exercise)
      ..writeByte(3)
      ..write(obj.sleep)
      ..writeByte(4)
      ..write(obj.stress)
      ..writeByte(5)
      ..write(obj.supplements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTrackingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NutritionLogAdapter extends TypeAdapter<NutritionLog> {
  @override
  final int typeId = 2;

  @override
  NutritionLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NutritionLog(
      caloriesConsumed: fields[0] as int,
      proteinGrams: fields[1] as double,
      vegetables: fields[2] as int,
      fastingCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NutritionLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.caloriesConsumed)
      ..writeByte(1)
      ..write(obj.proteinGrams)
      ..writeByte(2)
      ..write(obj.vegetables)
      ..writeByte(3)
      ..write(obj.fastingCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NutritionLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExerciseLogAdapter extends TypeAdapter<ExerciseLog> {
  @override
  final int typeId = 3;

  @override
  ExerciseLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseLog(
      totalMinutes: fields[0] as int,
      sessions: (fields[1] as List).cast<WorkoutSession>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.totalMinutes)
      ..writeByte(1)
      ..write(obj.sessions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkoutSessionAdapter extends TypeAdapter<WorkoutSession> {
  @override
  final int typeId = 4;

  @override
  WorkoutSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSession(
      type: fields[0] as String,
      minutes: fields[1] as int,
      intensity: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSession obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.minutes)
      ..writeByte(2)
      ..write(obj.intensity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepLogAdapter extends TypeAdapter<SleepLog> {
  @override
  final int typeId = 5;

  @override
  SleepLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepLog(
      hoursSlept: fields[0] as double,
      sleepQuality: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SleepLog obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hoursSlept)
      ..writeByte(1)
      ..write(obj.sleepQuality);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StressLogAdapter extends TypeAdapter<StressLog> {
  @override
  final int typeId = 6;

  @override
  StressLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StressLog(
      stressLevel: fields[0] as int,
      meditated: fields[1] as bool,
      meditationMinutes: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StressLog obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.stressLevel)
      ..writeByte(1)
      ..write(obj.meditated)
      ..writeByte(2)
      ..write(obj.meditationMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StressLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SupplementLogAdapter extends TypeAdapter<SupplementLog> {
  @override
  final int typeId = 7;

  @override
  SupplementLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupplementLog(
      supplementsTaken: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SupplementLog obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.supplementsTaken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplementLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
