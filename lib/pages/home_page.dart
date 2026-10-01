import 'package:flutter/material.dart';
import 'package:kuis/models/stationery_item.dart';
import 'package:kuis/pages/detail_page.dart';

// HomePage — StatefulWidget karena menyimpan daftar makanan dan qty bisa berubah.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State daftar makanan; late final agar tidak direset saat rebuild
  late final List<StationeryItem> _foods = StationeryItem.sampleData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        title: const Text(
          'Toko Alat Tulis',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _foods.length,
        itemBuilder: (context, index) {
          final item = _foods[index];
          return _FoodCard(
            stationery: item,
            // Klik kartu → buka Detail, tunggu hasil qty
            onTap: () async {
              final result = await Navigator.push<int>(
                context,
                MaterialPageRoute(builder: (_) => DetailPage(stationery: item)),
              );
              // Perbarui qty di Beranda setelah kembali dari Detail
              if (result != null) {
                setState(() => item.stock = result);
              }
            },
          );
        },
      ),
    );
  }
}

// _FoodCard — StatelessWidget, hanya menampilkan data dari parent.
class _FoodCard extends StatelessWidget {
  final StationeryItem stationery;
  final VoidCallback onTap;

  const _FoodCard({required this.stationery, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shadowColor: Colors.orange.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Gambar di sisi kiri
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: Image.network(
                      stationery.imageUrl,
                      fit: BoxFit.cover,
                      // Spinner saat loading
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      },
                      // Fallback saat gambar gagal
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.store,
                            size: 36,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Kolom tengah: nama, deskripsi, porsi, harga satuan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nama makanan
                      Text(
                        stationery.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Deskripsi maks 2 baris
                      Text(
                        stationery.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Baris jumlah porsi dan harga satuan
                      Row(
                        children: [
                          Text(
                            '${stationery.stock} pcs tersedia',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Rp ${stationery.formattedPrice} / pcs',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. Kanan: total harga (sejajar baris porsi)
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Rp ${stationery.formattedTotal}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
