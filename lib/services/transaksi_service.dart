import 'package:hive/hive.dart';
import '../models/transaksi.dart';

class TransaksiService {
  final _box = Hive.box<Transaksi>('transaksiBox');

  List<Transaksi> getAll() => _box.values.toList();

  void tambahTransaksi(Transaksi transaksi) {
    _box.add(transaksi);
  }

  List<Transaksi> getByBarang(String barangId) {
    return _box.values.where((e) => e.barangId == barangId).toList();
  }
}
