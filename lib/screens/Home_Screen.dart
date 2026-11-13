import 'package:flutter/material.dart';

// Placeholder (halaman sementara). Nanti diganti dengan daftar candi
// dari data/wisata_candi.dart.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wisata Candi')),
      body: const Center(child: Text('Daftar candi tampil di sini')),
    );
  }
}