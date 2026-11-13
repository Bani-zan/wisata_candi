// Penyimpanan akun sederhana (hanya di memori / RAM).
// Data hilang saat aplikasi ditutup. Untuk data permanen, nanti bisa
// diganti dengan paket shared_preferences.
class AuthService {
  // key = nama pengguna, value = data akun.
  static final Map<String, Map<String, String>> _users = {};

  // key = nama pengguna, value = daftar nama candi yang difavoritkan.
  static final Map<String, Set<String>> _favorites = {};

  // Nama pengguna yang sedang login (null jika belum login).
  static String? currentUsername;

  static bool signUp({
    required String name,
    required String username,
    required String password,
  }) {
    if (_users.containsKey(username)) return false;
    _users[username] = {'name': name, 'password': password};
    _favorites[username] = {};
    return true;
  }

  static bool signIn(String username, String password) {
    final user = _users[username];
    if (user == null || user['password'] != password) return false;
    currentUsername = username;
    return true;
  }

  static void signOut() => currentUsername = null;

  static String get currentName => _users[currentUsername]?['name'] ?? '-';

  static void updateName(String newName) {
    if (currentUsername != null && newName.trim().isNotEmpty) {
      _users[currentUsername]!['name'] = newName.trim();
    }
  }

  // ---- Favorit ----
  static Set<String> get favorites =>
      _favorites[currentUsername] ?? <String>{};

  static bool isFavorite(String candiName) => favorites.contains(candiName);

  static void toggleFavorite(String candiName) {
    final set = _favorites.putIfAbsent(currentUsername ?? '', () => {});
    if (!set.remove(candiName)) set.add(candiName);
  }
}