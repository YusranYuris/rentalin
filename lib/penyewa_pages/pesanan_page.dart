import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // Untuk Uint8List
import 'dart:convert'; // Untuk utf8.decode
import 'package:intl/intl.dart';

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
    final Map<String, dynamic> produkData = data['produk'];
    final Map<String, dynamic> rentalData = produkData['rental'];

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
      namaKendaraan: produkData['nama_kendaraan'],
      hargaProduk: produkData['harga_produk'],
      deskripsiProduk: produkData['deskripsi_produk'],
      gambarProduk: gambarBytes,
      namaRental: rentalData['nama_rental'],
      lokasiRental: rentalData['lokasi_rental'],
    );
  }
}

// --- Kelas Widget OrderItemCard (mengganti LaporanRentalItemCard) ---
class OrderItemCard extends StatelessWidget {
  final OrderItem item;

  const OrderItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)), // Sudut membulat
            boxShadow: [ // Efek shadow
              BoxShadow(
                color: Colors.grey, // <--- SEHARUSNYA TIDAK MERAH
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
                    Container(
                      width: 111,
                      height: 23,
                      decoration: BoxDecoration(
                        gradient: (item.statusPemesanan == "Belum Bayar")
                            ? LinearGradient( // Hapus const di sini karena colors dinamis
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFDC143C), // Merah untuk Belum Bayar
                                  Colors.black.withOpacity(0.5), // <--- PERBAIKAN WARNA
                                ],
                              )
                            : (item.statusPemesanan == "Sudah Bayar")
                                ? LinearGradient( // Hapus const di sini
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFFFA500), // Oranye untuk Sudah Bayar
                                      Colors.black.withOpacity(0.5), // <--- PERBAIKAN WARNA
                                    ],
                                  )
                                : const LinearGradient( // Selesai (tetap const jika warnanya fixed)
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
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity, // Mengisi lebar penuh
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
                          "$formattedHarga",
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
                    // Tombol "Ulas" dihapus
                    if (item.statusPemesanan == "Selesai") // Tampilkan tombol "Rental Lagi" hanya jika status "Selesai"
                      Container(
                        width: 72,
                        height: 23,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF00BCD4),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(4), // Sudut membulat
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Rental Lagi",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Color(0xFF0F6D79),
                            ),
                          ),
                        ),
                      ),
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

// --- Kelas PesananPage Utama ---
class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final supabase = Supabase.instance.client;
  late Future<List<OrderItem>> _ordersFuture;
  String _selectedFilter = "Semua Status"; // Default filter

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  // Fungsi untuk me-refresh daftar pesanan
  void _refreshOrders() {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  Future<List<OrderItem>> _fetchOrders() async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi.');
      }

      // Mulai kueri, ambil semua pesanan untuk user saat ini
      var query = supabase.from('pemesanan')
          .select('*, produk(*, rental(*))') // Select dan Join
          .eq('id_user', currentUser.id) // Filter id_user
          .order('tanggal_pemesanan', ascending: false); // Urutkan

      // Jalankan kueri dan dapatkan semua data yang cocok
      // Kita tidak lagi menggunakan '.eq()' di sini untuk filter status
      final List<Map<String, dynamic>>? allOrdersRaw = await query;
      
      // Periksa apakah data null atau kosong
      if (allOrdersRaw == null || allOrdersRaw.isEmpty) {
        print('DEBUG PesananPage: Raw Supabase Response (no data): $allOrdersRaw');
        return [];
      }

      // Konversi data mentah menjadi List<OrderItem>
      List<OrderItem> allOrders = allOrdersRaw.map((data) => OrderItem.fromSupabase(data)).toList();
      
      print('DEBUG PesananPage: Raw Supabase Response (all): $allOrdersRaw');

      // Lakukan filter berdasarkan status secara lokal di Dart
      if (_selectedFilter != "Semua Status") {
        allOrders = allOrders.where((order) => order.statusPemesanan == _selectedFilter).toList();
        print('DEBUG PesananPage: Filtered orders by $_selectedFilter: ${allOrders.length} items');
      }

      return allOrders;
    } catch (e) {
      print('DEBUG PesananPage: Error fetching orders: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pesanan Saya",
          style: TextStyle(
            fontFamily: 'Coolvetica',
            fontWeight: FontWeight.w400,
            fontSize: 28,
            color: Color(0xFF001F3F),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFE5ECF0),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 17.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF00BCD4),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  icon: const Icon(Icons.arrow_drop_down_outlined, color: Color(0xFF0F6D79)),
                  style: const TextStyle(
                    fontFamily: 'Sora',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: Color(0xFF0F6D79),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFilter = newValue;
                        _ordersFuture = _fetchOrders(); // Muat ulang data setelah filter berubah
                      });
                    }
                  },
                  items: <String>["Semua Status", "Belum Bayar", "Sudah Bayar", "Selesai"]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 17.0, right: 17, top: 10),
          child: FutureBuilder<List<OrderItem>>(
            future: _ordersFuture,
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
                    'Belum ada pesanan.',
                    style: TextStyle(color: Colors.black),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return OrderItemCard(item: item);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}