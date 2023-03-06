// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingProductPropertyTypeAdapter
    extends TypeAdapter<BookingProductPropertyType> {
  @override
  final int typeId = 10;

  @override
  BookingProductPropertyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookingProductPropertyType.DROPDOWN;
      case 1:
        return BookingProductPropertyType.TEXT;
      case 2:
        return BookingProductPropertyType.NUMBER;
      default:
        return BookingProductPropertyType.DROPDOWN;
    }
  }

  @override
  void write(BinaryWriter writer, BookingProductPropertyType obj) {
    switch (obj) {
      case BookingProductPropertyType.DROPDOWN:
        writer.writeByte(0);
        break;
      case BookingProductPropertyType.TEXT:
        writer.writeByte(1);
        break;
      case BookingProductPropertyType.NUMBER:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingProductPropertyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 16;

  @override
  BookingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingModel(
      id: fields[0] as String,
      vendor: fields[1] as String,
      user: fields[2] as String,
      activity: fields[3] as String,
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
  void write(BinaryWriter writer, BookingModel obj) {
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
      other is BookingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingTicketAdapter extends TypeAdapter<BookingTicket> {
  @override
  final int typeId = 15;

  @override
  BookingTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingTicket(
      id: fields[0] as String,
      productId: fields[1] as String,
      ticket: fields[2] as String,
      qr: fields[3] as String,
      status: fields[4] as String,
      price: fields[5] as double,
      additionalServiceInfo:
          (fields[6] as List).cast<AdditionalServiceInfoTicket>(),
      bookingTimeString: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingTicket obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.ticket)
      ..writeByte(3)
      ..write(obj.qr)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.additionalServiceInfo)
      ..writeByte(7)
      ..write(obj.bookingTimeString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdditionalServiceInfoTicketAdapter
    extends TypeAdapter<AdditionalServiceInfoTicket> {
  @override
  final int typeId = 14;

  @override
  AdditionalServiceInfoTicket read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdditionalServiceInfoTicket(
      additionalServiceId: fields[0] as String,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AdditionalServiceInfoTicket obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.additionalServiceId)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdditionalServiceInfoTicketAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingProductAdapter extends TypeAdapter<BookingProduct> {
  @override
  final int typeId = 13;

  @override
  BookingProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingProduct(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      price: fields[3] as double,
      quantity: fields[4] as int,
      categoryTitle: fields[5] as String,
      subCategoryTitle: fields[6] as String,
      properties: (fields[7] as List).cast<BookingProductProperty>(),
      additionalServicesDescription: fields[8] as String,
      additionalServices: (fields[9] as List).cast<ProductAdditionalService>(),
    );
  }

  @override
  void write(BinaryWriter writer, BookingProduct obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.quantity)
      ..writeByte(5)
      ..write(obj.categoryTitle)
      ..writeByte(6)
      ..write(obj.subCategoryTitle)
      ..writeByte(7)
      ..write(obj.properties)
      ..writeByte(8)
      ..write(obj.additionalServicesDescription)
      ..writeByte(9)
      ..write(obj.additionalServices);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductAdditionalServiceAdapter
    extends TypeAdapter<ProductAdditionalService> {
  @override
  final int typeId = 12;

  @override
  ProductAdditionalService read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductAdditionalService(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[3] as String,
      price: fields[4] as double,
      quantity: fields[5] as int,
      properties: (fields[6] as List).cast<BookingProductProperty>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductAdditionalService obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(6)
      ..write(obj.properties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdditionalServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingProductPropertyAdapter
    extends TypeAdapter<BookingProductProperty> {
  @override
  final int typeId = 11;

  @override
  BookingProductProperty read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingProductProperty(
      id: fields[0] as String,
      isRequired: fields[1] as bool,
      title: fields[2] as String,
      info: fields[3] as String,
      type: fields[4] as BookingProductPropertyType,
      value: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BookingProductProperty obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isRequired)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.info)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingProductPropertyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
