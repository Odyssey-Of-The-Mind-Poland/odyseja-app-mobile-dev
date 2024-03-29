// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerformanceAdapter extends TypeAdapter<Performance> {
  @override
  final int typeId = 0;

  @override
  Performance read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Performance(
      faved: fields[8] as bool,
      id: fields[0] as int,
      city: fields[1] as String,
      team: fields[2] as String,
      problem: fields[3] as String,
      age: fields[4] as String,
      play: fields[5] as String,
      spontan: fields[6] as String,
      stage: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Performance obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.team)
      ..writeByte(3)
      ..write(obj.problem)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.play)
      ..writeByte(6)
      ..write(obj.spontan)
      ..writeByte(7)
      ..write(obj.stage)
      ..writeByte(8)
      ..write(obj.faved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PerformanceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
