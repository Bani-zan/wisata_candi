import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisata_candi/widgets/edit_fullname_dialog.dart';

import '../widgets/profile_info_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: 1. Deklarasikan variabel yang dibutuhkan
  bool isSignedIn = false;
  String fullName = '';
  String userName = '';
  int favoriteCandiCount = 0;
  late Color iconColor;

  // Mengambil data pengguna dari SharedPreferences
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final signedIn = prefs.getBool('isSignedIn') ?? false;

    if (!signedIn) {
      setState(() {
        isSignedIn = false;
        fullName = '';
        userName = '';
      });
      return;
    }

    try {
      final keyString = prefs.getString('key') ?? '';
      final ivString = prefs.getString('iv') ?? '';

      final encryptedName = prefs.getString('fullname') ?? '';
      final encryptedUsername = prefs.getString('username') ?? '';

      if (keyString.isEmpty ||
          ivString.isEmpty ||
          encryptedName.isEmpty ||
          encryptedUsername.isEmpty) {
        return;
      }

      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final decryptedName = encrypter.decrypt64(encryptedName, iv: iv);

      final decryptedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);

      if (!mounted) return;

      setState(() {
        isSignedIn = true;
        fullName = decryptedName;
        userName = decryptedUsername;
      });
    } catch (e) {
      debugPrint('Gagal mengambil data pengguna: $e');
    }
  }

  Future<void> loadFavoriteCount() async {
    final prefs = await SharedPreferences.getInstance();

    // Mengambil seluruh key SharedPreferences
    final keys = prefs.getKeys();

    // Menghitung jumlah favorit yang bernilai true
    int count = 0;

    for (final key in keys) {
      if (key.startsWith('favorite_') && prefs.getBool(key) == true) {
        count++;
      }
    }

    if (!mounted) return;

    setState(() {
      favoriteCandiCount = count;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
    loadFavoriteCount();
  }

  // TODO: 5. Implementasi fungsi signIn
  void signIn() async {
    await Navigator.pushNamed(context, '/signin');

    // Memuat ulang data setelah kembali dari halaman Sign In
    if (!mounted) return;
    await loadUserData();
  }

  // TODO: 6. Implementasi fungsi signOut
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isSignedIn', false);
    await prefs.setString('fullname', '');
    await prefs.setString('username', '');
    await prefs.setString('password', '');

    setState(() {
      isSignedIn = false;
      fullName = '';
      userName = '';
    });
  }

  // TODO: 7. Implementasi fungsi Edit Full Name
  Future<void> editFullName() async {
    // Tampilkan dialog edit nama
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return EditFullNameDialog(initialName: fullName);
      },
    );

    // Validasi hasil dialog
    if (!mounted || newName == null || newName.isEmpty) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      final keyString = prefs.getString('key') ?? '';
      final ivString = prefs.getString('iv') ?? '';

      if (keyString.isEmpty || ivString.isEmpty) {
        throw Exception('Encryption key atau IV tidak ditemukan');
      }

      final key = encrypt.Key.fromBase64(keyString);
      final iv = encrypt.IV.fromBase64(ivString);

      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      // Enkripsi nama baru
      final encryptedName = encrypter.encrypt(newName, iv: iv);

      // Simpan ke SharedPreferences
      await prefs.setString('fullname', encryptedName.base64);

      if (!mounted) return;

      // Perbarui tampilan
      setState(() {
        fullName = newName;
      });

      debugPrint('Nama berhasil diperbarui');
    } catch (e) {
      debugPrint('Gagal mengubah nama: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // TODO: 2. Buat bagian ProfileHeader yang berisi gambar profil
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 200 - 50),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.deepPurple,
                              width: 2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(
                              'images/placeholder_image.png',
                            ),
                          ),
                        ),
                        if (isSignedIn)
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.camera_alt,
                              color: Colors.deepPurple[50],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // TODO: 3. Buat bagian ProfileInfo yang berisi info profil
                const SizedBox(height: 20),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.lock,
                  label: 'Pengguna',
                  value: userName,
                  iconColor: Colors.amber,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.person,
                  label: 'Nama',
                  value: fullName,
                  showEditIcon: isSignedIn,
                  onEditPressed: editFullName,
                  iconColor: Colors.blue,
                ),
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 4),
                ProfileInfoItem(
                  icon: Icons.favorite,
                  label: 'Favorit',
                  value: favoriteCandiCount.toString(),
                  iconColor: Colors.red,
                ),
                // TODO: 4. Buat ProfileActions yang berisi TextButton sign in/out
                const SizedBox(height: 4),
                Divider(color: Colors.deepPurple[100]),
                const SizedBox(height: 20),
                isSignedIn
                    ? TextButton(
                        onPressed: signOut,
                        child: const Text('Sign Out'),
                      )
                    : TextButton(
                        onPressed: signIn,
                        child: const Text('Sign In'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}