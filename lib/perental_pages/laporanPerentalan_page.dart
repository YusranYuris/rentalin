import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // Untuk Uint8List
import 'dart:convert'; // Untuk utf8.decode
import 'package:intl/intl.dart'; // Untuk formatting angka

// Import OrderItem model dari pesanan_page.dart
// PASTIKAN MODEL INI SAMA DENGAN YANG ADA DI pesanan_page.dart
import 'package:rentalin_project/penyewa_pages/pesanan_page.dart'; // OrderItem model ada di sini

// --- Model Data Baru untuk Item Pesanan ---
class OrderItem {
  final String idPemesanan;
  final String? idProduk;
  final String? idUser;
  final String tanggalPemesanan;
  final String statusPemesanan;
  
  // Data dari tabel produk
  final String namaKendaraan;
  final int hargaProduk;
  final String deskripsiProduk;
  final Uint8List? gambarProduk;

  // Data dari tabel rental (melalui produk)
  final String namaRental;
  final String lokasiRental;

  OrderItem({
    required this.idPemesanan,
    this.idProduk,
    this.idUser,
    required this.tanggalPemesanan,
    required this.statusPemesanan,
    required this.namaKendaraan,
    required this.hargaProduk,
    required this.deskripsiProduk,
    required this.gambarProduk,
    required this.namaRental,
    required this.lokasiRental,
  });

  // Factory method untuk membuat OrderItem dari data Supabase join
  factory OrderItem.fromSupabase(Map<String, dynamic> data) {
    // --- PERBAIKAN DI SINI: Tangani null untuk 'produk' dan 'rental' ---
    final Map<String, dynamic> produkData = data['produk'] as Map<String, dynamic>? ?? {};
    final Map<String, dynamic> rentalData = produkData['rental'] as Map<String, dynamic>? ?? {};

    Uint8List? gambarBytes;
    if (produkData['gambar_produk'] != null && produkData['gambar_produk'] is String) {
      String hexString = produkData['gambar_produk'] as String;
      if (hexString.startsWith('\\x')) {
        hexString = hexString.substring(2);
      }
      try {
        List<int> asciiCodeUnits = [];
        for (int i = 0; i < hexString.length; i += 2) {
          String hexPair = hexString.substring(i, i + 2);
          int byte = int.parse(hexPair, radix: 16);
          asciiCodeUnits.add(byte);
        }
        String rawListString = utf8.decode(asciiCodeUnits);
        if (rawListString.startsWith('[') && rawListString.endsWith(']')) {
          rawListString = rawListString.substring(1, rawListString.length - 1);
        }
        List<int> byteList = rawListString.split(',')
            .map((s) => int.tryParse(s.trim()) ?? 0)
            .toList();
        gambarBytes = Uint8List.fromList(byteList);
      } catch (e) {
        print('Error parsing image hex string for order item: $e');
        gambarBytes = null;
      }
    } else if (produkData['gambar_produk'] is List) {
      gambarBytes = Uint8List.fromList(List<int>.from(produkData['gambar_produk']));
    }

    return OrderItem(
      idPemesanan: data['id_pemesanan'],
      idProduk: data['id_produk'],
      idUser: data['id_user'],
      tanggalPemesanan: data['tanggal_pemesanan'],
      statusPemesanan: data['status_pemesanan'],
      // Gunakan null-aware operator dan fallback string jika data tidak ada
      namaKendaraan: produkData['nama_kendaraan'] ?? 'Tidak Diketahui',
      hargaProduk: produkData['harga_produk'] ?? 0, // Harga default 0 jika null
      deskripsiProduk: produkData['deskripsi_produk'] ?? 'Tidak Ada Deskripsi',
      gambarProduk: gambarBytes,
      namaRental: rentalData['nama_rental'] ?? 'Rental Tidak Diketahui',
      lokasiRental: rentalData['lokasi_rental'] ?? 'Lokasi Tidak Diketahui',
    );
  }
}

// --- Kelas Widget RentalOrderItemCard (menggantikan LaporanRentalItemCard) ---
class RentalOrderItemCard extends StatelessWidget {
  final OrderItem item;
  final Function(String orderId, String newStatus) onStatusUpdate; // Callback untuk update status

