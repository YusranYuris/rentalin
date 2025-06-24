import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formkey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );

      if (response.user != null) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          )
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Unexpected error occured"),
            backgroundColor: Theme.of(context).colorScheme.error, 
          )
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF064C55),
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Rentalin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.02,
                      fontFamily: 'Coolvetica'
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'Kendaraan Nganggur?\nUbah Jadi Cuan!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27.47,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Temukan kendaraan sewa dalam hitungan detik...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB0BEC5),
                      fontSize: 16.25,
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w300
                    ),
                  ),
                  const SizedBox(height: 32),
              
                  // Username field
                  Container(
                    width: 279.24,
                    height: 49.21,
                    decoration: BoxDecoration(
                      color: const Color(0x10FFFFFF),
                      border: Border.all(
                        color: Color(0x5000BCD4),
                        width: 1.14,
                      ),
                      borderRadius: BorderRadius.circular(16.02),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.44,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        isDense: true
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
              
                  // Password field
                  Container(
                    width: 279.24,
                    height: 49.21,
                    decoration: BoxDecoration(
                      color: const Color(0x10FFFFFF),
                      border: Border.all(
                        color: Color(0x5000BCD4),
                        width: 1.14,
                      ),
                      borderRadius: BorderRadius.circular(16.02),
                    ),
                    child: TextFormField(
                      controller: passController,
                      obscureText: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.44,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        suffixIcon: Padding(
                          padding:EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
              
                  // Checkbox & Forgot Password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Checkbox(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              activeColor: Colors.teal,
                              checkColor: Colors.white,
                              side: const BorderSide(
                                color: Colors.white,
                                width: 2
                              ),
                              value: rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  rememberMe = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Ingat saya',
                            style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w300,
                              fontSize: 12.59
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4), // opsional: geser dikit
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero, // biar ga ada padding aneh2
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        isLoading ? null : _login();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12), // BorderRadius dari ElevatedButton shape
                          gradient: const LinearGradient( // Ganti backgroundColor dengan gradient
                            colors: [
                              Color(0xFF0F6D79), // Warna awal
                              Color(0xFF00BCD4), // Warna akhir (ubah sesuai kebutuhan)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: isLoading ? 
                          const CircularProgressIndicator(color: Colors.white,) : Text(
                            'Log In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.25,
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        )
                      ),
                    ),
                  ),
                    const SizedBox(height: 16),
              
                  // Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w300,
                          fontSize: 12.59
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                            fontSize: 12.59
                          ),
                        ),
                      ),
                    ],
                  ),
              
                  const SizedBox(height: 24),
              
                  // Divider
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(color: Colors.white30, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'atau log in dengan',
                          style: TextStyle(
                            color: Color(0xFFB0BEC5),
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300  
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white30, thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
              
                  // Google and Facebook icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
              
                        },
                        child: Image.asset(
                          'assets/images/Google.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          // Facebook login action
                        },
                        child: Image.asset(
                          'assets/images/Facebook.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
              
                  // Version
                  const Text(
                    'Version 0.0.1',
                    style: TextStyle(
                      color: Color(0x50FFFFFF),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}