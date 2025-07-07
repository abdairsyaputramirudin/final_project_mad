import 'package:hive/hive.dart';

part 'barang.g.dart';

@HiveType(typeId: 0)
class Barang extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String nama;

  @HiveField(2)
  String kategori;

  @HiveField(3)
  int harga;

  @HiveField(4)
  DateTime tanggalMasuk;

  @HiveField(5)
  int jumlah;

  Barang({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.tanggalMasuk,
    required this.jumlah,
  });

  // Fungsi untuk generate ID barang
  static String generateId(int counter) {
    return 'ID-${counter.toString().padLeft(4, '0')}';
  }
}
