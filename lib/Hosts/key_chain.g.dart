// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_chain.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KeyChainAdapter extends TypeAdapter<KeyChain> {
  @override
  final int typeId = 11;

  @override
  KeyChain read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KeyChain(
      password: fields[0] as String?,
      Pem: fields[1] as String?,
      passphrase: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, KeyChain obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.password)
      ..writeByte(1)
      ..write(obj.Pem)
      ..writeByte(2)
      ..write(obj.passphrase);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KeyChainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
