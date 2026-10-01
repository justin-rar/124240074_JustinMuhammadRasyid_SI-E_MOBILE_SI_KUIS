import 'package:flutter/material.dart';
import 'package:kuis/pages/home_page.dart';
import 'package:kuis/pages/profile_page.dart';

// RootPage — StatefulWidget karena menyimpan indeks tab aktif.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  // Indeks tab aktif (0 = Menu, 1 = Profil)
  int _currentIndex = 0;

  // Gunakan IndexedStack agar state Beranda (porsi) tidak hilang saat pindah tab
  final List<Widget> _pages = const [HomePage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mempertahankan state semua halaman
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        // Indikator pill berwarna oranye
        indicatorColor: Colors.orange.shade100,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.store),
            selectedIcon: Icon(Icons.store, color: Colors.deepOrange),
            label: 'Barang',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.deepOrange),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
