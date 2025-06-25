import 'package:rentalin_project/penyewa_pages/mulaiRental_page.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
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
              Container(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFFD9D9D9),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 0,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Muhammad Yusran",
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
                                "ID : 187231054",
                                style: TextStyle(
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 10,
                                  color: Colors.white
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Colors.white,
                            size: 40,
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        width: 305,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Color(0xFF00BCD4),
                          borderRadius: BorderRadius.circular(20)
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(width: 13),
                          Text(
                            "100%",
                            style: TextStyle(
                              fontFamily: 'Sora',
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.white
                            ),
                          ),
                          SizedBox(width: 156),
                          Text(
                            "10/10 data profil terisi",
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
              SizedBox(height: 25),
              GestureDetector(
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
                          Icons.monetization_on_outlined,
                          color: Color(0xFF001F3F),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Riwayat Transaksi",
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
              SizedBox(height: 5),
              GestureDetector(
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
                          Icons.question_mark_rounded,
                          color: Color(0xFF001F3F),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Pusat Bantuan",
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
              SizedBox(height: 5),
              GestureDetector(
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
                          Icons.perm_phone_msg_outlined,
                          color: Color(0xFF001F3F),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Customer Service",
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
              SizedBox(height: 320),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MulaiRentalPage())
                      );
                    },
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