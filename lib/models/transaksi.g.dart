// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaksi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransaksiAdapter extends TypeAdapter<Transaksi> {
  @override
  final int typeId = 2;

  @override
  Transaksi read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaksi(
      barangId: fields[0] as String,
      tipe: fields[1] as TipeTransaksi,
      jumlah: fields[2] as int,
      tanggal: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Transaksi obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.barangId)
      ..writeByte(1)
      ..write(obj.tipe)
      ..writeByte(2)
      ..write(obj.jumlah)
      ..writeByte(3)
      ..write(obj.tanggal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransaksiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipeTransaksiAdapter extends TypeAdapter<TipeTransaksi> {
  @override
  final int typeId = 1;

  @override
  TipeTransaksi read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TipeTransaksi.masuk;
      case 1:
        return TipeTransaksi.keluar;
      default:
        return TipeTransaksi.masuk;
    }
  }

  @override
  void write(BinaryWriter writer, TipeTransaksi obj) {
    switch (obj) {
      case TipeTransaksi.masuk:
        writer.writeByte(0);
        break;
      case TipeTransaksi.keluar:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipeTransaksiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
