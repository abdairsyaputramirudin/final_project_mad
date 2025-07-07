import 'package:hive/hive.dart';
part 'transaksi.g.dart';

@HiveType(typeId: 1)
enum TipeTransaksi {
  @HiveField(0)
  masuk,

  @HiveField(1)
  keluar,
}

@HiveType(typeId: 2)
class Transaksi extends HiveObject {
  @HiveField(0)
  String barangId;

  @HiveField(1)
  TipeTransaksi tipe;

  @HiveField(2)
  int jumlah;

  @HiveField(3)
  DateTime tanggal;

  Transaksi({
    required this.barangId,
    required this.tipe,
    required this.jumlah,
    required this.tanggal,
  });
}
