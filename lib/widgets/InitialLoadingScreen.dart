import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialLoadingScreen extends StatelessWidget {
  const InitialLoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            // color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Anime',
                  style: GoogleFonts.shadowsIntoLight(
                      fontWeight: FontWeight.w900,
                      fontSize: 50,
                      color: Colors.white),
                ),
                Text(
                  '.',
                  style: GoogleFonts.shadowsIntoLight(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.amber[800]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
