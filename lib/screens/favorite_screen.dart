import 'package:flutter/material.dart';
import 'package:wisata_candi/data/auth_service.dart';
import 'package:wisata_candi/data/wisata_candi.dart';
import 'package:wisata_candi/screens/details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final favorites =
        candiList.where((c) => AuthService.isFavorite(c.name)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Candi Favorit')),
      body: favorites.isEmpty
          ? const Center(child: Text('Belum ada candi favorit'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final candi = favorites[index];
                return Card(
                  color: Colors.deepPurple.shade50,
                  margin: const EdgeInsets.only(bottom: 8),
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        candi.imageAsset,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      candi.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(candi.location),
                    // Setelah kembali dari Detail, muat ulang daftar.
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(candi: candi),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                );
              },
            ),
    );
  }
}
