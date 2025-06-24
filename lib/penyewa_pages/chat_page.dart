import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 6.0),
          child: Text(
            "Chat",
            style: TextStyle(
              fontFamily: 'Sora',
              fontWeight: FontWeight.w700,
              fontSize: 20
            ),
          ),
        ),
        backgroundColor: Color(0xFFE5ECF0),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(0xFFE5ECF0),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
              title: Text(
                "Muhammad Yusran",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF000000)
                ),
              ),
              subtitle: Text(
                "Halo",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
              ),
              trailing: Text(
                "08.49",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(top: 0, left: 20, right: 20),
              title: Text(
                "Rudi Motor",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF000000)
                ),
              ),
              subtitle: Text(
                "Terima Kasih",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
              ),
              trailing: Text(
                "Kemarin",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(top: 0, left: 20, right: 20),
              title: Text(
                "Affan Fathir",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF000000)
                ),
              ),
              subtitle: Text(
                "Baik",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
              ),
              trailing: Text(
                "07/11/24",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(top: 0, left: 20, right: 20),
              title: Text(
                "JC Motor Rental",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF000000)
                ),
              ),
              subtitle: Text(
                "Oke",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Color(0xFFD9D9D9),
              ),
              trailing: Text(
                "10/06/23",
                style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Color(0xFF000000)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}