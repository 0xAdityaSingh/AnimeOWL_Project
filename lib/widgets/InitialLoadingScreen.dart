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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 110,
                  width: 180,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new AssetImage("assets/main.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Anime',
                      style: GoogleFonts.shadowsIntoLight(
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    Text(
                      'OWL',
                      style: GoogleFonts.shadowsIntoLight(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.amber[800]),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
