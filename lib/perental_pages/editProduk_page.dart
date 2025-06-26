import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'dart:convert'; 
import 'package:rentalin_project/perental_pages/produkAnda_page.dart';

class EditProdukPage extends StatefulWidget {
  final Product product; // Menerima objek produk yang akan diedit

  const EditProdukPage({super.key, required this.product});

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final supabase = Supabase.instance.client;

  final TextEditingController _namaKendaraanController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final TextEditingController _deskripsiProdukController = TextEditingController();

  File? _pickedImage; // Untuk gambar baru yang dipilih dari galeri
  Uint8List? _currentImageBytes; // Untuk menyimpan byte gambar yang ada dari database
  
  bool _isSaving = false; // Status saving untuk proses update dan delete

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
    _namaKendaraanController.dispose();
    _hargaProdukController.dispose();
    _deskripsiProdukController.dispose();
    super.dispose();
  }

  // Pemicu rebuild untuk tombol "Simpan Perubahan" dan validasi
  void _updateState() {
    setState(() {});
  }

  bool get _formIsValid {
    // Form valid jika ada gambar (baik yang sudah ada atau yang baru dipilih)
    // dan semua field teks yang wajib tidak kosong.
    return (_pickedImage != null || _currentImageBytes != null) &&
           _namaKendaraanController.text.trim().isNotEmpty &&
           _hargaProdukController.text.trim().isNotEmpty &&
           _deskripsiProdukController.text.trim().isNotEmpty;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _currentImageBytes = null; // Hapus gambar lama jika ada gambar baru
      });
    }
  }

  Future<void> _updateProduk() async {
    if (!_formIsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon isi semua data yang wajib diisi.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi.');
      }

      final namaKendaraan = _namaKendaraanController.text.trim();
      final hargaProduk = int.parse(_hargaProdukController.text.trim().replaceAll('.', ''));
      final deskripsiProduk = _deskripsiProdukController.text.trim();
      
      Uint8List? finalGambarBytes;
      if (_pickedImage != null) {
        finalGambarBytes = await _pickedImage!.readAsBytes();
      } else {
        finalGambarBytes = _currentImageBytes; // Gunakan gambar yang sudah ada jika tidak ada yang baru dipilih
      }

      await supabase
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
          const SnackBar(
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
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _deleteProduk() async {
    // Tampilkan dialog konfirmasi
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus produk ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      setState(() {
        _isSaving = true; // Menggunakan status loading yang sama
      });
      try {
        await supabase
            .from('produk')
            .delete()
            .eq('id_produk', widget.product.idProduk);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produk berhasil dihapus!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // Kembali dan beri sinyal refresh
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menghapus produk: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE5ECF0),
        title: const Text('Edit Produk'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 19,right: 19, top: 10, bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Detail Kendaraan",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w700,
                  fontSize: 27.47,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 9),

              // Foto Produk
              const Text(
                "Foto Produk",
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 9),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity, // Mengisi lebar penuh
                  height: 200, // Tinggi tetap untuk area gambar
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF001F3F),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    image: _pickedImage != null
                        ? DecorationImage(image: FileImage(_pickedImage!), fit: BoxFit.cover)
                        : (_currentImageBytes != null
                            ? DecorationImage(image: MemoryImage(_currentImageBytes!), fit: BoxFit.cover)
                            : null),
                  ),
                  child: (_pickedImage == null && _currentImageBytes == null)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 43, color: Color(0xFF9B9B9B)),
                            SizedBox(width: 10), // Ubah dari horizontal menjadi vertikal
                            Text(
                              "Unggah Gambar Kendaraanmu",
                              style: TextStyle(
                                fontFamily: "Sora",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Color(0xFF9B9B9B),
                              ),
                            )
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
                                    _currentImageBytes = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                "Pastikan gambar yang Anda unggah sesuai dengan identitas resmi kendaraan anda",
                maxLines: 2,
                style: TextStyle(
                  fontFamily: "Sora",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6B8490),
                ),
              ),
              const SizedBox(height: 15),

              _buildTextField(
                controller: _namaKendaraanController,
                label: "Nama Kendaraan",
                hint: "Nama Kendaraan (ex. Honda Vario 125 (2015))",
                helperText: "Nama kendaraan lebih baik diisi lengkap dengan keterangan seri, cc, dan tahun keluaran",
                isMandatory: true,
              ),
              _buildTextField(
                controller: _hargaProdukController,
                label: "Harga Kendaraan",
                hint: "Harga Kendaraan",
                helperText: "Masukan harga yang pas",
                keyboardType: TextInputType.number,
                isMandatory: true,
              ),
              _buildTextField(
                controller: _deskripsiProdukController,
                label: "Deskripsi Produk",
                hint: "Kondisi Motor Anda",
                helperText: "Di sini Anda bisa mencantumkan spesifikasi dan syarat khusus untuk kendaraan Anda",
                maxLines: 5,
                isMandatory: true,
              ),
              const SizedBox(height: 25),

              // Tombol Hapus dan Simpan Perubahan
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _isSaving ? null : _deleteProduk, // Panggil _deleteProduk
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.red, // Warna merah untuk tombol hapus
                        ),
                        child: Center(
                          child: _isSaving
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Hapus",
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
                  ),
                  const SizedBox(width: 10), // Spasi antara tombol
                  Expanded(
                    child: GestureDetector(
                      onTap: _isSaving ? null : (_formIsValid ? _updateProduk : null),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: _formIsValid
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF0F6D79),
                                    Color(0xFF00BCD4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          color: _formIsValid ? null : Colors.grey[300], // Warna non-aktif
                        ),
                        child: Center(
                          child: _isSaving
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  "Simpan Perubahan",
                                  textAlign: TextAlign.center,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? helperText,
    bool isObscureText = false,
    TextInputType keyboardType = TextInputType.text,
    bool isMandatory = false,
    int? maxLength,
    int? maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + (isMandatory ? ' *' : ''), // Tambahkan tanda * jika wajib
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: "Sora",
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: isObscureText,
            keyboardType: keyboardType,
            maxLength: maxLength,
            maxLines: maxLines, // Menggunakan maxLines parameter
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF0F6D79),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  color: Color(0xFF0F6D79),
                  width: 1.5,
                ),
              ),
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFF6B8490),
                fontSize: 16,
                fontFamily: "Sora",
              ),
              labelText: label,
              labelStyle: const TextStyle(
                color: Color(0xFF6B8490),
                fontSize: 12,
                fontFamily: "Sora",
              ),
              counterText: "", // Menyembunyikan counter maxLength
            ),
          ),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                helperText,
                style: const TextStyle(
                  color: Color(0XFF6B8490),
                  fontSize: 12,
                  fontFamily: "Sora",
                ),
                maxLines: 2,
              ),
            ),
        ],
      ),
    );
  }
}