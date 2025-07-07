import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/barang.dart';
import '../models/transaksi.dart';

class HomeViewModel extends ChangeNotifier {
  final Box<Barang> barangBox;
  final Box<Transaksi> transaksiBox;

  late final VoidCallback _listener;
  List<Barang> _semuaBarang = [];
  String _searchKeyword = '';
  bool _urutTerbaru = true;

  List<Barang> get semuaBarang {
    final filtered =
        _semuaBarang.where((b) {
          final keyword = _searchKeyword.toLowerCase();
          return b.nama.toLowerCase().contains(keyword) ||
              b.id.toLowerCase().contains(keyword);
        }).toList();

    filtered.sort(
      (a, b) =>
          _urutTerbaru
              ? b.tanggalMasuk.compareTo(a.tanggalMasuk)
              : a.tanggalMasuk.compareTo(b.tanggalMasuk),
    );

    return filtered;
  }

  HomeViewModel({required this.barangBox, required this.transaksiBox}) {
    _semuaBarang = barangBox.values.toList();
    _listener = () {
      _semuaBarang = barangBox.values.toList();
      notifyListeners();
    };
    barangBox.listenable().addListener(_listener);
  }

  void updateSearch(String keyword) {
    _searchKeyword = keyword;
    notifyListeners();
  }

  void toggleUrutan() {
    _urutTerbaru = !_urutTerbaru;
    notifyListeners();
  }

  Future<void> hapusBarang(String id) async {
    await barangBox.delete(id);
    await transaksiBox.deleteAll(
      transaksiBox.values.where((t) => t.barangId == id).map((t) => t.key),
    );
  }

  Future<void> hapusSemua() async {
    await barangBox.clear();
    await transaksiBox.clear();
  }

  @override
  void dispose() {
    barangBox.listenable().removeListener(_listener);
    super.dispose();
  }
}
