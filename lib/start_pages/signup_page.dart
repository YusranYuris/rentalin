import 'package:flutter/material.dart';
import 'package:rentalin_project/components/main_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // Import for DateFormat

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

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default 18 tahun lalu
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Pastikan minimal 18 tahun
    );
    if (picked != null) {
      setState(() {
        tglLahirController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

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
        const SnackBar(content: Text(
          "Semua field harus diisi"
        ))
      );
      return;
    }

    if(password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
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

      await Supabase.instance.client.from('user').insert({
        'id_user': userId,
        'nama_lengkap': nama_lengkap,
        'tanggal_lahir': tglLahirFormatted,
        'no_hp': noHp,
        'email': email,
        'username': username,
        'password': password,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pendaftaran berhasil"))
        );

        await Future.delayed(const Duration(seconds: 1));

        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => const MainPage()), 
          (Route<dynamic> route) => false
        );
      }
    }
    } on AuthException catch (e) { 
      String errorMessage = "Gagal Daftar";
      if (e.message.contains('over_email_send_rate_limit')) {
        errorMessage = "Anda mencoba mendaftar terlalu sering. Silakan tunggu sebentar dan coba lagi";
      } else {
        errorMessage = "Gagal daftar: ${e.message}"; 
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red) 
        );
      }
    } catch (e) { // Tangkap generic Exception
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal daftar: ${e.toString()}"), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  void dispose() {
    namaController.dispose();
    tglLahirController.dispose();
    noHpController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFE5ECF0), // Gunakan const
        ),
        body: Container(
          decoration: const BoxDecoration( // Gunakan const
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
                      Text(
                        "Selesaikan Pendaftaran",
                        style: const TextStyle( // Gunakan const
                          color: Colors.black,
                          fontSize: 27.47,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Gunakan const
              
                  // Kotak Nama Lengkap
                  Row(
                    children: [
                      Text(
                        "Nama Lengkap",
                        style: const TextStyle( // Gunakan const
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded(
                        child: TextField( // Hapus Container di dalamnya
                          controller: namaController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79), // Ubah ke warna yang konsisten
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Nama lengkap pada bukti identitas",
                            hintStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 16
                            ),
                            labelText: "Nama lengkap pada bukti identitas",
                            labelStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 12
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded( // Menggunakan Expanded untuk Text
                        child: Text(
                          "Pastikan nama Anda sesuai dengan nama pada bukti resmi identitas Anda",
                          style: const TextStyle( // Gunakan const
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15), // Gunakan const
              
                  // Kotak Tanggal Lahir (DIPERBAIKI UNTUK DATEPICKER)
                  Row(
                    children: [
                      Text(
                        "Tanggal Lahir",
                        style: const TextStyle( // Gunakan const
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded(
                        child: TextField( // <-- Ganti dengan TextField
                          controller: tglLahirController,
                          readOnly: true, // Membuat TextField tidak bisa diketik
                          onTap: () => _selectDate(context), // Memanggil DatePicker saat diklik
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide(
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "YYYY-MM-DD", // Ubah hint text
                            hintStyle: const TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 16
                            ),
                            labelText: "Tanggal Lahir",
                            labelStyle: const TextStyle(
                              color: Color(0xFF6B8490),
                              fontSize: 12
                            ),
                            suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF6B8490)), // Icon kalender
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded( // Menggunakan Expanded untuk Text
                        child: Text(
                          "Untuk mendaftar, Anda harus berusia setidaknya 18 tahun. Orang lain tidak bisa melihat tanggal lahir Anda.",
                          style: const TextStyle( // Gunakan const
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15), // Gunakan const
                        
                  // Kotak Nomor HP
                  Row(
                    children: [
                      Text(
                        "Nomor Handphone",
                        style: const TextStyle( // Gunakan const
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded(
                        child: TextField( // Hapus Container di dalamnya
                          controller: noHpController,
                          keyboardType: TextInputType.phone, // Tipe keyboard phone
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Nomor HP",
                            hintStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 16
                            ),
                            labelText: "08XXXXXXXXXX",
                            labelStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 12
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded( // Menggunakan Expanded untuk Text
                        child: Text(
                          "Kami akan mengirimkan Kode OTP via Nomor HP ini.",
                          style: const TextStyle( // Gunakan const
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15), // Gunakan const
              
                  // Kotak Email
                  Row(
                    children: [
                      Text(
                        "Email",
                        style: const TextStyle( // Gunakan const
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded(
                        child: TextField( // Hapus Container di dalamnya
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress, // Tipe keyboard email
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Email",
                            hintStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 16
                            ),
                            labelText: "example@xyz.com",
                            labelStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 12
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded( // Menggunakan Expanded untuk Text
                        child: Text(
                          "Pastikan menggunakan email utama Anda.",
                          style: const TextStyle( // Gunakan const
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15), // Gunakan const

                  // Kotak Password
                  Row(
                    children: [
                      Text(
                        "Password",
                        style: const TextStyle( // Gunakan const
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded(
                        child: TextField( // Hapus Container di dalamnya
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 16
                            ),
                            labelText: "Password",
                            labelStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 12
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded( // Menggunakan Expanded untuk Text
                        child: Text(
                          "Password minimal 6 karakter.", // Ubah teks ini
                          style: const TextStyle( // Gunakan const
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 15), // Gunakan const

                  // Kotak Username
                  Row(
                    children: [
                      Text(
                        "Username",
                        style: const TextStyle( // Gunakan const
                          fontSize: 20,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded(
                        child: TextField( // Hapus Container di dalamnya
                          controller: usernameController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: const BorderSide( // Gunakan const
                                color: Color(0xFF0F6D79),
                                width: 1.5
                              )
                            ),
                            hintText: "Username Anda",
                            hintStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 16
                            ),
                            labelText: "Username",
                            labelStyle: const TextStyle( // Gunakan const
                              color: Color(0xFF6B8490),
                              fontSize: 12
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Gunakan const
                        
                  Row(
                    children: [
                      Expanded( // Menggunakan Expanded untuk Text
                        child: Text(
                          "Buat Username yang mirip dengan nama asli Anda",
                          style: const TextStyle( // Gunakan const
                            color: Color(0XFF6B8490),
                            fontSize: 12
                          ),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15), // Gunakan const
              
                  GestureDetector(
                    onTap: daftarPengguna,
                    child: Container(
                      width: 350.37,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color(0xff0F6D79), // Gunakan const
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), 
                            spreadRadius: 5, 
                            blurRadius: 20, 
                            offset: const Offset(0, 0), // Tambahkan offset
                          )
                        ]
                      ),
                      child: const Center( // Gunakan const
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