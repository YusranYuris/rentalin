import 'package:rentalin_project/penyewa_pages/mulaiRental_page.dart';
import 'package:flutter/material.dart';
import 'package:rentalin_project/perental_pages/homePerental_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // Tambahkan ini
import 'dart:convert'; // Tambahkan ini (jika belum ada)

// Import untuk halaman edit profil yang akan dibuat nanti (saat ini placeholder)
import 'package:rentalin_project/penyewa_pages/editProfil_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final supabase = Supabase.instance.client;

  String _namaLengkap = "Memuat...";
  Uint8List? _profileImageBytes; // <--- Tambahkan state ini untuk foto profil
  int _dataTerisi = 0;
  final int _totalData = 10;
  double _persentaseKelengkapan = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() {
            _namaLengkap = "Pengguna Tidak Terautentikasi";
            _isLoading = false;
          });
        }
        print('User not authenticated');
        return;
      }

      // Ambil data profil dari tabel "user"
      final userData = await supabase
          .from('user')
          .select('nama_lengkap, tanggal_lahir, no_hp, email, username, password, foto_profil, nik, profesi, domisili')
          .eq('id_user', user.id)
          .single();

      if (mounted) {
        setState(() {
          _namaLengkap = userData['nama_lengkap'] ?? "Nama Tidak Ditemukan";
          
          // --- Parsing foto_profil (MIRIP DENGAN LOGIKA PRODUK) ---
          _profileImageBytes = null; // Reset
          if (userData['foto_profil'] != null && userData['foto_profil'] is String) {
            String hexString = userData['foto_profil'] as String;
            if (hexString.startsWith('\\x')) {
              hexString = hexString.substring(2);
            }
            try {
              List<int> asciiCodeUnits = [];
              for (int i = 0; i < hexString.length; i += 2) {
                String hexPair = hexString.substring(i, i + 2);
                int byte = int.parse(hexPair, radix: 16);
                asciiCodeUnits.add(byte);
              }
              String rawListString = utf8.decode(asciiCodeUnits);
              if (rawListString.startsWith('[') && rawListString.endsWith(']')) {
                rawListString = rawListString.substring(1, rawListString.length - 1);
              }
              List<int> byteList = rawListString.split(',')
                  .map((s) => int.tryParse(s.trim()) ?? 0)
                  .toList();
              _profileImageBytes = Uint8List.fromList(byteList);
            } catch (e) {
              print('Error parsing foto_profil hex string: $e');
              _profileImageBytes = null;
            }
          } else if (userData['foto_profil'] is List) { // Jika ternyata dikembalikan sebagai List<int>
            _profileImageBytes = Uint8List.fromList(List<int>.from(userData['foto_profil']));
          }
          // --- END Parsing foto_profil ---

          _calculateProfileCompletion(userData);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _namaLengkap = "Error Memuat Profil";
          _isLoading = false;
        });
      }
      print('Error loading profile data: $e');
    }
  }

  void _calculateProfileCompletion(Map<String, dynamic> userData) {
    int count = 0;
    // Daftar kolom yang dianggap penting untuk kelengkapan profil
    final List<String> profileFields = [
      'nama_lengkap', 'tanggal_lahir', 'no_hp', 'email', 'username',
      'password', 'nik', 'profesi', 'domisili' // Perhatikan password dan NIK/Profesi/Domisili
    ];

    // Cek field string yang tidak boleh kosong
    for (String field in profileFields) {
      if (userData[field] != null) {
        if (userData[field] is String) {
          if ((userData[field] as String).isNotEmpty) {
            count++;
          }
        } else {
          // Untuk tipe data selain string (misal: DATE), cukup cek null
          count++;
        }
      }
    }

    // Cek foto_profil secara terpisah karena sudah diparse ke _profileImageBytes
    if (_profileImageBytes != null) {
      count++;
    } else if (userData['foto_profil'] != null) {
      // Jika userData['foto_profil'] ada tapi _profileImageBytes null (parsing gagal)
      // Ini bisa dihitung juga sebagai terisi, tergantung definisi "terisi" Anda.
      // Untuk tujuan ini, kita akan menghitung jika raw data ada.
      count++;
    }


    setState(() {
      // Pastikan _totalData sesuai dengan jumlah field yang dicek
      // nama_lengkap, tanggal_lahir, no_hp, email, username, password, foto_profil, nik, profesi, domisili
      // Total 10 field. Sesuaikan 'password' jika Anda tidak menyimpannya di tabel user.
      _dataTerisi = count;
      _persentaseKelengkapan = (_dataTerisi / _totalData) * 100;
    });
  }

  Future<bool> _cekStatusRental() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('User not authenticated');
        return false;
      }
      final response = await supabase
          .from('rental')
          .select('id_user')
          .eq('id_user', user.id);
      return response.isNotEmpty;
    } catch (e) {
      print('Error checking rental status: $e');
      return false;
    }
  }

  void _handleMulaiRental() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00BCD4),
          ),
        );
      },
    );

    try {
      bool isRentalExist = await _cekStatusRental();
      Navigator.of(context).pop();
      
      if (isRentalExist) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePerentalPage()
          )
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MulaiRentalPage()
          )
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan. Silakan coba lagi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rentalin",
          style: TextStyle(
            fontFamily: 'Coolvetica',
            fontWeight: FontWeight.w400,
            fontSize: 28,
            color: Color(0xFF001F3F)
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFE5ECF0),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE5ECF0)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 17.0, right: 17, top: 10),
          child: Column(
            children: [
              // Kotak Informasi Profil yang dapat diklik
              GestureDetector(
                onTap: () async {
                  if (!_isLoading) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilPage()
                      ),
                    );
                    _loadProfileData(); // Muat ulang data profil setelah kembali
                  }
                },
                child: Container(
                  width: 365,
                  height: 168,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF001F3F),
                        Color(0xFF0F6D79),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 18, right: 18, top: 26, bottom: 0),
                    child: _isLoading
                      ? Center(child: CircularProgressIndicator(color: Colors.white))
                      : Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Color(0xFFD9D9D9),
                                  radius: 25, // Atur radius sesuai kebutuhan
                                  // <--- Perubahan di sini untuk menampilkan foto profil
                                  backgroundImage: _profileImageBytes != null
                                      ? MemoryImage(_profileImageBytes!) as ImageProvider
                                      : null,
                                  child: _profileImageBytes == null
                                      ? Icon(Icons.person, color: Colors.white, size: 30) // Icon default jika tidak ada gambar
                                      : null,
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _namaLengkap,
                                          style: TextStyle(
                                            fontFamily: 'Sora',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                        )
                                      ],
                                    ),
                                    Text(
                                      "ID : ${supabase.auth.currentUser?.id?.substring(0, 8) ?? 'N/A'}",
                                      style: TextStyle(
                                        fontFamily: 'Sora',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10,
                                        color: Colors.white
                                      ),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: Colors.white,
                                  size: 20,
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            // Garis Progress Bar Kelengkapan Profil
                            Stack(
                              children: [
                                Container(
                                  width: 305,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFB0BEC5).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                ),
                                Container(
                                  width: 305 * (_persentaseKelengkapan / 100),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF00BCD4),
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                SizedBox(width: 13),
                                Text(
                                  "${_persentaseKelengkapan.toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: Colors.white
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  "${_dataTerisi}/$_totalData data profil terisi",
                                  style: TextStyle(
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10,
                                    color: Colors.white
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Container(
                              width: 300,
                              height: 26,
                              child: Text(
                                "Profil yang lengkap bisa membantu kami memberikan rekomendasi yang lebih akurat.",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                    color: Colors.white
                                ),
                              )
                            )
                          ],
                        ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              // GestureDetector(
              //   child: Container(
              //     width: 364,
              //     height: 30,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Color(0xFF00BCD4),
              //         width: 1.5
              //       )
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.monetization_on_outlined,
              //             color: Color(0xFF001F3F),
              //             size: 20,
              //           ),
              //           SizedBox(width: 10),
              //           Text(
              //             "Riwayat Transaksi",
              //             style: TextStyle(
              //               fontFamily: 'Sora',
              //               fontWeight: FontWeight.w400,
              //               fontSize: 16.25,
              //               color: Color(0xFF001F3F),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 5),
              // GestureDetector(
              //   child: Container(
              //     width: 364,
              //     height: 30,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Color(0xFF00BCD4),
              //         width: 1.5
              //       )
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.question_mark_rounded,
              //             color: Color(0xFF001F3F),
              //             size: 20,
              //           ),
              //           SizedBox(width: 10),
              //           Text(
              //             "Pusat Bantuan",
              //             style: TextStyle(
              //               fontFamily: 'Sora',
              //               fontWeight: FontWeight.w400,
              //               fontSize: 16.25,
              //               color: Color(0xFF001F3F),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 5),
              // GestureDetector(
              //   child: Container(
              //     width: 364,
              //     height: 30,
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Color(0xFF00BCD4),
              //         width: 1.5
              //       )
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 20),
              //       child: Row(
              //         children: [
              //           Icon(
              //             Icons.perm_phone_msg_outlined,
              //             color: Color(0xFF001F3F),
              //             size: 20,
              //           ),
              //           SizedBox(width: 10),
              //           Text(
              //             "Customer Service",
              //             style: TextStyle(
              //               fontFamily: 'Sora',
              //               fontWeight: FontWeight.w400,
              //               fontSize: 16.25,
              //               color: Color(0xFF001F3F),
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 60),

              // Tombol Logout
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00BCD4),
                        ),
                      );
                    },
                  );
                  try {
                    await supabase.auth.signOut();
                    if (mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    }
                  } catch (e) {
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal logout: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  width: 364,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF00BCD4),
                      width: 1.5
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Color(0xFF001F3F),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400,
                            fontSize: 16.25,
                            color: Color(0xFF001F3F),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 350,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _handleMulaiRental,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                          Color(0xFF001F3F),
                          Color(0xFF0F6D79),
                          ],
                        ),
                      ),
                      width: 157,
                      height: 36,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 7),
                            Text(
                              "Mulai Rental",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 16.25,
                                color: Colors.white
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Version 0.0.1",
                    style: TextStyle(
                      color: Color(0x50000000),
                      fontSize: 16.02
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}