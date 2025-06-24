import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:rentalin_project/perental_pages/homePerental_page.dart';

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

  @override
  void dispose() {
    _namaKendaraanController.dispose();
    _hargaProdukController.dispose();
    _deskripsiProdukController.dispose();
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
                  onTap: _formIsValid ? (){
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => HomePerentalPage()),  
                      (Route<dynamic> route) => false
                    );
                  } : null,
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