// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteProductAdapter extends TypeAdapter<FavoriteProduct> {
  @override
  final int typeId = 2;

  @override
  FavoriteProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteProduct(
      productId: fields[0] as String,
      title: fields[1] as String,
      categoryId: fields[2] as String,
      price: fields[4] as double,
      discountedPrice: fields[5] as double?,
      imageUrl: fields[6] as String?,
      addedDate: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteProduct obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.discountedPrice)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.addedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
