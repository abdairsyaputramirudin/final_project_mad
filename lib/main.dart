import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/barang.dart';
import 'models/transaksi.dart';
import 'viewmodels/home_view_model.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(BarangAdapter());
  Hive.registerAdapter(TransaksiAdapter());
  Hive.registerAdapter(TipeTransaksiAdapter());

  final barangBox = await Hive.openBox<Barang>('barangBox');
  final transaksiBox = await Hive.openBox<Transaksi>('transaksiBox');

  runApp(
    MultiProvider(
      providers: [
        Provider<Box<Barang>>.value(value: barangBox),
        Provider<Box<Transaksi>>.value(value: transaksiBox),
        ChangeNotifierProvider(
          create:
              (_) => HomeViewModel(
                barangBox: barangBox,
                transaksiBox: transaksiBox,
              ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Stok Barang',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
