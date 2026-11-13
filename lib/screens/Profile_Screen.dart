import 'package:flutter/material.dart';
import 'package:wisata_candi/data/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              AuthService.currentName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text('@${AuthService.currentUsername ?? '-'}'),
            const SizedBox(height: 24),
            TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              onPressed: () {
                AuthService.signOut();
                // Hapus semua halaman sebelumnya, kembali ke Sign In.
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signin', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}