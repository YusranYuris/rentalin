import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // Import untuk Uint8List

// Model data sederhana untuk produk
class Product {
  final String idProduk;
  final String? idUser;
  final String? idRental;
  final int hargaProduk;
  final String deskripsiProduk;
  final Uint8List? gambarProduk;
  final int transaksi;
  final String statusProduk;
  final String namaKendaraan;
  final String? namaRental; // Tambahkan namaRental

  Product({
    required this.idProduk,
    this.idUser,
    this.idRental,
    required this.hargaProduk,
    required this.deskripsiProduk,
    required this.gambarProduk,
    required this.transaksi,
    required this.statusProduk,
    required this.namaKendaraan,
    this.namaRental,
  });

  factory Product.fromJson(Map<String, dynamic> json, String? rentalName) {
    return Product(
      idProduk: json['id_produk'],
      idUser: json['id_user'],
      idRental: json['id_rental'],
      hargaProduk: json['harga_produk'],
      deskripsiProduk: json['deskripsi_produk'],
      gambarProduk: json['gambar_produk'] != null
          ? Uint8List.fromList(List<int>.from(json['gambar_produk']))
          : null,
      transaksi: json['transaksi'],
      statusProduk: json['status_produk'],
      namaKendaraan: json['nama_kendaraan'],
      namaRental: rentalName,
    );
  }
}

class ProdukAndaPage extends StatefulWidget {
  const ProdukAndaPage({super.key});

  @override
  State<ProdukAndaPage> createState() => _ProdukAndaPageState();
}

class _ProdukAndaPageState extends State<ProdukAndaPage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProdukData();
  }

  Future<List<Product>> _fetchProdukData() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        print('DEBUG: User not authenticated');
        throw Exception('User tidak terautentikasi');
      }
      print('DEBUG: Current User ID: ${currentUser.id}');

      // Ambil produk berdasarkan id_user yang sedang login
      // Lakukan join dengan tabel rental untuk mendapatkan nama_rental
      final response = await Supabase.instance.client
          .from('produk')
          .select('*, rental(nama_rental)') // Pilih semua kolom produk dan nama_rental dari tabel rental
          .eq('id_user', currentUser.id)
          .order('nama_kendaraan', ascending: true); // Urutkan berdasarkan nama kendaraan
      
      print('DEBUG: Supabase Response: $response');

      if (response == null || response.isEmpty) {
        print('DEBUG: No product data found for user ${currentUser.id}.');
        return []; // Mengembalikan daftar kosong jika tidak ada data
      }

      List<Product> products = [];
      for (var item in response) {
        String? rentalName;
        if (item['rental'] != null && item['rental'] is Map) {
          rentalName = item['rental']['nama_rental'] as String?;
        }

        Uint8List? gambarBytes;
        if (item['gambar_produk'] != null) {
          try {
            // Supabase BYTEA biasanya berupa array integer
            gambarBytes = Uint8List.fromList(List<int>.from(item['gambar_produk']));
          } catch (e) {
            print('DEBUG: Error converting image bytes: $e');
            gambarBytes = null; // Set null jika konversi gagal
          }
        }

        products.add(Product(
          idProduk: item['id_produk'],
          idUser: item['id_user'],
          idRental: item['id_rental'],
          hargaProduk: item['harga_produk'],
          deskripsiProduk: item['deskripsi_produk'],
          gambarProduk: gambarBytes, // Gunakan gambarBytes yang sudah diproses
          transaksi: item['transaksi'],
          statusProduk: item['status_produk'],
          namaKendaraan: item['nama_kendaraan'],
          namaRental: rentalName,
        ));
      }
      print('DEBUG: Fetched ${products.length} products.');
      return products;
    } catch (e) {
      print('DEBUG: Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
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
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 25),
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'Belum ada produk yang ditambahkan.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _stokRental(
                          gambarProduk: product.gambarProduk,
                          namaRental: product.namaRental ?? 'Nama Rental Tidak Diketahui',
                          motor: product.namaKendaraan,
                          jarak: product.deskripsiProduk, // Menggunakan deskripsi sebagai jarak untuk sementara
                          terdekat: product.statusProduk, // Menggunakan status sebagai terdekat untuk sementara
                          harga: product.hargaProduk.toString(),
                        ),
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

// Widget _stokRental diubah untuk menerima Uint8List untuk gambar
Widget _stokRental(
    {Uint8List? gambarProduk,
    required String namaRental,
    required String motor,
    required String jarak,
    required String terdekat,
    required String harga}) {
  return Container(
    width: double.infinity,
    height: 289,
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: gambarProduk != null
                ? Image.memory(
                    gambarProduk,
                    width: 330,
                    height: 201,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 330,
                    height: 201,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                namaRental,
                style: const TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.black),
              ),
              const Spacer(), // Menggunakan Spacer untuk mendorong elemen ke kanan
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.price_change,
                        color: Colors.black,
                        size: 13,
                      ),
                      Text(
                        "Rp$harga/hari",
                        style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            fontSize: 8,
                            color: Colors.black),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motor,
                    style: const TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w300,
                        fontSize: 8,
                        color: Colors.black),
                  ),
                  Text(
                    jarak, // Ini akan menampilkan deskripsi produk
                    style: const TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w300,
                        fontSize: 8,
                        color: Colors.black),
                  ),
                  Text(
                    terdekat, // Ini akan menampilkan status produk
                    style: const TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w300,
                        fontSize: 8,
                        color: Colors.black),
                  ),
                ],
              ),
              const Spacer(), // Menggunakan Spacer untuk mendorong tombol ke kanan
              Container(
                width: 49,
                height: 23,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.64),
                  color: const Color(0xFF001F3F),
                ),
                child: const Text(
                  "Edit",
                  style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Colors.white),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 72,
                height: 23,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1.64),
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(color: const Color(0xFF00BCD4), width: 1.2)),
                child: Text(
                  terdekat, // Menampilkan status produk
                  style: const TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: Color(0xFF0F6D79)),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}