import 'package:flutter/material.dart';
import 'package:rentalin_project/penyewa_pages/cari_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final namaController = TextEditingController();
  final tglLahirController = TextEditingController();
  final noHpController = TextEditingController();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passController = TextEditingController();

  Future<void> daftarPengguna() async {
    final nama_lengkap = namaController.text;
    final tglLahir = tglLahirController.text;
    final noHp = noHpController.text;
    final email = emailController.text;
    final username = usernameController.text;
    final password = passController.text;

    final tglLahirFormatted = DateTime.tryParse(tglLahir)?.toIso8601String().substring(0, 10);

    // Validasi Input
    if([nama_lengkap, tglLahir, noHp, email, username, password].any((e) => e.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          "Semua field harus diisi"
        ))
      );
      return;
    }

    if(password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          "Password minimal 6 karakter"
        ))
      );
      return;
    }  

    try {
    // Signup ke Supabase Auth
    final authResponse = await Supabase.instance.client.auth.signUp(
      email: email,
      password: password,
    );

    if (authResponse.user != null) {
      // Simpan data tambahan ke tabel "user"
      final userId = authResponse.user!.id;

      final response = await Supabase.instance.client.from('user').insert({
        'id_user': userId,
        'nama_lengkap': nama_lengkap,
        'tanggal_lahir': tglLahirFormatted,
        'no_hp': noHp,
        'email': email,
        'username': username,
        'password': password, // atau kosongkan, karena sudah disimpan di auth
      });

      if (response.error != null) {
        throw response.error!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pendaftaran berhasil"))
      );

      await Future.delayed(Duration(seconds: 1));

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => CariPage()), 
        (Route<dynamic> route) => false
      );
    }
    } catch (e) {
      String errorMessage = "Gagal Daftar";
      if (e is AuthException && e.message.contains('over_email_send_rate_limit')) {
        errorMessage = "Anda mencoba mendaftar terlalu sering. Silakan tunggu sebentar dan coba lagi";
      } else {
        errorMessage = "Gagal daftar: ${e.toString()}";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage))
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFE5ECF0),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Color(0XFFE5ECF0)
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30, top: 5, right: 30, bottom: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "Selesaikan Pendaftaran",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 27.47,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
              
                  // Kotak Nama Lengkap
                  Row(
                    children: [
                      Container(
                        child: Text(
                          textAlign: TextAlign.left,
                          "Nama Lengkap",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: namaController,
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
                              hintText: "Nama lengkap pada bukti identitas",
                              hintStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 16
                              ),
                              labelText: "Nama lengkap pada bukti identitas",
                              labelStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 12
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Container(
                        width: 300,
                        child: Text(
                          "Pastikan nama Anda sesuai dengan nama pada bukti resmi identitas Anda",
                          style: TextStyle(
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
              
                  // Kotak Tanggal Lahir
                  Row(
                    children: [
                      Container(
                        child: Text(
                          textAlign: TextAlign.left,
                          "Tanggal Lahir",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: tglLahirController,
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
                              hintText: "Tanggal Lahir",
                              hintStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 16
                              ),
                              labelText: "Tanggal Lahir",
                              labelStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 12
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Container(
                        width: 350,
                        child: Text(
                          "Untuk mendaftar, Anda harus berusia setidaknya 18 tahun. Orang lain tidak bisa melihat tanggal lahir Anda.",
                          style: TextStyle(
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
                        
                  // Kotak Nomor HP
                  Row(
                    children: [
                      Container(
                        child: Text(
                          textAlign: TextAlign.left,
                          "Nomor Handphone",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: noHpController,
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
                              hintText: "Nomor HP",
                              hintStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 16
                              ),
                              labelText: "08XXXXXXXXXX",
                              labelStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 12
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Container(
                        width: 350,
                        child: Text(
                          "Kami akan mengirimkan Kode OTP via Nomor HP ini.",
                          style: TextStyle(
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
              
                  // Kotak Email
                  Row(
                    children: [
                      Container(
                        child: Text(
                          textAlign: TextAlign.left,
                          "Email",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            controller: emailController,
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
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 16
                              ),
                              labelText: "example@xyz.com",
                              labelStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 12
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Container(
                        width: 350,
                        child: Text(
                          "Pastikan menggunakan email utama Anda.",
                          style: TextStyle(
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),

                  // Kotak Password
                  Row(
                    children: [
                      Container(
                        child: Text(
                          textAlign: TextAlign.left,
                          "Password",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            obscureText: true,
                            controller: passController,
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
                              hintText: "Password",
                              hintStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 16
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 12
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Container(
                        width: 350,
                        child: Text(
                          "Password Minimal",
                          style: TextStyle(
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 15),

                  // Kotak Username
                  Row(
                    children: [
                      Container(
                        child: Text(
                          textAlign: TextAlign.left,
                          "Username",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            obscureText: true,
                            controller: usernameController,
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
                              hintText: "Username Anda",
                              hintStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 16
                              ),
                              labelText: "Username",
                              labelStyle: TextStyle(
                                color: Color(0xFF6B8490),
                                fontSize: 12
                              ),
                            ),
                          )
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                        
                  Row(
                    children: [
                      Container(
                        width: 350,
                        child: Text(
                          "Buat Username yang mirip dengan nama asli Anda",
                          style: TextStyle(
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 15),
              
                  GestureDetector(
                    onTap: daftarPengguna,
                    child: Container(
                      width: 350.37,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xff0F6D79),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), 
                            spreadRadius: 5, 
                            blurRadius: 20, 
                            
                          )
                        ]
                      ),
                      child: Center(
                        child: Text(
                          "Lanjutkan",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500
                          ),
                        )
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