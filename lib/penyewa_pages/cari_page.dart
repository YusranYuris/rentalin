import 'package:flutter/material.dart';
import 'package:rentalin_project/penyewa_pages/detailProduk_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:convert'; 
import 'package:intl/intl.dart';

// Import Product model dari produkAnda_page.dart
// PASTIKAN MODEL INI SAMA DENGAN YANG ADA DI PRODUKANDA_PAGE.DART
import 'package:rentalin_project/perental_pages/produkAnda_page.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CariPage extends StatefulWidget {
  const CariPage({super.key});
  @override
  State<CariPage> createState() => _CariPageState();
}

// Mengadaptasi RentalItemCard untuk menampilkan Produk dari Rental Lain
class OtherRentalProductCard extends StatelessWidget {
  final Product product;

  const OtherRentalProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final String formattedHarga = formatter.format(product.hargaProduk);
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman DetailProdukPage dan teruskan objek produk
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailProdukPage(product: product),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 434, // Tinggi tetap untuk kartu
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // Membuat sudut lebih membulat
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Efek shadow yang lebih halus
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Posisi shadow
            ),
          ],
        ),
        child: Column( // Column utama dalam kartu
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding( // Padding di sekitar gambar
              padding: const EdgeInsets.all(8.0),
              child: Expanded( // Membuat gambar mengisi bagian atas secara proporsional
                child: AspectRatio( // <--- Tambahkan Widget AspectRatio
                  aspectRatio: 1.0, // Rasio 1:1 untuk kotak
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4), // Sudut membulat untuk gambar
                    child: product.gambarProduk != null
                        ? Image.memory(
                            product.gambarProduk!,
                            width: double.infinity,
                            height: double.infinity, // Memastikan gambar mengisi Expanded
                            fit: BoxFit.cover, // Memastikan gambar memenuhi ruang
                          )
                        : Container(
                            width: double.infinity,
                            height: double.infinity, // Memastikan placeholder mengisi Expanded
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // Penting agar Column ini tidak mencoba mengambil ruang tak terbatas
                    children: [
                      Text(
                        product.namaRental ?? 'Rental Tidak Diketahui',
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.namaKendaraan,
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 0), // <--- UBAH DARI height: 8 MENJADI 6
                      Text(
                        product.lokasiRental ?? 'Lokasi Tidak Diketahui',
                        style: const TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ), // Spasi antara nama rental dan harga
                  Text(
                    "$formattedHarga/hari",
                    style: const TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black87,
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

class _CariPageState extends State<CariPage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchOtherRentalsProducts();
  }

  Future<List<Product>> _fetchOtherRentalsProducts() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        print('DEBUG CariPage: User not authenticated.');
        throw Exception('User tidak terautentikasi.');
      }
      print('DEBUG CariPage: Current User ID: ${currentUser.id}');

      final response = await Supabase.instance.client
          .from('produk')
          .select('*, rental(nama_rental, lokasi_rental)')
          .not('id_user', 'eq', currentUser.id)
          .order('nama_kendaraan', ascending: true);

      print('DEBUG CariPage: Raw Supabase Response: $response');

      if (response.isEmpty) {
        print('DEBUG CariPage: Tidak ada produk dari rental lain ditemukan.');
        return [];
      }

      List<Product> products = [];
      for (var item in response) {
        String? rentalName;
        String? lokasiRental;
        if (item['rental'] != null && item['rental'] is Map) {
          rentalName = item['rental']['nama_rental'] as String?;
          lokasiRental = item['rental']['lokasi_rental'] as String?;
        }

        Uint8List? gambarBytes;
        if (item['gambar_produk'] != null && item['gambar_produk'] is String) {
          String hexString = item['gambar_produk'] as String;
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
            print('DEBUG CariPage: Error converting image string: $e');
            gambarBytes = null;
          }
        } else if (item['gambar_produk'] is List) {
          gambarBytes = Uint8List.fromList(List<int>.from(item['gambar_produk']));
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
          lokasiRental: lokasiRental,
        ));
      }
      return products;
    } catch (e) {
      print('DEBUG CariPage: Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        child: Drawer(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Jarak",
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 237,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          decoration: InputDecoration(
                            hintText: "MAKS",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Harga",
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 237,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          decoration: InputDecoration(
                            hintText: "MIN",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 237,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: Colors.white
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          decoration: InputDecoration(
                            hintText: "MAKS",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE5ECF0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5ECF0),
        titleSpacing: 30,
        title: const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            "Rentalin",
            style: TextStyle(
              fontFamily: "Coolvetica",
              fontWeight: FontWeight.w400,
              fontSize: 28,
              color: Color(0xFF001F3F),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 10, right: 14.0),
            child: Icon(
              Icons.doorbell_outlined,
              size: 40,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 5,
              color: const Color(0xFFDDDDDD),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "#RentalinAja",
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w700,
                      fontSize: 27.47,
                      color: Color(0xFF000000)
                    ),
                  ),
                  const SizedBox(height: 0),
                  const Text(
                    "Cari & Sewa Kendaraan Murah",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.25,
                      color: Color(0xFF000000)
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 308,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                            Color(0xFF001F3F),
                            Color(0xFF0F6D79),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(
                            color: Color(0x50000000),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, 0)
                          )]
                        ),
                        child: const TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.white
                              ),
                            ),
                            hintText: "Mau Kemana",
                            hintStyle: TextStyle(
                              color: Colors.white
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 48,
                        height: 51,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F6D79),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [BoxShadow(
                            color: Color(0x50000000),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, 0)
                          )]
                        ),
                        child: IconButton(
                          onPressed: (){
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                          icon: const Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: 30,
                          )
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Terdekat",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                child: FutureBuilder<List<Product>>(
                  future: _productsFuture,
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
                          'Tidak ada kendaraan dari rental lain yang tersedia.',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final product = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: OtherRentalProductCard(product: product),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}