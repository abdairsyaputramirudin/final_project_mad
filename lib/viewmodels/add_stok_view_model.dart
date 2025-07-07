import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/barang.dart';
import '../models/transaksi.dart';

class AddStokViewModel extends ChangeNotifier {
  final Box<Barang> barangBox;
  final Box<Transaksi> transaksiBox;
  final Barang barang;

  final jumlahController = TextEditingController();
  DateTime tanggalMasuk = DateTime.now();

  AddStokViewModel({
    required this.barang,
    required this.barangBox,
    required this.transaksiBox,
  });

  Future<void> pilihTanggal(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: tanggalMasuk,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      tanggalMasuk = picked;
      notifyListeners();
    }
  }

  Future<bool> simpanTambahStok() async {
    if (jumlahController.text.isEmpty) return false;

    final tambah = int.tryParse(jumlahController.text);
    if (tambah == null) return false;

    barang.jumlah += tambah;
    barang.tanggalMasuk = tanggalMasuk;
    await barangBox.put(barang.id, barang);

    final transaksi = Transaksi(
      barangId: barang.id,
      tipe: TipeTransaksi.masuk,
      jumlah: tambah,
      tanggal: tanggalMasuk,
    );

    await transaksiBox.add(transaksi);
    return true;
  }

  void disposeControllers() {
    jumlahController.dispose();
  }
}
