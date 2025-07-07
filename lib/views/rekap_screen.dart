import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/barang.dart';
import '../models/transaksi.dart';
import '../viewmodels/rekap_view_model.dart';

class RekapScreen extends StatelessWidget {
  const RekapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => RekapViewModel(
            barangBox: Hive.box<Barang>('barangBox'),
            transaksiBox: Hive.box<Transaksi>('transaksiBox'),
          ),
      builder: (context, _) {
        final vm = Provider.of<RekapViewModel>(context);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Rekap Barang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.arrow_downward), text: 'Masuk'),
                  Tab(icon: Icon(Icons.arrow_upward), text: 'Keluar'),
                  Tab(icon: Icon(Icons.inventory_2), text: 'Stok'),
                ],
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Cari nama barang...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: vm.updateSearch,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Kategori: '),
                          const SizedBox(width: 8),
                          DropdownButton<String>(
                            value: vm.selectedKategori,
                            items:
                                vm.semuaKategori
                                    .map(
                                      (kat) => DropdownMenuItem(
                                        value: kat,
                                        child: Text(kat),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) {
                              if (val != null) vm.updateKategori(val);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildTransaksiList(vm.transaksiMasuk, vm.barangBox),
                      _buildTransaksiList(vm.transaksiKeluar, vm.barangBox),
                      _buildStokList(vm.stokBarang),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTransaksiList(List<Transaksi> list, Box<Barang> barangBox) {
    final barangMap = {for (var barang in barangBox.values) barang.id: barang};
    if (list.isEmpty) {
      return const Center(child: Text('Tidak ada transaksi yang cocok.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final tx = list[index];
        final barang = barangMap[tx.barangId]!;
        final warna =
            tx.tipe == TipeTransaksi.masuk ? Colors.green : Colors.red;

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Icon(Icons.circle, color: warna, size: 14),
            title: Text(
              '${barang.id} | ${barang.nama}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kategori: ${barang.kategori}'),
                Text('Harga: Rp ${barang.harga}'),
                Text('Tgl: ${tx.tanggal.toLocal().toString().split(' ')[0]}'),
                Text('Jumlah: ${tx.jumlah}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStokList(List<Barang> list) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    if (list.isEmpty) {
      return const Center(child: Text('Tidak ada barang yang cocok.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final barang = list[index];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.inventory_2,
                  size: 40,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        barang.nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('ID: ${barang.id}'),
                      Text('Kategori: ${barang.kategori}'),
                      Text('Harga: ${formatter.format(barang.harga)}'),
                      Text('Stok: ${barang.jumlah}'),
                      Text(
                        'Masuk Terakhir: ${barang.tanggalMasuk.toLocal().toString().split(' ')[0]}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
