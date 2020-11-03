// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerformanceGroupAdapter extends TypeAdapter<PerformanceGroup> {
  @override
  final int typeId = 2;

  @override
  PerformanceGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PerformanceGroup(
      stage: fields[0] as int,
      problem: fields[1] as String,
      age: fields[2] as String,
      performanceKeys: (fields[3] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PerformanceGroup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.stage)
      ..writeByte(1)
      ..write(obj.problem)
      ..writeByte(2)
      ..write(obj.age)
      ..writeByte(3)
      ..write(obj.performanceKeys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
