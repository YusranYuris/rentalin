import 'package:flutter/material.dart';
import 'package:rentalin_project/perental_pages/homePerental_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DaftarPerentalPage extends StatefulWidget {
  @override
  State<DaftarPerentalPage> createState() => _DaftarPerentalPageState();
}

class _DaftarPerentalPageState extends State<DaftarPerentalPage> {
  final TextEditingController _namaRentalController = TextEditingController();
  final TextEditingController _lokasiRentalController = TextEditingController();

  Future<void> _registerRental() async {
    final nama_rental = _namaRentalController.text;
    final lokasi_rental = _lokasiRentalController.text;

    final response = await Supabase.instance.client
      .from('rental')
      .insert({
        'nama_rental': nama_rental,
        'lokasi_rental': lokasi_rental,
        'id_user': Supabase.instance.client.auth.currentUser!.id,
      });

    if (response.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftar rental: ${response.error!.message}')),
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => HomePerentalPage()), 
        (Route<dynamic> route) => false
      );
    }
  }

  bool get _formIsValid {
    return _namaRentalController.text.isNotEmpty &&
    _lokasiRentalController.text.isNotEmpty;
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
    _namaRentalController.dispose();
    _lokasiRentalController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFE5ECF0),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(
            0xFFE5ECF0
          ),
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                      ) 
                    ),
                  ],
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                      ) 
                    ),
                  ],
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
                SizedBox(height: 380),

                // Tombol Daftar
                GestureDetector(
                  onTap: _formIsValid ? _registerRental : null,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: _formIsValid ?
                      LinearGradient(
                        colors: [
                          Color(0xFF0F6D79),
                          Color(0XFF00BCD4)
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
                          "Daftar",
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