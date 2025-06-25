import 'package:flutter/material.dart';
// Tambahkan import ini untuk model Product
import 'package:rentalin_project/perental_pages/produkAnda_page.dart';

class DetailProdukPage extends StatefulWidget {
  final Product product;

  const DetailProdukPage({super.key, required this.product});

  @override
  State<DetailProdukPage> createState() => _DetailProdukPageState();
}

class _DetailProdukPageState extends State<DetailProdukPage> {

  @override
  Widget build(BuildContext context) {
    final Product currentProduct = widget.product;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE5ECF0)
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        child: Image.asset(
                          'assets/images/iqbal_rental.png',
                          width: 406,
                          height: 346,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rp275.000/hari",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                              color: Colors.black
                            ),
                          ),
                          Text(
                            "Ducati Panigale V4",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black
                            ),
                          ),
                          Text(
                            "Iqbal Rental",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.white,
                            height: 2,
                            width: double.infinity,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Deskripsi",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Masih Mulus, STNK Lengkap, Pajak Hidup, Ban Baru, Service Rutin, Siap Pakai.",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black
                            ),
                          ),
                          SizedBox(height: 250),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 363,
                                height: 56,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF0F6D79),
                                      Color(0xFF00BCD4)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Pesan Sekarang",
                                      style: TextStyle(
                                        fontFamily: "Sora",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.white
                                      ), 
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          )
        ),
      ),
    );
  }
}