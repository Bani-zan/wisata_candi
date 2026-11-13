import 'package:flutter/material.dart';
import 'package:wisata_candi/models/candi.dart';

class DetailScreen extends StatelessWidget {
  final Candi candi;

  const DetailScreen({super.key, required this.candi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Widget Pertama: Gambar Candi
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                candi.imageAsset, 
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                
              ],
            ),
          ),
          // Widget Kedua: Tombol/Lingkaran Ungu (Perbaikan di sini)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Container(
              width: 50, // Tentukan lebar lingkaran
              height: 50, // Tentukan tinggi lingkaran
              decoration: BoxDecoration(
                color: Colors.deepPurple[100]?.withValues(alpha: 0.8), // 'color' harus huruf kecil
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      
      ),
    );
  }
}
