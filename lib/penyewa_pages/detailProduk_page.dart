import 'package:flutter/material.dart';
import 'package:rentalin_project/penyewa_pages/pemesanan_page.dart';
import 'package:rentalin_project/perental_pages/produkAnda_page.dart'; // Import Product model

class DetailProdukPage extends StatefulWidget {
  final Product product;

  const DetailProdukPage({super.key, required this.product});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {
  @override
  Widget build(BuildContext context) {
    final Product currentProduct = widget.product; // Mengakses objek produk

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar( // AppBar bisa ditaruh di sini, tidak perlu extendBodyBehindAppBar
        title: Text(
          "Detail Produk", // Judul AppBar sesuai nama kendaraan
          style: const TextStyle(
            fontFamily: 'Sora',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Color(0xFF001F3F),
          ),
        ),
        backgroundColor: const Color(0xFFE5ECF0),
        iconTheme: const IconThemeData(color: Color(0xFF001F3F)), // Warna icon back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        child: SafeArea(
          child: ListView( // Gunakan ListView untuk konten yang bisa di-scroll
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Produk dari Database
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Sudut membulat untuk gambar
                        child: currentProduct.gambarProduk != null
                            ? Image.memory(
                                currentProduct.gambarProduk!,
                                width: MediaQuery.of(context).size.width, // <--- UBAH DI SINI: Atur lebar sesuai lebar layar
                                height: 346,
                                fit: BoxFit.cover,
                              )
                            : Container( // Placeholder jika gambar tidak ada
                                width: MediaQuery.of(context).size.width, // <--- UBAH DI SINI: Atur lebar sesuai lebar layar
                                height: 346,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.image_not_supported, size: 80, color: Colors.grey),
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Harga Produk
                        Text(
                          "Rp${currentProduct.hargaProduk}/hari",
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        // Nama Kendaraan
                        Text(
                          currentProduct.namaKendaraan,
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        // Nama Rental
                        Text(
                          currentProduct.namaRental ?? 'Rental Tidak Diketahui',
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black54,
                          ),
                        ),
                        // Lokasi Rental (tambahan, jika ingin ditampilkan)
                        Text(
                          currentProduct.lokasiRental ?? 'Lokasi Tidak Diketahui',
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Garis Pembatas
                        Container(
                          color: Colors.grey.shade300,
                          height: 1,
                          width: double.infinity, // Ini akan bekerja karena di dalam Padding dengan horizontal constraint
                        ),
                        const SizedBox(height: 10),
                        // Bagian Deskripsi
                        const Text(
                          "Deskripsi",
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          currentProduct.deskripsiProduk,
                          style: const TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tombol "Pesan Sekarang"
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Navigasi ke PemesananPage (sebelumnya PembayaranPage)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PemesananPage(product: currentProduct),
                                  ),
                                );
                              },
                              child: Container(
                                width: 363, // Tetap gunakan lebar fixed jika ini adalah lebar desain yang Anda inginkan
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF0F6D79),
                                      Color(0xFF00BCD4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Pesan Sekarang",
                                    style: TextStyle(
                                      fontFamily: "Sora",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}