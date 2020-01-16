// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PerformanceAdapter extends TypeAdapter<Performance> {
  @override
  final typeId = 0;

  @override
  Performance read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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
}

class InfoAdapter extends TypeAdapter<Info> {
  @override
  final typeId = 1;

  @override
  Info read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Info(
      id: fields[0] as int,
      infoText: fields[1] as String,
      city: fields[2] as String,
      infName: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Info obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.infoText)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.infName);
  }
}
