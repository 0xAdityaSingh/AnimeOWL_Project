import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarText extends StatelessWidget {
  const AppbarText({Key key, this.custom = 'AnimeOWL'}) : super(key: key);

  final String custom;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Container(
        //   // color: Colors.black,
        //   height: 35,
        //   width: 60,
        //   decoration: new BoxDecoration(
        //     image: new DecorationImage(
        //       image: new AssetImage("assets/main.png"),
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // ),
        SizedBox(
          width: 10,
        ),
        Text(
          'Anime',
          style: GoogleFonts.shadowsIntoLight(
              fontWeight: FontWeight.w900, fontSize: 30, color: Colors.white),
        ),
        Text(
          'OWL',
          style: GoogleFonts.shadowsIntoLight(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.amber[800]),
        ),
      ],
    );
  }
}
