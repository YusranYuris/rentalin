import 'package:rentalin_project/components/main_screen.dart';
import 'package:rentalin_project/perental_pages/laporanPerentalan_page.dart';
import 'package:rentalin_project/perental_pages/produkAnda_page.dart';
import 'package:rentalin_project/perental_pages/tambahKendaraan_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePerentalPage extends StatefulWidget{
  const HomePerentalPage({super.key});

  @override
  State<HomePerentalPage> createState() => _HomePerentalPageState();
}

class _HomePerentalPageState extends State<HomePerentalPage> {
  final List<Widget> pages = [
    const ProdukAndaPage(),
    const LaporanPerentalanPage()
  ];

  int currentPage = 0;

  String userName = "Loading...";
  String rentalLocation = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      if (currentUser == null) return;

      // Ambil data user
      final userResponse = await Supabase.instance.client
          .from('user')
          .select('nama_rental')
          .eq('id_user', currentUser.id)
          .single();

      // Ambil data rental
      final rentalResponse = await Supabase.instance.client
          .from('rental')
          .select('lokasi_rental')
          .eq('id_user', currentUser.id)
          .single();

      if (mounted) {
        setState(() {
          userName = userResponse['nama_lengkap'] ?? 'Nama tidak ditemukan';
          rentalLocation = rentalResponse['lokasi_rental'] ?? 'Lokasi tidak ditemukan';
          isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          userName = 'Error loading name';
          rentalLocation = 'Error loading location';
          isLoading = false;
        });
      }
      print('Error loading user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                  Color(0xFF064C55),
                  Color(0xFF001F3F),
                  ],
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/iqbal_rental.png',
                        width: 45,
                        height: 45,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      isLoading ? "Loading..." : userName,
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: Colors.white
                      ),
                    ),
                    Text(
                      isLoading ? "Loading..." : rentalLocation,
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Colors.white
                      ),
                    )
                  ],
                ),
              )
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = 0;
                });
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                decoration: currentPage == 0 ? BoxDecoration(
                  color: Color(0xFF001F3F),
                ) : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.motorcycle_outlined,
                        color: currentPage == 0 ? Color(0xFFE5ECF0) : Color(0xFF001F3F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Produk Anda',
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontWeight: FontWeight.w400,
                          fontSize: 16.25,
                          color: currentPage == 0 ? Color(0xFFE5ECF0) : Color(0xFF001F3F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                setState(() {
                  currentPage = 1;
                });
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                decoration: currentPage == 1 ? BoxDecoration(
                  color: Color(0xFF001F3F),
                ) : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.featured_play_list_outlined,
                        color: currentPage == 1 ? Color(0xFFE5ECF0) : Color(0xFF001F3F),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Laporan Perentalan',
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontWeight: FontWeight.w400,
                          fontSize: 16.25,
                          color: currentPage == 1 ? Color(0xFFE5ECF0) : Color(0xFF001F3F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 500),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => MainPage())
                    );
                  },
                  child: Container(
                    width: 229,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0F6D79),
                          Color(0xFF00BCD4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight
                      )
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Beralih ke Perental",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),

      // Appbar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drawer button
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu, 
                      color: Colors.white,
                      size: 27,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),

                // Title
                Text(
                  "Rentalin",
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w700,
                    fontSize: 27.47,
                    color: Colors.white,
                  ),
                ),

                // Action button
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TambahKendaraanPage()),
                    );
                  },
                  icon: Icon(
                    Icons.add_circle,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: pages[currentPage]
    );
  }
}