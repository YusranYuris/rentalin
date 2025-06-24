import 'package:flutter/material.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class CariPage extends StatefulWidget {
  const CariPage({super.key});
  @override
  State<CariPage> createState() => _CariPageState();
}

// Atribut-atribut Rental
class RentalItem {
  final String gambar_produk;
  final String nama_rental;
  final double rating_produk;
  final String lokasi_rental;

  RentalItem({
    required this.gambar_produk,
    required this.nama_rental,
    required this.rating_produk,
    required this.lokasi_rental,
  });
}

// Class Rental Item Card
class RentalItemCard extends StatelessWidget {
  final RentalItem item;

  const RentalItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext){
    return Container(
        width: 365,
        height: 409,
        decoration: BoxDecoration(
          
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                item.gambar_produk,
                width: 365,
                height: 339,  
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 300,
                  child: Text(
                    item.nama_rental,
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w600,
                      fontSize: 14
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  height: 25,
                  width: 56,
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                        size: 20,
                      ),
                      Text(
                        item.rating_produk.toString(),
                        style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Text(
              item.lokasi_rental,
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w300,
                fontSize: 8.75
              ),
            ),
            Text(
              "Pesan sebelum 20 Agustus",
              style: TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w300,
                fontSize: 8.75
              ),
            ),
            SizedBox(height: 5)
          ],
        ),
      );
  }
}

class _CariPageState extends State<CariPage> {
  final List<RentalItem> rentalItems = [
    RentalItem(
      gambar_produk: 'assets/images/iqbal_rental.png', 
      nama_rental: "Haji Rental", 
      rating_produk: 4.8, 
      lokasi_rental: "Mulyorejo"
    ),
    RentalItem(
      gambar_produk: 'assets/images/iqbal_rental.png', 
      nama_rental: "Iqbal Rental", 
      rating_produk: 5.0, 
      lokasi_rental: "Mulyorejo"
    ),
    RentalItem(
      gambar_produk: 'assets/images/iqbal_rental.png', 
      nama_rental: "Raja Rental", 
      rating_produk: 4.7, 
      lokasi_rental: "Mulyorejo"
    ),
    RentalItem(
      gambar_produk: 'assets/images/iqbal_rental.png', 
      nama_rental: "Gacor Rental", 
      rating_produk: 3.0, 
      lokasi_rental: "Mulyorejo"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Container(
        decoration: BoxDecoration(
          color: Color(0xFFE5ECF0)
        ),
        child: Drawer(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Filter",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.black
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Jarak",
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 237,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          decoration: InputDecoration(
                            hintText: "MAKS",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Harga",
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.black
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 237,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          decoration: InputDecoration(
                            hintText: "MIN",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 237,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          decoration: InputDecoration(
                            hintText: "MAKS",
                            hintStyle: TextStyle(
                              color: Colors.grey
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFE5ECF0),
      appBar: AppBar(
        backgroundColor: Color(0xFFE5ECF0),
        titleSpacing: 30,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            "Rentalin",
            style: TextStyle(
              fontFamily: "Coolvetica",
              fontWeight: FontWeight.w400,
              fontSize: 28,
              color: Color(0xFF001F3F),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 14.0),
            child: Icon(
              Icons.doorbell_outlined,
              size: 40,
            
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 425,
              height: 5,
              color: Color(0xFFDDDDDD),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#RentalinAja",
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w700,
                      fontSize: 27.47,
                      color: Color(0xFF000000)
                    ),
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Cari & Sewa Kendaraan Murah",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.25,
                      color: Color(0xFF000000)
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 308,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                            Color(0xFF001F3F),
                            Color(0xFF0F6D79),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [BoxShadow(
                            color: Color(0x50000000),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, 0)
                          )]
                        ),
                        child: TextField(
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 16.25
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.white
                              ),
                            ),
                            hintText: "Mau Kemana",
                            hintStyle: TextStyle(
                              color: Colors.white
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Container(
                        width: 48,
                        height: 51,
                        decoration: BoxDecoration(
                          color: Color(0xFF0F6D79),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [BoxShadow(
                            color: Color(0x50000000),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: Offset(0, 0)
                          )]
                        ),
                        child: IconButton(
                          onPressed: (){
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                            size: 30,
                          )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Terdekat",
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontWeight: FontWeight.w700,
                      fontSize: 20
                    ),
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: [
                      Container(
                        width: 500,
                        height: 545,
// DISINI CAN

                        child: ListView.builder(
                          itemCount: rentalItems.length,
                          itemBuilder: (context, index) {
                            return RentalItemCard(
                              item: rentalItems[index]
                            );
                          }
                        )
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}