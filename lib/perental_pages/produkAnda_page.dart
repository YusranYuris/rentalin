import 'package:flutter/material.dart';

class ProdukAndaPage extends StatelessWidget{
  const ProdukAndaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [
              Color(0xFF064C55),
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 25),
            child: Container(
              // color: Colors.black,
              child: ListView(
                children: [
                  _stokRental('assets/images/iqbal_rental.png', "Iqbal Rental", "4.7", "Ducati Superleggera 1300cc", "110000 km", "UNAIR C", "75.000"),
                  SizedBox(height: 10),
                  _stokRental('assets/images/iqbal_rental.png', "Iqbal Rental", "4.7", "Ducati Superleggera 1300cc", "110000 km", "UNAIR C", "75.000"),
                  SizedBox(height: 10),
                  _stokRental('assets/images/iqbal_rental.png', "Iqbal Rental", "4.7", "Ducati Superleggera 1300cc", "110000 km", "UNAIR C", "75.000"),
                  SizedBox(height: 10),
                  _stokRental('assets/images/iqbal_rental.png', "Iqbal Rental", "4.7", "Ducati Superleggera 1300cc", "110000 km", "UNAIR C", "75.000"),
                  SizedBox(height: 10),
                  _stokRental('assets/images/iqbal_rental.png', "Iqbal Rental", "4.7", "Ducati Superleggera 1300cc", "110000 km", "UNAIR C", "75.000"),
                  SizedBox(height: 10),
                  _stokRental('assets/images/iqbal_rental.png', "Iqbal Rental", "4.7", "Ducati Superleggera 1300cc", "110000 km", "UNAIR C", "75.000"),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}

Widget _stokRental(String assetPath, String namaRental, String rating, String motor, String jarak, String terdekat, String harga){
  return Container(
    width: double.infinity,
    height: 289,
    color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              assetPath,
              width: 330,
              height: 201,
              fit: BoxFit.cover, 
            ),
          ),
          SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                namaRental,
                style: TextStyle(
                  fontFamily: "Sora",
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black
                ),
              ),
              SizedBox(width: 163),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 15,
                      ),
                      Text(
                        rating,
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontWeight: FontWeight.w600,
                          fontSize: 10
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.price_change,
                        color: Colors.black,
                        size: 13,
                      ),
                      Text(
                        "Rp$harga/hari",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontWeight: FontWeight.w400,
                          fontSize: 8,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motor,
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w300,
                      fontSize: 8,
                      color: Colors.black
                    ),
                  ),
                  Text(
                    jarak,
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w300,
                      fontSize: 8,
                      color: Colors.black
                    ),
                  ),
                  Text(
                    terdekat,
                    style: TextStyle(
                      fontFamily: "Sora",
                      fontWeight: FontWeight.w300,
                      fontSize: 8,
                      color: Colors.black
                    ),
                  ),
                ],
              ),
              SizedBox(width: 73),
              Container(
                width: 49,
                height: 23,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.64),
                  color: Color(0xFF001F3F),
                ),
                child: Text(
                  "Edit",
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Colors.white
                  ),
                ),
              ),
              SizedBox(width: 5),
              Container(
                width: 72,
                height: 23,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.64),
                  color: Color(0xFFFFFFFF),
                  border: Border.all(
                    color: Color(0xFF00BCD4),
                    width: 1.2
                  )
                ),
                child: Text(
                  "Tersedia",
                  style: TextStyle(
                    fontFamily: "Sora",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Color(0xFF0F6D79)
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}