// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_detailed_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingDetailedModelAdapter extends TypeAdapter<BookingDetailedModel> {
  @override
  final int typeId = 17;

  @override
  BookingDetailedModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingDetailedModel(
      id: fields[0] as String,
      vendor: fields[1] as String,
      user: fields[2] as UserModel,
      activity: fields[3] as ActivityModel,
      status: fields[4] as String,
      paymentProvider: fields[5] as String,
      currency: fields[6] as String,
      paypalPaymentId: fields[7] as String,
      totalPrice: fields[8] as double,
      bookingDate: fields[9] as DateTime,
      reference: fields[10] as String,
      tickets: (fields[11] as List).cast<BookingTicket>(),
      products: (fields[12] as List).cast<BookingProduct>(),
      requestNote: fields[13] as String,
      invoiceAddress: fields[14] as InvoiceAddressModel,
    );
  }

  @override
  void write(BinaryWriter writer, BookingDetailedModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.vendor)
      ..writeByte(2)
      ..write(obj.user)
      ..writeByte(3)
      ..write(obj.activity)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.paymentProvider)
      ..writeByte(6)
      ..write(obj.currency)
      ..writeByte(7)
      ..write(obj.paypalPaymentId)
      ..writeByte(8)
      ..write(obj.totalPrice)
      ..writeByte(9)
      ..write(obj.bookingDate)
      ..writeByte(10)
      ..write(obj.reference)
      ..writeByte(11)
      ..write(obj.tickets)
      ..writeByte(12)
      ..write(obj.products)
      ..writeByte(13)
      ..write(obj.requestNote)
      ..writeByte(14)
      ..write(obj.invoiceAddress);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingDetailedModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
