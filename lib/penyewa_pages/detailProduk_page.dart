import 'package:flutter/material.dart';
// Tambahkan import ini untuk model Product
import 'package:rentalin_project/perental_pages/produkAnda_page.dart';

class DetailProdukPage extends StatefulWidget {
  final Product product;

  const DetailProdukPage({super.key, required this.product});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {

  @override
  Widget build(BuildContext context) {
    final Product currentProduct = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            // Gunakan currentProduct.namaKendaraan dari widget
            currentProduct.namaKendaraan,
            style: const TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFE5ECF0),
        // automaticallyImplyLeading: false, // Biasanya halaman detail ada tombol kembali, bisa diaktifkan
      ),
      body: Container(
        color: const Color(0xFFE5ECF0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Detail Produk Page",
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Nama Rental: ${currentProduct.namaRental ?? 'Tidak Diketahui'}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  'Lokasi Rental: ${currentProduct.lokasiRental ?? 'Tidak Diketahui'}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  'Kendaraan: ${currentProduct.namaKendaraan}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  'Harga: Rp${currentProduct.hargaProduk}/hari',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                Text(
                  'Deskripsi: ${currentProduct.deskripsiProduk}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                // Tambahkan gambar produk jika ada
                if (currentProduct.gambarProduk != null) ...[
                  const SizedBox(height: 20),
                  Image.memory(
                    currentProduct.gambarProduk!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}