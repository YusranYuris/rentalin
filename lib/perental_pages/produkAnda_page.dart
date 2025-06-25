import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // Import untuk Uint8List
import 'dart:convert';

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
      gambarProduk: null,
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
        print('DEBUG ProdukAnda: User tidak terautentikasi.');
        throw Exception('User tidak terautentikasi');
      }
      print('DEBUG ProdukAnda: Current User ID: ${currentUser.id}');

      final response = await Supabase.instance.client
          .from('produk')
          .select('*, rental(nama_rental)')
          .eq('id_user', currentUser.id)
          .order('nama_kendaraan', ascending: true);

      print('DEBUG ProdukAnda: Raw Supabase Response: $response'); 

      if (response.isEmpty) {
        print('DEBUG ProdukAnda: Tidak ada data produk ditemukan untuk user ${currentUser.id}.');
        return [];
      }

      List<Product> products = [];
      for (var item in response) {
        String? rentalName;
        if (item['rental'] != null && item['rental'] is Map) {
          rentalName = item['rental']['nama_rental'] as String?;
        }
        
        Uint8List? gambarBytes;
        if (item['gambar_produk'] != null && item['gambar_produk'] is String) {
          String hexString = item['gambar_produk'] as String;
          if (hexString.startsWith('\\x')) {
            hexString = hexString.substring(2); // Hapus prefix \x
          }

          try {
            // Langkah 1: Konversi string heksadesimal ke ASCII string
            List<int> asciiCodeUnits = [];
            for (int i = 0; i < hexString.length; i += 2) {
              String hexPair = hexString.substring(i, i + 2);
              int byte = int.parse(hexPair, radix: 16);
              asciiCodeUnits.add(byte);
            }
            String rawListString = utf8.decode(asciiCodeUnits); // Ini akan menghasilkan string seperti "[255,216,255,...]"

            // Langkah 2: Parse rawListString menjadi List<int>
            if (rawListString.startsWith('[') && rawListString.endsWith(']')) {
              rawListString = rawListString.substring(1, rawListString.length - 1); // Hapus [ dan ]
            }
            List<int> byteList = rawListString.split(',')
                .map((s) => int.tryParse(s.trim()) ?? 0) // Parse setiap angka, default ke 0 jika gagal
                .toList();
            
            gambarBytes = Uint8List.fromList(byteList);

          } catch (e) {
            print('DEBUG ProdukAnda: Error converting complex image string: $e');
            gambarBytes = null;
          }
        }

        products.add(Product(
          idProduk: item['id_produk'],
          idUser: item['id_user'],
          idRental: item['id_rental'],
          hargaProduk: item['harga_produk'],
          deskripsiProduk: item['deskripsi_produk'],
          gambarProduk: gambarBytes,
          transaksi: item['transaksi'],
          statusProduk: item['status_produk'],
          namaKendaraan: item['nama_kendaraan'],
          namaRental: rentalName,
        ));
      }
      print('DEBUG ProdukAnda: Fetched ${products.length} products.'); 
      return products;
    } catch (e) {
      print('DEBUG ProdukAnda: Error fetching products: $e'); 
      // Re-throw exception agar FutureBuilder dapat menangkap dan menampilkan error
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
                          deskripsi: product.deskripsiProduk,
                          statusProduk: product.statusProduk,
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
    required String deskripsi,
    required String statusProduk,
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
                  // Bagian rating dihapus sesuai permintaan
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
                    deskripsi, // Ini akan menampilkan deskripsi produk
                    style: const TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w300,
                        fontSize: 8,
                        color: Colors.black),
                  ),
                  Text(
                    statusProduk, // Ini akan menampilkan status produk
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
                    color: Colors.white,
                  ),
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
                  border: Border.all(color: const Color(0xFF00BCD4), width: 1.2),
                ),
                child: Text(
                  statusProduk, // Menampilkan status produk
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