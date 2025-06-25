import 'package:rentalin_project/penyewa_pages/cari_page.dart';
import 'package:rentalin_project/penyewa_pages/chat_page.dart';
import 'package:rentalin_project/penyewa_pages/favorit_page.dart';
import 'package:rentalin_project/penyewa_pages/pesanan_page.dart';
import 'package:rentalin_project/penyewa_pages/profil_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  final int initialPageIndex;
  const MainPage({super.key, this.initialPageIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPageIndex; // Set initial page index
  }
  
  final List<Widget> pages = [
    const CariPage(),
    // const FavoritPage(),
    const PesananPage(),
    // const ChatPage(),
    const ProfilPage()
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF001F3F),
        currentIndex: currentPage,
        selectedLabelStyle: const TextStyle(
          fontFamily: "Sora",
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: Colors.white
        ),
        unselectedLabelStyle: const TextStyle( // Tambahkan style untuk label tidak terpilih
          fontFamily: "Sora",
          fontWeight: FontWeight.w400,
          fontSize: 11,
          color: Colors.white70 // Sesuaikan transparansi
        ),
        selectedItemColor: Colors.white, // Warna ikon dan label item yang terpilih
        unselectedItemColor: Colors.white54,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "Cari",
            backgroundColor: Color(0xFF001F3F),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.local_grocery_store_outlined
          //   ),
          //   label: "Favorit",
          //   backgroundColor: Color(0xFF001F3F)
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.key
            ),
            label: "Pesanan",
            backgroundColor: Color(0xFF001F3F)
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.message
          //   ),
          //   label: "Chat",
          //   backgroundColor: Color(0xFF001F3F)
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person
            ),
            label: "Profil",
            backgroundColor: Color(0xFF001F3F)
          ),
        ]
      ),
    );
  }
}