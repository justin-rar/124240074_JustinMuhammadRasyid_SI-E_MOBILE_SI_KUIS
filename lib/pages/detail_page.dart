import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:kuis/models/stationery_item.dart';

// DetailPage — StatefulWidget karena memiliki TextEditingController dan total live.
class DetailPage extends StatefulWidget {
  final StationeryItem stationery;
  const DetailPage({super.key, required this.stationery});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late final TextEditingController _dscController;
  late final TextEditingController _prcController;
  late final TextEditingController _stokController;

  @override
  void initState() {
    super.initState();
    _dscController = TextEditingController(text: widget.stationery.description);
    _prcController = TextEditingController(
      text: widget.stationery.price.toString(),
    );
    _stokController = TextEditingController(
      text: widget.stationery.stock.toString(),
    );
  }

  @override
  void dispose() {
    // Wajib dispose controller untuk menghindari memory leak
    _dscController.dispose();
    _prcController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stationery = widget.stationery;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      appBar: AppBar(
        title: Text(
          stationery.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // Tombol back berwarna putih
        iconTheme: const IconThemeData(color: Colors.white),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar besar makanan
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: Image.network(
                  stationery.imageUrl,
                  fit: BoxFit.cover,
                  // Indikator loading
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  // Fallback jika gambar gagal dimuat
                  errorBuilder: (context, error, stack) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(Icons.store, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kartu detail makanan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama makanan
                  Text(
                    stationery.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Harga per porsi
                  Text(
                    'Rp ${stationery.formattedPrice} / pcs',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Deskripsi
                  Text(
                    stationery.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ubah deskripsi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ubah Deskripsi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // TextField hanya angka, satu-satunya yang bisa diedit user
                  TextField(
                    controller: _dscController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      labelText: 'deskripsi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  //ubah harga
                  TextField(
                    controller: _prcController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'harga',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  TextField(
                    controller: _stokController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'stok',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.orange.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Kembalikan nilai qty ke Beranda melalui pop
                        Navigator.of(context).pop(_dscController.text);
                      },
                      icon: const Icon(Icons.store, color: Colors.white),
                      label: const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
