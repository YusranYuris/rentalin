import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:math'; // Pastikan uuid digunakan di suatu tempat atau hapus jika tidak diperlukan lagi
import 'package:rentalin_project/perental_pages/produkAnda_page.dart'; // Import Product model

class EditProdukPage extends StatefulWidget {
  final Product product; // Menerima objek produk yang akan diedit

  const EditProdukPage({super.key, required this.product});

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final TextEditingController _namaKendaraanController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final TextEditingController _deskripsiProdukController = TextEditingController();

  File? _pickedImage; // Untuk gambar baru yang dipilih dari galeri
  Uint8List? _currentImageBytes; // Untuk menyimpan byte gambar yang ada dari database

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data produk yang ada
    _namaKendaraanController.text = widget.product.namaKendaraan;
    _hargaProdukController.text = widget.product.hargaProduk.toString();
    _deskripsiProdukController.text = widget.product.deskripsiProduk;

    // Simpan byte gambar yang ada
    _currentImageBytes = widget.product.gambarProduk;

    // Tambahkan listener untuk memicu rebuild saat teks berubah
    _namaKendaraanController.addListener(_updateState);
    _hargaProdukController.addListener(_updateState);
    _deskripsiProdukController.addListener(_updateState);
  }

  @override
  void dispose() {
    _namaKendaraanController.removeListener(_updateState);
    _hargaProdukController.removeListener(_updateState);
    _deskripsiProdukController.removeListener(_updateState);
    _namaKendaraanController.dispose();
    _hargaProdukController.dispose();
    _deskripsiProdukController.dispose();
    super.dispose();
  }

  // Pemicu rebuild untuk tombol "Simpan Perubahan"
  void _updateState() {
    setState(() {});
  }

  bool get _formIsValid {
    // Form valid jika ada gambar (baik yang sudah ada atau yang baru dipilih)
    // dan semua field teks tidak kosong.
    return (_pickedImage != null || _currentImageBytes != null) &&
           _namaKendaraanController.text.trim().isNotEmpty &&
           _hargaProdukController.text.trim().isNotEmpty &&
           _deskripsiProdukController.text.trim().isNotEmpty;
  }

  Future<void> _unggahGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _currentImageBytes = null; // Hapus byte gambar lama jika ada gambar baru
      });
    }
  }

  Future<void> _updateProduk() async {
    if (!_formIsValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      final namaKendaraan = _namaKendaraanController.text.trim();
      // Pastikan harga diparsing tanpa titik
      final hargaProduk = int.parse(_hargaProdukController.text.trim().replaceAll('.', ''));
      final deskripsiProduk = _deskripsiProdukController.text.trim();
      
      Uint8List? finalGambarBytes;
      if (_pickedImage != null) {
        finalGambarBytes = await _pickedImage!.readAsBytes();
      } else {
        finalGambarBytes = _currentImageBytes; // Gunakan gambar yang sudah ada jika tidak ada yang baru dipilih
      }

      await Supabase.instance.client
          .from('produk')
          .update({
            'nama_kendaraan': namaKendaraan,
            'harga_produk': hargaProduk,
            'deskripsi_produk': deskripsiProduk,
            'gambar_produk': finalGambarBytes, // Menggunakan byte array
          })
          .eq('id_produk', widget.product.idProduk); // Update berdasarkan id_produk

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produk berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Kembali ke halaman sebelumnya dan kirim sinyal berhasil
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui produk: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE5ECF0),
        title: Text('Edit Produk'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 19, right: 19, top: 10, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Detail Kendaraan",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w700,
                  fontSize: 27.47,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 9),

              // Unggah Gambar
              Text(
                "Unggah Gambar",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 9),
              GestureDetector(
                onTap: _unggahGambar,
                child: Container(
                  width: 365,
                  height: 365,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF001F3F),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : (_currentImageBytes != null
                            ? DecorationImage(
                                image: MemoryImage(_currentImageBytes!),
                                fit: BoxFit.cover,
                              )
                            : null), // Menampilkan gambar lama jika ada
                  ),
                  child: (_pickedImage == null && _currentImageBytes == null)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 43,
                              color: Color(0xFF9B9B9B),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Unggah Gambar Kendaraanmu",
                              style: TextStyle(
                                fontFamily: "Sora",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFF9B9B9B),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          children: [
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pickedImage = null;
                                    _currentImageBytes = null; // Juga hapus gambar lama jika pengguna ingin menghapusnya
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 9),
              Text(
                "Pastikan gambar yang Anda unggah sesuai dengan identitas resmi kendaraan anda",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B8490),
                ),
              ),
              SizedBox(height: 15),

              // Nama Kendaraan
              Text(
                "Nama Kendaraan",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _namaKendaraanController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF001F3F),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF0F6D79),
                            width: 1.5,
                          ),
                        ),
                        labelText: "Nama Kendaraan",
                        labelStyle: TextStyle(
                          color: Color(0xFF6B8490),
                          fontSize: 12,
                          fontFamily: "Sora",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9),
              Text(
                "Nama kendaraan lebih baik diisi lengkap dengan keterangan seri, cc, dan tahun keluaran",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B8490),
                ),
              ),
              SizedBox(height: 15),

              // Harga Produk
              Text(
                "Harga Kendaraan",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _hargaProdukController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF001F3F),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF0F6D79),
                            width: 1.5,
                          ),
                        ),
                        labelText: "Harga",
                        labelStyle: TextStyle(
                          color: Color(0xFF6B8490),
                          fontSize: 12,
                          fontFamily: "Sora",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9),
              Text(
                "Masukan harga yang pas",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B8490),
                ),
              ),
              SizedBox(height: 15),

              // Deskripsi Produk
              Text(
                "Deskripsi Produk",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 9),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _deskripsiProdukController,
                      maxLines: 3, // Izinkan multi-baris untuk deskripsi
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF001F3F),
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                          borderSide: BorderSide(
                            color: Color(0xFF0F6D79),
                            width: 1.5,
                          ),
                        ),
                        labelText: "Deskripsi",
                        labelStyle: TextStyle(
                          color: Color(0xFF6B8490),
                          fontSize: 12,
                          fontFamily: "Sora",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 9),
              Text(
                "Di sini Anda bisa mencantumkan spesifikasi dan syarat khusus untuk kendaraan Anda",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B8490),
                ),
              ),
              SizedBox(height: 25),

              // Tombol Simpan Perubahan
              GestureDetector(
                onTap: _isLoading ? null : (_formIsValid ? _updateProduk : null),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: _formIsValid
                        ? LinearGradient(
                            colors: [
                              Color(0xFF0F6D79),
                              Color(0xFF00BCD4),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: _formIsValid ? null : Color(0x20000000),
                  ),
                  child: Center(
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Simpan Perubahan",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: _formIsValid ? Colors.white : Color(0x20000000),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}