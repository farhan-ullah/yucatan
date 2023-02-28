// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityModelAdapter extends TypeAdapter<ActivityModel> {
  @override
  final int typeId = 30;

  @override
  ActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityModel()
      ..location = fields[0] as ActivityModelLocation
      ..title = fields[1] as String
      ..description = fields[2] as String
      ..activityDetails = fields[3] as ActivityModelActivityDetails;
  }

  @override
  void write(BinaryWriter writer, ActivityModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.location)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.activityDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityModelLocationAdapter extends TypeAdapter<ActivityModelLocation> {
  @override
  final int typeId = 20;

  @override
  ActivityModelLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityModelLocation()
      ..street = fields[0] as String
      ..housenumber = fields[1] as String
      ..zipcode = fields[2] as int
      ..city = fields[3] as String
      ..state = fields[4] as String
      ..country = fields[5] as String
      ..lat = fields[6] as String
      ..lon = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, ActivityModelLocation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.street)
      ..writeByte(1)
      ..write(obj.housenumber)
      ..writeByte(2)
      ..write(obj.zipcode)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.state)
      ..writeByte(5)
      ..write(obj.country)
      ..writeByte(6)
      ..write(obj.lat)
      ..writeByte(7)
      ..write(obj.lon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModelLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivityModelActivityDetailsAdapter
    extends TypeAdapter<ActivityModelActivityDetails> {
  @override
  final int typeId = 21;

  @override
  ActivityModelActivityDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityModelActivityDetails()
      ..title = fields[0] as String
      ..shortDescription = fields[1] as String
      ..longDescription = fields[2] as String
      ..packageIncluded = fields[3] as String
      ..packageNotIncluded = fields[4] as String
      ..cancellation = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, ActivityModelActivityDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.shortDescription)
      ..writeByte(2)
      ..write(obj.longDescription)
      ..writeByte(3)
      ..write(obj.packageIncluded)
      ..writeByte(4)
      ..write(obj.packageNotIncluded)
      ..writeByte(5)
      ..write(obj.cancellation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModelActivityDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
