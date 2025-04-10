// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddToCardModelAdapter extends TypeAdapter<AddToCardModel> {
  @override
  final int typeId = 0;

  @override
  AddToCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddToCardModel(
      productId: fields[0] as String,
      title: fields[1] as String,
      categoryId: fields[2] as String,
      color: fields[3] as String,
      createdDate: fields[4] as DateTime,
      price: fields[5] as double,
      size: fields[6] as String,
      quantity: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AddToCardModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.createdDate)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.size)
      ..writeByte(7)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddToCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
