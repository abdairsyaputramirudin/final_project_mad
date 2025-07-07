import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/barang.dart';
import '../viewmodels/kurangi_stok_view_model.dart';

class KurangiStokScreen extends StatelessWidget {
  final Barang barang;
  const KurangiStokScreen({super.key, required this.barang});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) => KurangiStokViewModel(
            barang: barang,
            barangBox: context.read(),
            transaksiBox: context.read(),
          ),
      builder: (context, _) {
        final vm = Provider.of<KurangiStokViewModel>(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Kurangi Stok Barang',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
          backgroundColor: const Color(0xFFF7F6FE),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: ListView(
                    children: [
                      Text(
                        'Barang: ${barang.nama}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: vm.jumlahController,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Pengurangan',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Tanggal Keluar:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            vm.tanggalKeluar.toLocal().toString().split(' ')[0],
                            style: const TextStyle(color: Colors.deepPurple),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => vm.pilihTanggal(context),
                            icon: const Icon(Icons.date_range),
                            label: const Text('Pilih'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final error = await vm.simpanKurangiStok();
                          if (error == null) {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(error)));
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('Simpan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
