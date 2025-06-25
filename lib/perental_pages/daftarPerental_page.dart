import 'package:flutter/material.dart';
import 'package:rentalin_project/perental_pages/homePerental_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class DaftarPerentalPage extends StatefulWidget {
  @override
  State<DaftarPerentalPage> createState() => _DaftarPerentalPageState();
}

class _DaftarPerentalPageState extends State<DaftarPerentalPage> {
  final TextEditingController _namaRentalController = TextEditingController();
  final TextEditingController _lokasiRentalController = TextEditingController();
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

  Future<void> _registerRental() async {
    if (!_formIsValid) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final namaRental = _namaRentalController.text.trim();
      final lokasiRental = _lokasiRentalController.text.trim();
      final currentUser = Supabase.instance.client.auth.currentUser;

      if (currentUser == null) {
        throw Exception('User tidak terautentikasi');
      }
      final idRental = generateUuid();

      final response = await Supabase.instance.client
          .from('rental')
          .insert({
            'id_user': currentUser.id,
            'id_rental': idRental,
            'nama_rental': namaRental,
            'lokasi_rental': lokasiRental,
          });

      // Supabase Flutter v2+ tidak menggunakan response.error
      // Jika sampai sini berarti berhasil
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil mendaftar rental!'),
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
            content: Text('Gagal mendaftar rental: $error'),
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

  bool get _formIsValid {
    return _namaRentalController.text.trim().isNotEmpty &&
           _lokasiRentalController.text.trim().isNotEmpty;
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _namaRentalController.addListener(_updateState);
    _lokasiRentalController.addListener(_updateState);
  }

  @override
  void dispose() {
    _namaRentalController.removeListener(_updateState);
    _lokasiRentalController.removeListener(_updateState);
    _namaRentalController.dispose();
    _lokasiRentalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE5ECF0),
        title: Text('Daftar Rental'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE5ECF0),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 19, top: 10, right: 19, bottom: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selesaikan Pendaftaran",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27.47,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Sora"
                  ),
                ),
                SizedBox(height: 9),

                // Nama Rental
                Text(
                  "Nama Rental",
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
                SizedBox(height: 9),
                TextField(
                  controller: _namaRentalController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: Color(0xFF0F6D79),
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
                    labelText: "Nama Rental Anda",
                    labelStyle: TextStyle(
                      color: Color(0xFF6B8490),
                      fontSize: 12,
                      fontFamily: "Sora"
                    ),
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  "Masukkan nama rental anda yang akan tampil sebagai username rental anda",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B8490)
                  ),
                ),
                SizedBox(height: 15),

                // Lokasi Rental
                Text(
                  "Lokasi Rental",
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
                SizedBox(height: 9),
                TextField(
                  controller: _lokasiRentalController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: Color(0xFF0F6D79),
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
                    labelText: "Lokasi Rental Anda",
                    labelStyle: TextStyle(
                      color: Color(0xFF6B8490),
                      fontSize: 12,
                      fontFamily: "Sora"
                    ),
                  ),
                ),
                SizedBox(height: 9),
                Text(
                  "Masukkan lokasi rental anda",
                  maxLines: 2,
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B8490)
                  ),
                ),
                SizedBox(height: 50),

                // Debug info (hapus saat production)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Debug Info:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Form Valid: $_formIsValid'),
                      Text('Nama: "${_namaRentalController.text}"'),
                      Text('Lokasi: "${_lokasiRentalController.text}"'),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Tombol Daftar
                ElevatedButton(
                  onPressed: _isLoading ? null : (_formIsValid ? _registerRental : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _formIsValid ? Color(0xFF0F6D79) : Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: _isLoading 
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Daftar",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}