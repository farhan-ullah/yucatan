// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_search_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalSearchModelAdapter extends TypeAdapter<LocalSearchModel> {
  @override
  final int typeId = 102;

  @override
  LocalSearchModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalSearchModel()
      ..index = fields[0] as int
      ..query = fields[1] as String
      ..dateTime = fields[2] as DateTime;
  }

  @override
  void write(BinaryWriter writer, LocalSearchModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.query)
      ..writeByte(2)
      ..write(obj.dateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalSearchModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
