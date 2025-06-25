import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // Untuk Uint8List
import 'dart:convert';

class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final supabase = Supabase.instance.client;

  final TextEditingController _namaLengkapController = TextEditingController();
  final TextEditingController _tanggalLahirController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Untuk input password baru
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _profesiController = TextEditingController();
  final TextEditingController _domisiliController = TextEditingController();

  File? _pickedProfileImage; // Untuk gambar profil baru yang dipilih
  Uint8List? _currentProfileImageBytes; // Untuk byte gambar profil yang ada
  
  bool _isLoading = true; // Status loading untuk memuat data awal
  bool _isSaving = false; // Status saving untuk proses update

  @override
  void initState() {
    super.initState();
    _loadProfileData();

    // Listener untuk validasi form dinamis
    _namaLengkapController.addListener(_updateState);
    _tanggalLahirController.addListener(_updateState);
    _noHpController.addListener(_updateState);
    _emailController.addListener(_updateState);
    _usernameController.addListener(_updateState);
    _passwordController.addListener(_updateState);
    _nikController.addListener(_updateState);
    _profesiController.addListener(_updateState);
    _domisiliController.addListener(_updateState);
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _tanggalLahirController.dispose();
    _noHpController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _nikController.dispose();
    _profesiController.dispose();
    _domisiliController.dispose();
    super.dispose();
  }

  void _updateState() {
    setState(() {}); // Memicu rebuild untuk validasi tombol
  }

  bool get _formIsValid {
    // Basic validation: nama lengkap, no hp, email, username, dan domisili tidak boleh kosong
    return _namaLengkapController.text.trim().isNotEmpty &&
           _noHpController.text.trim().isNotEmpty &&
           _emailController.text.trim().isNotEmpty &&
           _usernameController.text.trim().isNotEmpty &&
           _domisiliController.text.trim().isNotEmpty;
           // Tanggal lahir, NIK, profesi, foto profil bisa kosong (opsional)
           // Password hanya divalidasi jika diisi
  }

  Future<void> _loadProfileData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User tidak terautentikasi.');
      }

      final userData = await supabase
          .from('user')
          .select('nama_lengkap, tanggal_lahir, no_hp, email, username, foto_profil, nik, profesi, domisili')
          .eq('id_user', user.id)
          .single();

      if (mounted) {
        setState(() {
          _namaLengkapController.text = userData['nama_lengkap'] ?? '';
          _tanggalLahirController.text = userData['tanggal_lahir'] ?? '';
          _noHpController.text = userData['no_hp'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _usernameController.text = userData['username'] ?? '';
          // Password tidak diisi di sini demi keamanan
          _nikController.text = userData['nik'] ?? '';
          _profesiController.text = userData['profesi'] ?? '';
          _domisiliController.text = userData['domisili'] ?? '';
          
          if (userData['foto_profil'] != null) {
            // Asumsi foto_profil dikembalikan sebagai List<int> atau hex string
            if (userData['foto_profil'] is String && (userData['foto_profil'] as String).startsWith('\\x')) {
              // Jika ini adalah hex string seperti yang kita tangani di produkAnda_page
              String hexString = userData['foto_profil'] as String;
              hexString = hexString.substring(2); // Hapus prefix \x

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
                _currentProfileImageBytes = Uint8List.fromList(byteList);
              } catch (e) {
                print('Error parsing foto_profil hex string: $e');
                _currentProfileImageBytes = null;
              }
            } else if (userData['foto_profil'] is List) {
              _currentProfileImageBytes = Uint8List.fromList(List<int>.from(userData['foto_profil']));
            } else {
              _currentProfileImageBytes = null;
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data profil: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
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
        _pickedProfileImage = File(pickedFile.path);
        _currentProfileImageBytes = null; // Hapus gambar lama jika ada yang baru dipilih
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formIsValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mohon isi semua data yang wajib diisi.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User tidak terautentikasi.');
      }

      // Data yang akan diupdate ke tabel "user"
      final Map<String, dynamic> updates = {
        'nama_lengkap': _namaLengkapController.text.trim(),
        'tanggal_lahir': _tanggalLahirController.text.trim(),
        'no_hp': _noHpController.text.trim(),
        'email': _emailController.text.trim(), // Email juga bisa diupdate lewat auth, tapi kita update di tabel user juga
        'username': _usernameController.text.trim(),
        // 'password': _passwordController.text.trim(), // Jangan update password langsung dari sini
        'nik': _nikController.text.trim(),
        'profesi': _profesiController.text.trim(),
        'domisili': _domisiliController.text.trim(),
      };

      // Handle foto_profil
      Uint8List? finalProfileImageBytes;
      if (_pickedProfileImage != null) {
        finalProfileImageBytes = await _pickedProfileImage!.readAsBytes();
      } else {
        finalProfileImageBytes = _currentProfileImageBytes;
      }
      updates['foto_profil'] = finalProfileImageBytes;

      // Update password jika diisi
      if (_passwordController.text.trim().isNotEmpty) {
        if (_passwordController.text.trim().length < 6) {
          throw Exception('Password minimal 6 karakter.');
        }
        await supabase.auth.updateUser(UserAttributes(
          password: _passwordController.text.trim(),
        ));
        // Jika update password berhasil, kita juga bisa update di tabel user jika disimpan di sana
        // updates['password'] = _passwordController.text.trim(); // Opsional, jika Anda menyimpan password di tabel user
      }
      
      // Lakukan update ke tabel "user"
      await supabase
          .from('user')
          .update(updates)
          .eq('id_user', user.id);

      // Jika email diubah, update juga di Supabase Auth
      if (_emailController.text.trim() != user.email) {
        await supabase.auth.updateUser(UserAttributes(
          email: _emailController.text.trim(),
        ));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil berhasil diperbarui!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Autentikasi: ${e.message}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: const Color(0xFFE5ECF0),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE5ECF0),
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit Data Profil Anda',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 27.47,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Sora",
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Foto Profil
                    const Text(
                      "Foto Profil",
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
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                          border: Border.all(color: const Color(0xFF001F3F), width: 1.5),
                          image: _pickedProfileImage != null
                              ? DecorationImage(image: FileImage(_pickedProfileImage!), fit: BoxFit.cover)
                              : (_currentProfileImageBytes != null
                                  ? DecorationImage(image: MemoryImage(_currentProfileImageBytes!), fit: BoxFit.cover)
                                  : null),
                        ),
                        child: (_pickedProfileImage == null && _currentProfileImageBytes == null)
                            ? const Icon(Icons.camera_alt, size: 40, color: Color(0xFF9B9B9B))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 9),
                    const Text(
                      "Unggah foto profil Anda.",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF6B8490),
                      ),
                    ),
                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _namaLengkapController,
                      label: "Nama Lengkap",
                      hint: "Nama lengkap sesuai identitas",
                      helperText: "Pastikan nama Anda sesuai dengan nama pada bukti resmi identitas Anda",
                      isMandatory: true,
                    ),
                    _buildTextField(
                      controller: _tanggalLahirController,
                      label: "Tanggal Lahir",
                      hint: "YYYY-MM-DD",
                      helperText: "Format: Tahun-Bulan-Hari. Contoh: 1990-01-15. (Anda harus berusia setidaknya 18 tahun)",
                      isMandatory: true,
                      keyboardType: TextInputType.datetime,
                    ),
                    _buildTextField(
                      controller: _noHpController,
                      label: "Nomor Handphone",
                      hint: "08XXXXXXXXXX",
                      helperText: "Kami akan mengirimkan Kode OTP via Nomor HP ini.",
                      isMandatory: true,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "example@xyz.com",
                      helperText: "Pastikan menggunakan email utama Anda.",
                      isMandatory: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    _buildTextField(
                      controller: _usernameController,
                      label: "Username",
                      hint: "Username Anda",
                      helperText: "Buat Username yang mirip dengan nama asli Anda.",
                      isMandatory: true,
                    ),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password Baru (isi jika ingin mengubah)",
                      hint: "Password baru",
                      helperText: "Kosongkan jika tidak ingin mengubah. Minimal 6 karakter.",
                      isObscureText: true,
                    ),
                    _buildTextField(
                      controller: _nikController,
                      label: "NIK (Nomor Induk Kependudukan)",
                      hint: "Nomor KTP/NIK Anda",
                      helperText: "NIK diperlukan untuk verifikasi data (opsional)",
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                    ),
                    _buildTextField(
                      controller: _profesiController,
                      label: "Profesi",
                      hint: "Profesi Anda saat ini (opsional)",
                      helperText: "Misal: Pelajar, Karyawan, Wiraswasta.",
                    ),
                    _buildTextField(
                      controller: _domisiliController,
                      label: "Domisili",
                      hint: "Domisili Anda saat ini",
                      helperText: "Masukkan kota domisili Anda.",
                      isMandatory: true,
                    ),

                    const SizedBox(height: 20),
                    // Tombol Simpan
                    GestureDetector(
                      onTap: _isSaving ? null : (_formIsValid ? _updateProfile : null),
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
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
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.25,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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