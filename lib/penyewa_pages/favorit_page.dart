import 'package:flutter/material.dart';

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorit",
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 10,
              childAspectRatio: 3/5
          
            ),
            children: [
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
                  ), 
                ),
              ),
              Container(
                width: 175,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  child: Container(
                    width: 157,
                    height: 271,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/iqbal_rental.png',
                            width: 180,
                            height: 199,  
                          ),
                        ),
                        Text(
                          "Super Rental",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Vespa Kuning 7000cc",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "11 km",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          "Dekat Tunjungan Plaza",
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w300,
                            fontSize: 8,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.price_change_outlined
                            ),
                            Text(
                              "Rp75.000/hari",
                              style: TextStyle(
                                fontFamily: 'Sora',
                                fontWeight: FontWeight.w400,
                                fontSize: 8,
                                color: Colors.black
                          ),
                            )
                          ],
                        )
                      ],
                    ),
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