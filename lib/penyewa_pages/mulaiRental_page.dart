import 'package:rentalin_project/perental_pages/daftarPerental_page.dart';
import 'package:rentalin_project/perental_pages/homePerental_page.dart';
import 'package:flutter/material.dart';

class MulaiRentalPage extends StatefulWidget{
  const MulaiRentalPage({super.key});

  @override
  State<MulaiRentalPage> createState() => _MulaiRentalPageState();
}

class _MulaiRentalPageState extends State<MulaiRentalPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final disabledColor = Colors.grey.shade400;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF064C55),
              Color(0xFF001F3F),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#RentalinAja",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w700,
                        fontSize: 27.47,
                        color: Color(0xFFFFFFFF)
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Cari & Sewa Kendaraan Mudah",
                      style: TextStyle(
                        fontFamily: "Sora",
                        fontWeight: FontWeight.w400,
                        fontSize: 16.25,
                        color: Color(0xFFFFFFFF)
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFE5ECF0),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Syarat dan Ketentuan",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w700,
                              fontSize: 16.25,
                              color: Color(0xFF001F3F)
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Dengan mendaftar sebagai Penyedia Rental di aplikasi Rentalin, Anda menyetujui untuk mematuhi syarat dan ketentuan berikut:",
                        style: TextStyle(
                          fontFamily: "Sora",
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                          color: Color(0xFF000000)
                        ),
                      ),
                      _sectionTitle("1. Kendaraan yang Disewakan"),
                      _bullet("Kendaraan harus dalam kondisi prima, bersih, dan laik jalan."),
                      _bullet("Memiliki dokumen kendaraan lengkap: STNK aktif, bukti pajak, dan asuransi (jika ada)."),
                      _bullet("Tidak sedang dalam status sitaan, jaminan kredit bermasalah, atau sengketa hukum."),
                      SizedBox(height: 12),
                      _sectionTitle("2. Tanggung Jawab Penyedia"),
                      _bullet("Menjaga kondisi kendaraan selama masa kerja sama."),
                      _bullet("Memberikan informasi yang jujur dan transparan terkait spesifikasi dan kondisi kendaraan."),
                      _bullet("Bertanggung jawab atas pemeliharaan rutin kendaraan."),
                      _bullet("Merespons permintaan penyewa secara profesional dan tepat waktu."),
                      SizedBox(height: 12),
                      _sectionTitle("3. Pembayaran dan Komisi"),
                      _bullet("Penyedia rental setuju dengan sistem pembagian hasil dan/atau komisi yang ditetapkan oleh Rentalin."),
                      _bullet("Pembayaran akan diproses sesuai dengan ketentuan dan waktu yang telah disepakati."),
                      SizedBox(height: 12),
                      _sectionTitle("4. Larangan"),
                      _bullet("Menyewakan kendaraan yang tidak dimiliki atau tidak diizinkan secara hukum."),
                      _bullet("Mengunggah informasi atau gambar kendaraan palsu/tidak sesuai kenyataan."),
                      _bullet("Melanggar hukum yang berlaku dalam aktivitas penyewaan."),
                      SizedBox(height: 12),
                      _sectionTitle("5. Perubahan Ketentuan"),
                      _bullet("Rentalin berhak mengubah syarat dan ketentuan ini sewaktu-waktu dengan pemberitahuan sebelumnya."),
                      SizedBox(height: 20),

                      InkWell(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          children: [
                            Icon(
                              isChecked ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isChecked ? Color(0xFF656565) : Color(0xFFFFFFFF),
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                "Saya telah membaca, memahami, dan menyetujui seluruh Syarat dan Ketentuan yang berlaku.",
                                style: TextStyle(
                                  color: Color(0xFF6B8490),
                                  fontFamily: "Sora",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: isChecked
                          ? () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => DaftarPerentalPage()), 
                            );
                          }
                          : null,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: isChecked ?
                              LinearGradient(
                                colors: [
                                  Color(0xFF0F6D79),
                                  Color(0xFF00BCD4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight
                              )
                              : null,
                            color: isChecked ? null : disabledColor
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Daftar Sebagai Penyedia Rental",
                            style: TextStyle(
                              fontFamily: "Sora",
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xFFFFFFFF)
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _sectionTitle(String text){
  return Text(
    text,
    style: TextStyle(
      fontFamily: "Sora",
      fontWeight: FontWeight.w300,
      fontSize: 11,
      color: Color(0xFF000000)
    ),
  );
}

Widget _bullet(String text){
  return Padding(
    padding: const EdgeInsets.only(left: 12.0, top: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "•",
          style: TextStyle(
            fontSize: 11
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: "Sora",
              fontWeight: FontWeight.w300,
              fontSize: 11,
              color: Color(0xFF000000)
            ),
          )
        )
      ],
    ),
  );
}