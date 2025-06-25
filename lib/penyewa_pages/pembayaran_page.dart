import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rentalin_project/components/main_screen.dart'; // Untuk navigasi ke PesananPage

class PembayaranPage extends StatefulWidget { // Ubah menjadi StatefulWidget
  final String idPembayaran;
  final int totalPembayaran;
  final String idPemesanan; // <--- TAMBAHKAN INI

  const PembayaranPage({
    super.key,
    required this.idPembayaran,
    required this.totalPembayaran,
    required this.idPemesanan, // <--- TAMBAHKAN INI
  });

  @override
  State<PembayaranPage> createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final supabase = Supabase.instance.client;
  bool _isUpdatingStatus = false; // Status untuk tombol "Sudah Bayar"

  Future<void> _handleSudahBayar() async {
    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi.');
      }

      final String currentTimestamp = DateTime.now().toIso8601String();

      // 1. Perbarui tabel "pembayaran"
      await supabase.from('pembayaran').update({
        'status_pembayaran': 'Sudah Bayar',
        'tanggal_pembayaran': currentTimestamp,
      }).eq('id_pembayaran', widget.idPembayaran);

      // 2. Perbarui tabel "pemesanan" (status_pemesanan)
      await supabase.from('pemesanan').update({
        'status_pemesanan': 'Sudah Bayar',
      }).eq('id_pemesanan', widget.idPemesanan); // Gunakan idPemesanan dari widget

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pembayaran berhasil dikonfirmasi!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigasi ke halaman Pesanan Saya
        Navigator.of(context).popUntil((route) => route.isFirst); // Kembali ke root
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainPage(initialPageIndex: 2) // Navigasi ke PesananPage
          )
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengkonfirmasi pembayaran: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error confirming payment: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStatus = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Selesaikan Pembayaran",
          style: TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF001F3F),
          ),
        ),
        backgroundColor: const Color(0xFFE5ECF0),
        iconTheme: const IconThemeData(color: Color(0xFF001F3F)),
      ),
      body: Container(
        color: const Color(0xFFE5ECF0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Bagian QRIS
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "QRIS",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/images/placeholder_qris.png',
                          width: 250,
                          height: 250,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) { // <--- Tambahkan errorBuilder
                            return Container(
                              width: 250,
                              height: 250,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text('Gambar QRIS tidak ditemukan!', textAlign: TextAlign.center,),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "ID Pembayaran",
                              style: TextStyle(fontFamily: 'Sora', fontSize: 16, color: Colors.black54),
                            ),
                            Text(
                              widget.idPembayaran.substring(0, 8),
                              style: const TextStyle(fontFamily: 'Sora', fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Pembayaran",
                              style: TextStyle(fontFamily: 'Sora', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                            ),
                            Text(
                              "Rp${widget.totalPembayaran}",
                              style: const TextStyle(fontFamily: 'Sora', fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Fitur download QRIS belum tersedia.')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0F6D79),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Download QRIS",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Spasi antara tombol Download dan Sudah Bayar
                        ElevatedButton( // Tombol "Sudah Bayar"
                          onPressed: _isUpdatingStatus ? null : _handleSudahBayar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00BCD4), // Warna berbeda untuk tombol ini
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _isUpdatingStatus
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "SUDAH BAYAR",
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tombol "Kembali ke Pesanan Saya" di bagian bawah (di luar Expanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color(0xFFE5ECF0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const MainPage(initialPageIndex: 1)
                    )
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Text(
                  "Kembali ke Pesanan Saya",
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF0F6D79),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}