import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:rentalin_project/perental_pages/homePerental_page.dart';
import 'dart:typed_data'; // Untuk Uint8List
import 'dart:math'; 
import 'package:supabase_flutter/supabase_flutter.dart';

class TambahKendaraanPage extends StatefulWidget{
  const TambahKendaraanPage({super.key});

  @override
  State<TambahKendaraanPage> createState() => _TambahKendaraanPageState();
}

class _TambahKendaraanPageState extends State<TambahKendaraanPage> {
  File? _gambarKendaraan;
  final TextEditingController _namaKendaraanController = TextEditingController();
  final TextEditingController _hargaProdukController = TextEditingController();
  final TextEditingController _deskripsiProdukController = TextEditingController();
  bool _isLoading = false;

  String generateUuid() {
    var random = Random();
    var values = List<int>.generate(16, (_) => random.nextInt(256));
    
    values[6] = (values[6] & 0x0f) | 0x40; // Version 4
    values[8] = (values[8] & 0x3f) | 0x80; // Variant bits
    
    return '${values.sublist(0, 4).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}-'
           '${values.sublist(4, 6).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}-'
           '${values.sublist(6, 8).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}-'
           '${values.sublist(8, 10).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}-'
           '${values.sublist(10, 16).map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }

  bool get _formIsValid {
    return _gambarKendaraan != null &&
    _namaKendaraanController.text.isNotEmpty &&
    _hargaProdukController.text.isNotEmpty &&
    _deskripsiProdukController.text.isNotEmpty;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _namaKendaraanController.addListener(_updateState);
    _hargaProdukController.addListener(_updateState);
    _deskripsiProdukController.addListener(_updateState);
  }

  Future<void> _unggahGambar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 85
    );

    if (pickedFile != null) {
      setState(() {
        _gambarKendaraan = File(pickedFile.path);
      });
    }
  }

  Future<void> _tambahProduk() async {
    if (!_formIsValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }

      // Ambil id_rental dari tabel rental berdasarkan id_user
      final rentalData = await Supabase.instance.client
          .from('rental')
          .select('id_rental')
          .eq('id_user', currentUser.id)
          .single();

      if (rentalData == null || rentalData.isEmpty) {
        throw Exception('User belum terdaftar sebagai penyedia rental.');
      }

      final idRental = rentalData['id_rental'];
      final idProduk = generateUuid();
      final namaKendaraan = _namaKendaraanController.text.trim();
      final hargaProduk = int.parse(_hargaProdukController.text.trim());
      final deskripsiProduk = _deskripsiProdukController.text.trim();
      
      // Baca gambar sebagai bytes
      Uint8List? gambarBytes;
      if (_gambarKendaraan != null) {
        gambarBytes = await _gambarKendaraan!.readAsBytes();
      }

      await Supabase.instance.client.from('produk').insert({
        'id_produk': idProduk,
        'id_user': currentUser.id,
        'id_rental': idRental,
        'harga_produk': hargaProduk,
        'deskripsi_produk': deskripsiProduk,
        'gambar_produk': gambarBytes, // Menggunakan byte array
        'transaksi': 0, // Default 0 sesuai permintaan
        'status_produk': 'Tersedia', // Default "Tersedia" sesuai permintaan
        'nama_kendaraan': namaKendaraan,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Produk berhasil ditambahkan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePerentalPage()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menambahkan produk: $error'),
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
  void dispose() {
    _namaKendaraanController.removeListener(_updateState);
    _hargaProdukController.removeListener(_updateState);
    _deskripsiProdukController.removeListener(_updateState);
    _namaKendaraanController.dispose();
    _hargaProdukController.dispose();
    _deskripsiProdukController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE5ECF0),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 19,right: 19, top: 10, bottom: 50),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tulisan Tambah Kendaraan
                Text(
                  "Tambah Kendaraan",
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w700,
                    fontSize: 27.47,
                    color: Colors.black
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
                    color: Colors.black
                  )
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
                        style: _gambarKendaraan == null ?
                        BorderStyle.solid : BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(4),
                      image: _gambarKendaraan != null ?
                      DecorationImage(
                        image: FileImage(_gambarKendaraan!),
                        fit: BoxFit.cover
                      ) : null
                    ),
                    child: _gambarKendaraan == null ?
                    Row(
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
                            color: Color(0xFF9B9B9B)
                          ),
                        )
                      ],
                    ) : Stack(
                      children: [
                        Positioned.fill(
                          child: Container(),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                _gambarKendaraan = null;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )
                        ),
                      ],
                    )
                  )
                ),
                SizedBox(height: 9),
                Text(
                  "Pastikan gambar yang Anda unggah sesuai dengan identitas resmi kendaraan anda",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B8490)
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
                    color: Colors.black
                  )
                ),
                SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: _namaKendaraanController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xFF001F3F),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Nama Kendaraan (ex. Honda Vario 125 (2015))",
                            hintStyle: TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 16,
                              fontFamily: "Sora"
                            ),
                            labelText: "Nama Kendaraan",
                            labelStyle: TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 12,
                              fontFamily: "Sora"
                            ),
                          ),
                        )
                      ),
                    )
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
                    color: Color(0xFF6B8490)
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
                    color: Colors.black
                  )
                ),
                SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: _hargaProdukController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xFF001F3F),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Harga Kendaraan",
                            hintStyle: TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 16,
                              fontFamily: "Sora"
                            ),
                            labelText: "Harga",
                            labelStyle: TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 12,
                              fontFamily: "Sora"
                            ),
                          ),
                        )
                      ),
                    )
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
                    color: Color(0xFF6B8490)
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
                    color: Colors.black
                  )
                ),
                SizedBox(height: 9),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          controller: _deskripsiProdukController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xFF001F3F),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Kondisi Motor Anda",
                            hintStyle: TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 16,
                              fontFamily: "Sora"
                            ),
                            labelText: "Deskripsi",
                            labelStyle: TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 12,
                              fontFamily: "Sora"
                            ),
                          ),
                        )
                      ),
                    )
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
                    color: Color(0xFF6B8490)
                  ),
                ),
                SizedBox(height: 25),

                // Tombol Tambah
                GestureDetector(
                  onTap: _isLoading ? null : (_formIsValid ? _tambahProduk : null),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: _formIsValid ?
                      LinearGradient(
                        colors: [
                          Color(0xFF0F6D79),
                          Color(0xFF00BCD4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                      ) : null,
                      color: _formIsValid ?
                      null : Color(0x20000000)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Tambah",
                          style: TextStyle(
                            fontFamily: "Sora",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: _formIsValid ?
                            Colors.white : Color(0x20000000)
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}