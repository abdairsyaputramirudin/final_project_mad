import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/barang.dart';
import '../models/transaksi.dart';

class RekapViewModel extends ChangeNotifier {
  final Box<Barang> barangBox;
  final Box<Transaksi> transaksiBox;

  String searchKeyword = '';
  String selectedKategori = 'Semua';

  RekapViewModel({required this.barangBox, required this.transaksiBox});

  void updateSearch(String keyword) {
    searchKeyword = keyword.toLowerCase();
    notifyListeners();
  }

  void updateKategori(String kategori) {
    selectedKategori = kategori;
    notifyListeners();
  }

  List<String> get semuaKategori {
    return {'Semua', ...barangBox.values.map((e) => e.kategori)}.toList();
  }

  bool cocok(Barang barang) {
    final cocokNama = barang.nama.toLowerCase().contains(searchKeyword.trim());
    final cocokKategori =
        selectedKategori == 'Semua' ||
        barang.kategori.toLowerCase() == selectedKategori.toLowerCase();
    return cocokNama && cocokKategori;
  }

  List<Transaksi> get transaksiMasuk {
    final barangMap = {for (var b in barangBox.values) b.id: b};
    return transaksiBox.values
        .where(
          (tx) =>
              tx.tipe == TipeTransaksi.masuk &&
              barangMap[tx.barangId] != null &&
              cocok(barangMap[tx.barangId]!),
        )
        .toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  List<Transaksi> get transaksiKeluar {
    final barangMap = {for (var b in barangBox.values) b.id: b};
    return transaksiBox.values
        .where(
          (tx) =>
              tx.tipe == TipeTransaksi.keluar &&
              barangMap[tx.barangId] != null &&
              cocok(barangMap[tx.barangId]!),
        )
        .toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  List<Barang> get stokBarang {
    return barangBox.values.where(cocok).toList();
  }
}
