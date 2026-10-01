import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void initState() {
    super.initState();
    _dscController = TextEditingController(text: widget.stationery.description);
  }

  @override
  void dispose() {
    // Wajib dispose controller untuk menghindari memory leak
    _dscController.dispose();
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

            // Kartu input jumlah porsi
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
                    'Jumlah Pesanan',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Baris input: tombol -, TextField, tombol +
                  Row(
                    children: [
                      // Tombol kurang porsi
                      _QtyButton(
                        icon: Icons.remove,
                        onPressed: () => _changeQty(-1),
                      ),
                      const SizedBox(width: 12),

                      // TextField hanya angka, satu-satunya yang bisa diedit user
                      Expanded(
                        child: TextField(
                          controller: _dscController,
                          keyboardType: TextInputType.text,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Jumlah (porsi)',
                            prefixIcon: const Icon(
                              Icons.dining,
                              color: Colors.orange,
                            ),
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
                              borderSide: BorderSide(
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                          // Total berubah live saat angka diketik
                          onChanged: (val) {
                            final parsed = int.tryParse(val) ?? 0;
                            final clamped = parsed.clamp(0, 99);
                            setState(() => _currentQty = clamped);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Tombol tambah porsi
                      _QtyButton(
                        icon: Icons.add,
                        onPressed: () => _changeQty(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Baris total harga (live)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Rp ${formatPrice(_totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tombol simpan pemesanan — lebar penuh
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Kembalikan nilai qty ke Beranda melalui pop
                  Navigator.pop(context, _currentQty);
                },
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
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
    );
  }
}

// Tombol + dan - yang seragam — StatelessWidget
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.deepOrange, size: 20),
        ),
      ),
    );
  }
}
