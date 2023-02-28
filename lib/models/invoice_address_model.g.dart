// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAddressModelAdapter extends TypeAdapter<InvoiceAddressModel> {
  @override
  final int typeId = 60;

  @override
  InvoiceAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceAddressModel(
      name: fields[0] as String,
      houseNumber: fields[1] as String,
      street: fields[2] as String,
      city: fields[3] as String,
      zip: fields[4] as int,
      phone: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceAddressModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.houseNumber)
      ..writeByte(2)
      ..write(obj.street)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.zip)
      ..writeByte(5)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
