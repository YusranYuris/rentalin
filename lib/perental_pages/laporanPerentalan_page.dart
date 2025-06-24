import 'package:flutter/material.dart';

class LaporanPerentalanPage extends StatefulWidget{
  const LaporanPerentalanPage({super.key});

  @override
  State<LaporanPerentalanPage> createState() => _LaporanPerentalanPageState();
}

class LaporanRentalItem {
  final String tipe_kendaraan;
  final String tanggal_pemesanan;
  final String gambar_produk;
  final String nama_rental;
  final String nama_kendaraan;
  final String seri_kendaraan;
  final int tahun_kendaraan;
  final int harga_produk;
  final String status_pemesanan;

  LaporanRentalItem({
    required this.tipe_kendaraan,
    required this.tanggal_pemesanan,
    required this.gambar_produk,
    required this.nama_rental,
    required this.nama_kendaraan,
    required this.seri_kendaraan,
    required this.tahun_kendaraan,
    required this.harga_produk,
    required this.status_pemesanan,
  });
}


class LaporanRentalItemCard extends StatelessWidget{
  final LaporanRentalItem item;

  const LaporanRentalItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext){
    return Column(
      children: [
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
                          item.tipe_kendaraan,
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          item.tanggal_pemesanan,
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
                      width: 111,
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
                          item.status_pemesanan,
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
                        item.gambar_produk,
                        width: 30,
                        height: 30,  
                      ),
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nama_kendaraan + " " + item.seri_kendaraan + " " + item.tahun_kendaraan.toString(),
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Colors.black
                          ),
                        ),
                        Text(
                          item.nama_rental,
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
                          "Rp" + item.harga_produk.toString(),
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
                      width: 69,
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
                          "Chat",
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
        SizedBox(height: 24)
      ],
    );
  }
}

class _LaporanPerentalanPageState extends State<LaporanPerentalanPage> {
  final List<LaporanRentalItem> laporanRentalItems = [
    LaporanRentalItem(
    tipe_kendaraan: "Motor",
    tanggal_pemesanan: "17 Agustus 2025",
    gambar_produk: 'assets/images/iqbal_rental.png', 
    nama_rental: "Haji Rental", 
    nama_kendaraan: "Vario", 
    seri_kendaraan: "160", 
    tahun_kendaraan: 2025, 
    harga_produk: 170000, 
    status_pemesanan: "Selesai"
    ),
    LaporanRentalItem(
      tipe_kendaraan: "Mobil", 
      tanggal_pemesanan: "20 Agustus 2025", 
      gambar_produk: 'assets/images/iqbal_rental.png', 
      nama_rental: "Haji Rental", 
      nama_kendaraan: "Pajero", 
      seri_kendaraan: "Dakar", 
      tahun_kendaraan: 2015, 
      harga_produk: 500000, 
      status_pemesanan: "Belum Bayar"
    )
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: ListView.builder(
                itemCount: laporanRentalItems.length,
                itemBuilder: (context, index) {
                  return LaporanRentalItemCard(
                    item: laporanRentalItems[index]
                  );
                },
              )
            )
          ),
        ),
      ),
    );
  }
}