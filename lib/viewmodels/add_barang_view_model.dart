import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/barang.dart';
import '../models/transaksi.dart';

class AddBarangViewModel extends ChangeNotifier {
  final Box<Barang> barangBox;
  final Box<Transaksi> transaksiBox;

  final namaController = TextEditingController();
  final kategoriController = TextEditingController();
  final hargaController = TextEditingController();
  final jumlahController = TextEditingController();
  DateTime tanggalMasuk = DateTime.now();

  AddBarangViewModel({required this.barangBox, required this.transaksiBox});

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

  Future<bool> simpanBarang() async {
    if (namaController.text.isEmpty ||
        kategoriController.text.isEmpty ||
        hargaController.text.isEmpty ||
        jumlahController.text.isEmpty) {
      return false;
    }

    final existingIds = barangBox.values.map((e) => e.id).toList();

    int lastNumber = 0;
    for (var id in existingIds) {
      final match = RegExp(r'BR-(\d+)').firstMatch(id);
      if (match != null) {
        final num = int.tryParse(match.group(1)!) ?? 0;
        if (num > lastNumber) lastNumber = num;
      }
    }

    final newNumber = lastNumber + 1;
    final newBarangId = 'BR-${newNumber.toString().padLeft(3, '0')}';

    final barang = Barang(
      id: newBarangId,
      nama: namaController.text,
      kategori: kategoriController.text,
      harga: int.tryParse(hargaController.text) ?? 0,
      tanggalMasuk: tanggalMasuk,
      jumlah: int.tryParse(jumlahController.text) ?? 0,
    );

    await barangBox.put(newBarangId, barang);

    final transaksi = Transaksi(
      barangId: newBarangId,
      tipe: TipeTransaksi.masuk,
      jumlah: barang.jumlah,
      tanggal: tanggalMasuk,
    );

    await transaksiBox.add(transaksi);
    return true;
  }
}
