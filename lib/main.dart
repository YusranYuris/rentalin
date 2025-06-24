import 'package:rentalin_project/components/main_screen.dart';
import 'package:rentalin_project/start_pages/signup_page.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:rentalin_project/start_pages/splash_screen.dart';
import 'package:rentalin_project/start_pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tyyamriypajoejrhfofl.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR5eWFtcml5cGFqb2Vqcmhmb2ZsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwODA4NjAsImV4cCI6MjA2NDY1Njg2MH0.6gV88Hh4yEnBfZhnHCYRjptrTucMKxiq1hxX3kdFkdY',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent
        )
      ),
      debugShowCheckedModeBanner: false,
      title: 'Rentalin App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainPage(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpPage()
      },
    );
  }
}
