import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/barang.dart';
import '../models/transaksi.dart';

class KurangiStokViewModel extends ChangeNotifier {
  final Box<Barang> barangBox;
  final Box<Transaksi> transaksiBox;
  final Barang barang;

  final jumlahController = TextEditingController();
  DateTime tanggalKeluar = DateTime.now();

  KurangiStokViewModel({
    required this.barang,
    required this.barangBox,
    required this.transaksiBox,
  });

  Future<void> pilihTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalKeluar,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      tanggalKeluar = picked;
      notifyListeners();
    }
  }

  Future<String?> simpanKurangiStok() async {
    if (jumlahController.text.isEmpty) return 'Wajib diisi';

    final pengurangan = int.tryParse(jumlahController.text);
    if (pengurangan == null) return 'Jumlah tidak valid';
    if (pengurangan > barang.jumlah) return 'Jumlah melebihi stok tersedia';

    barang.jumlah -= pengurangan;
    await barangBox.put(barang.id, barang);

    final transaksi = Transaksi(
      barangId: barang.id,
      tipe: TipeTransaksi.keluar,
      jumlah: pengurangan,
      tanggal: tanggalKeluar,
    );

    await transaksiBox.add(transaksi);
    return null; // sukses
  }

  void disposeControllers() {
    jumlahController.dispose();
  }
}
