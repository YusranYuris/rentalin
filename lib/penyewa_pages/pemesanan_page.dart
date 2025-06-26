import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:rentalin_project/perental_pages/produkAnda_page.dart';
import 'package:rentalin_project/penyewa_pages/pembayaran_page.dart'; // Import halaman pembayaran QRIS
import 'package:rentalin_project/components/main_screen.dart'; // Untuk navigasi ke PesananPage
import 'package:intl/intl.dart';

class PemesananPage extends StatefulWidget {
  final Product product;

  const PemesananPage({super.key, required this.product});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  final supabase = Supabase.instance.client;
  final Uuid uuid = const Uuid();

  String _selectedMetodePembayaran = "QRIS";
  bool _isProcessingOrder = false;

  Future<void> _handlePesanSekarang() async {
    setState(() {
      _isProcessingOrder = true;
    });

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi.');
      }

      final String idPemesanan = uuid.v4();
      final String idPembayaran = uuid.v4();
      final String idProduk = widget.product.idProduk;
      final String idUser = currentUser.id;
      final String tanggalPemesanan = DateTime.now().toIso8601String().substring(0, 10);

      // 1. Masukkan data ke tabel "pemesanan"
      await supabase.from('pemesanan').insert({
        'id_pemesanan': idPemesanan,
        'id_produk': idProduk,
        'id_user': idUser,
        'tanggal_pemesanan': tanggalPemesanan,
        'status_pemesanan': 'Belum Bayar',
      });

      // 2. Masukkan data ke tabel "pembayaran"
      await supabase.from('pembayaran').insert({
        'id_pemesanan': idPemesanan,
        'id_pembayaran': idPembayaran,
        'metode_pembayaran': _selectedMetodePembayaran,
        'tanggal_pembayaran': null,
        'status_pembayaran': 'Belum Bayar',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pemesanan berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );

        if (_selectedMetodePembayaran == "QRIS") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PembayaranPage( // Perbarui konstruktor
                idPembayaran: idPembayaran,
                totalPembayaran: widget.product.hargaProduk,
                idPemesanan: idPemesanan, // <--- TERUSKAN ID PEMESANAN
              ),
            ),
          );
        } else { // Jika metode Tunai
          Navigator.of(context).popUntil((route) => route.isFirst);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainPage(initialPageIndex: 1)
            )
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuat pesanan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error creating order: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final String formattedHarga = formatter.format(product.hargaProduk);

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
                  // Metode Pembayaran
                  const Text(
                    "Metode",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedMetodePembayaran == "QRIS"
                              ? Icons.qr_code
                              : Icons.money,
                          size: 28,
                          color: const Color(0xFF001F3F),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedMetodePembayaran,
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Pilih Metode Pembayaran"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      ListTile(
                                        title: const Text("QRIS"),
                                        leading: Radio<String>(
                                          value: "QRIS",
                                          groupValue: _selectedMetodePembayaran,
                                          onChanged: (String? value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedMetodePembayaran = value;
                                              });
                                              Navigator.pop(dialogContext);
                                            }
                                          },
                                        ),
                                      ),
                                      ListTile(
                                        title: const Text("Tunai"),
                                        leading: Radio<String>(
                                          value: "Tunai",
                                          groupValue: _selectedMetodePembayaran,
                                          onChanged: (String? value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedMetodePembayaran = value;
                                              });
                                              Navigator.pop(dialogContext);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFF00BCD4),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Ubah",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Detail Harga
                  const Text(
                    "Detail Harga",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.namaKendaraan,
                              style: const TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "x1",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "$formattedHarga",
                              style: const TextStyle(
                                fontFamily: 'Sora',
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Pembayaran",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "$formattedHarga",
                              style: const TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tata Cara Pembayaran (Dinamic based on selection)
                  const Text(
                    "Lihat tata cara pembayaran",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: _selectedMetodePembayaran == "QRIS"
                        ? const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1. Pilih metode \"QRIS\" saat memesan rental.",
                                style: TextStyle(fontFamily: 'Sora', fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "2. Scan QR Code yang ditampilkan oleh aplikasi.",
                                style: TextStyle(fontFamily: 'Sora', fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "3. Bayar sesuai total biaya sewa.",
                                style: TextStyle(fontFamily: 'Sora', fontSize: 14),
                              ),
                            ],
                          )
                        : const Column( // Instruksi Tunai
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1. Lakukan pembayaran secara tunai saat pengambilan kendaraan.",
                                style: TextStyle(fontFamily: 'Sora', fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "2. Pastikan jumlah pembayaran sesuai dengan total biaya sewa.",
                                style: TextStyle(fontFamily: 'Sora', fontSize: 14),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
            // Tombol "PESAN SEKARANG" di bagian bawah (tetap di sini)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
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
                onPressed: _isProcessingOrder ? null : _handlePesanSekarang,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BCD4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: _isProcessingOrder
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "PESAN SEKARANG",
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
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