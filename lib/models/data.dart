// Model User untuk autentikasi.
class User {
  String username;
  String password;
  String nama;

  User({required this.username, required this.password, required this.nama});
}

// Data contoh user (tidak dipakai di alur utama, hanya referensi login).
User user1 = User(
  username: 'justin',
  password: 'justin123',
  nama: 'Justin Muhammad Rasyid',
);

// Nama pelanggan yang tampil di halaman Profil.
const String customerName = 'Justin Muhammad Rasyid';
