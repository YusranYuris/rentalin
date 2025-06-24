import 'package:flutter/material.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pesanan Saya",
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
          color: Color(0xFFE5ECF0),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 17.0, right: 17, top: 10) ,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 146,
                    height: 30,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF00BCD4),
                        width: 1.5
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 7, right: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Semua Status",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF0F6D79)
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Color(0xFF0F6D79),
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10),
              Container(
                width: 365,
                height: 142,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.motorcycle_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Motor",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black
                                ),
                              ),
                              Text(
                                "17 Agustus 2025",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0x60000000)
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 107),
                          Container(
                            width: 118,
                            height: 23,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                Color(0xFF0F6D79),
                                Color(0xFF00BCD4),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.5),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Belum Bayar",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.white
                                ),
                              ),
                            ),

                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 350,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Color(0xFFB0BEC5)
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              'assets/images/iqbal_rental.png',
                              width: 30,
                              height: 30,  
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ducati Superleggera 1300cc",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black
                                ),
                              ),
                              Text(
                                "Iqbal Rental",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0x40000000)
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Harga",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8,
                                  color: Color(0x40000000)
                                ),
                              ),
                              Text(
                                "Rp550.000",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF000000)
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 186),
                          Container(
                            width: 72,
                            height: 23,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF00BCD4),
                                width: 1.2
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Rental Lagi",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0xFF0F6D79)
                                ),
                              ), 
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 365,
                height: 142,
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.motorcycle_outlined,
                            color: Colors.black,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Motor",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black
                                ),
                              ),
                              Text(
                                "17 Agustus 2025",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0x60000000)
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 107),
                          Container(
                            width: 118,
                            height: 23,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                Color(0xFF0F6D79),
                                Color(0xFF00BCD4),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3.5),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Belum Bayar",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: Colors.white
                                ),
                              ),
                            ),

                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 350,
                        height: 1,
                        decoration: BoxDecoration(
                          color: Color(0xFFB0BEC5)
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              'assets/images/iqbal_rental.png',
                              width: 30,
                              height: 30,  
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ducati Superleggera 1300cc",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black
                                ),
                              ),
                              Text(
                                "Iqbal Rental",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0x40000000)
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Harga",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8,
                                  color: Color(0x40000000)
                                ),
                              ),
                              Text(
                                "Rp550.000",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFF000000)
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 127.9),
                          Container(
                            width: 49,
                            height: 23,
                            decoration: BoxDecoration(
                              color: Color(0xFF001F3F)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Ulas",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0xFFFFFFFF)
                                ),
                              ), 
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 72,
                            height: 23,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF00BCD4),
                                width: 1.2
                              )
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                textAlign: TextAlign.center,
                                "Rental Lagi",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: Color(0xFF0F6D79)
                                ),
                              ), 
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}