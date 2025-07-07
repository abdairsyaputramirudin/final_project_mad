import 'package:hive/hive.dart';
import '../models/barang.dart';

class BarangService {
  final _box = Hive.box<Barang>('barangBox');

  List<Barang> getAll() => _box.values.toList();

  void addBarang(Barang barang) {
    _box.put(barang.id, barang);
  }

  void updateBarang(Barang barang) {
    barang.save();
  }

  void deleteBarang(String id) {
    _box.delete(id);
  }
}