  // Hapus 'const' dari konstruktor karena 'onStatusUpdate' tidak bisa const
  const RentalOrderItemCard({
    Key? key,
    required this.item,
    required this.onStatusUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Logika untuk menentukan status berikutnya
    String? nextStatus;
    if (item.statusPemesanan == "Belum Bayar") {
      nextStatus = "Sudah Bayar";
    } else if (item.statusPemesanan == "Sudah Bayar") {
      nextStatus = "Selesai";
    }

    // Format angka di sini untuk harga
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id', // Untuk format Indonesia (misal: Rp10.000)
      symbol: 'Rp',
      decimalDigits: 0, // Tidak ada angka di belakang koma
    );
    final String formattedHarga = formatter.format(item.hargaProduk);

    return Column(
      children: [
        Container(
          width: double.infinity, // Mengisi lebar penuh
          height: 142,
          decoration: BoxDecoration( // Hapus const karena BoxShadow
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)), // Sudut membulat
            boxShadow: [ // Efek shadow
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // <--- SEHARUSNYA TIDAK MERAH
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.motorcycle_outlined, // Icon umum untuk kendaraan
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.namaKendaraan, // Menggunakan nama kendaraan sebagai tipe
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          item.tanggalPemesanan,
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Color(0x60000000),
                          ),
                        )
                      ],
                    ),
                    const Spacer(), // Menggunakan Spacer untuk mendorong status ke kanan
                    GestureDetector(
                      onTap: nextStatus != null
                          ? () => onStatusUpdate(item.idPemesanan, nextStatus!)
                          : null,
                      child: Container(
                        width: 111,
                        height: 23,
                        decoration: BoxDecoration( // Hapus const karena gradient
                          gradient: (item.statusPemesanan == "Belum Bayar")
                              ? LinearGradient( // Hapus const di sini karena colors dinamis
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFDC143C), // Merah untuk Belum Bayar
                                    Colors.black.withOpacity(0.5),
                                  ],
                                )
                              : (item.statusPemesanan == "Sudah Bayar")
                                  ? LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFFFFA500), // Oranye untuk Sudah Bayar
                                        Colors.black.withOpacity(0.5),
                                      ],
                                    )
                                  : const LinearGradient( // Selesai
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF0F6D79),
                                        Color(0xFF00BCD4),
                                      ],
                                    ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.5),
                          child: Text(
                            textAlign: TextAlign.center,
                            item.statusPemesanan,
                            style: const TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB0BEC5),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: item.gambarProduk != null
                          ? Image.memory(
                              item.gambarProduk!,
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 30,
                              height: 30,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image, size: 20),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.namaKendaraan,
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          item.namaRental,
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                            color: Color(0x40000000),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Harga",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 8,
                            color: Color(0x40000000),
                          ),
                        ),
                        Text(
                          formattedHarga, // <--- Gunakan formattedHarga
                          style: const TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF000000),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    // Tombol "Rental Lagi" dihapus sepenuhnya
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 24)
      ],
    );
  }
}

// --- Kelas LaporanPerentalanPage Utama ---
class LaporanPerentalanPage extends StatefulWidget {
  const LaporanPerentalanPage({super.key});

  @override
  State<LaporanPerentalanPage> createState() => _LaporanPerentalanPageState();
}

class _LaporanPerentalanPageState extends State<LaporanPerentalanPage> {
  final supabase = Supabase.instance.client;
  late Future<List<OrderItem>> _rentalOrdersFuture;
  // String _selectedFilter = "Semua Status"; // Hapus state filter

  @override
  void initState() {
    super.initState();
    _rentalOrdersFuture = _fetchRentalOrders();
  }

  // Fungsi untuk me-refresh daftar pesanan
  void _refreshOrders() {
    setState(() {
      _rentalOrdersFuture = _fetchRentalOrders();
    });
  }

  // Fungsi untuk memperbarui status pesanan di database
  Future<void> _updateOrderStatus(String orderId, String newStatus) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi.');
      }

      // Perbarui tabel pemesanan
      await supabase
          .from('pemesanan')
          .update({'status_pemesanan': newStatus})
          .eq('id_pemesanan', orderId); // Gunakan .eq() di sini

      // Jika status berubah menjadi "Sudah Bayar" atau "Selesai", perbarui juga tanggal pembayaran di tabel pembayaran
      if (newStatus == "Sudah Bayar" || newStatus == "Selesai") {
        await supabase
            .from('pembayaran')
            .update({'status_pembayaran': newStatus, 'tanggal_pembayaran': DateTime.now().toIso8601String()})
            .eq('id_pemesanan', orderId); // Gunakan id_pemesanan
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status pesanan diperbarui menjadi: $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        _refreshOrders(); // Refresh daftar setelah update
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui status pesanan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Error updating order status: $e');
    }
  }

  Future<List<OrderItem>> _fetchRentalOrders() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi.');
      }

      // Dapatkan id_rental dari user yang login
      // Ini mengembalikan single Map<String, dynamic>
      final Map<String, dynamic>? rentalData = await supabase
          .from('rental')
          .select('id_rental')
          .eq('id_user', currentUser.id)
          .single();

      if (rentalData == null || rentalData.isEmpty) {
        print('DEBUG LaporanPerentalan: User ini bukan penyedia rental.');
        return [];
      }
      final String idRentalCurrentUser = rentalData['id_rental'];

      // Ambil semua pesanan yang terkait dengan produk dari rental ini
      // Menghilangkan .eq() untuk status_pemesanan dari kueri Supabase
      var query = supabase
          .from('pemesanan')
          .select('*, produk(*, rental(*))')
          .eq('produk.id_rental', idRentalCurrentUser) // Filter berdasarkan id_rental produk
          .order('tanggal_pemesanan', ascending: false);

      // Jalankan kueri dan dapatkan semua data
      final List<Map<String, dynamic>>? responseDataRaw = await query;
      
      if (responseDataRaw == null || responseDataRaw.isEmpty) {
        print('DEBUG LaporanPerentalan: Raw Supabase Response (no data): $responseDataRaw');
        return [];
      }

      // Konversi data mentah menjadi List<OrderItem>
      List<OrderItem> allOrders = responseDataRaw.map((data) => OrderItem.fromSupabase(data)).toList();
      
      print('DEBUG LaporanPerentalan: Raw Supabase Response (all): $responseDataRaw');

      // Tidak ada filter lokal untuk status di sini karena dropdown dihapus
      // Jika Anda hanya ingin menampilkan SEMUA, maka bagian ini tidak perlu filter lokal.
      // Jika ada filter default di UI, itu akan tetap diaktifkan.

      return allOrders; // Mengembalikan semua pesanan yang terkait dengan rental ini
    } catch (e) {
      print('DEBUG LaporanPerentalan: Error fetching rental orders: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient( // <--- KEMBALIKAN GRADIENT BACKGROUND
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xFF064C55),
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17, top: 10),
            child: FutureBuilder<List<OrderItem>>(
              future: _rentalOrdersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada laporan perentalan.',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return RentalOrderItemCard(
                        item: item,
                        onStatusUpdate: _updateOrderStatus,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}