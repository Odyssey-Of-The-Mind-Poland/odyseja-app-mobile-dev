// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InfoAdapter extends TypeAdapter<Info> {
  @override
  final int typeId = 1;

  @override
  Info read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
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

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
