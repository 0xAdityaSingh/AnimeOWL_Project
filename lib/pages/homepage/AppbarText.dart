import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppbarText extends StatelessWidget {
  const AppbarText({Key key, this.custom = 'twist'}) : super(key: key);

  final String custom;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Anime',
          style: GoogleFonts.shadowsIntoLight(
              fontWeight: FontWeight.w900, fontSize: 30, color: Colors.white),
        ),
        Text(
          '.',
          style: GoogleFonts.shadowsIntoLight(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.amber[800]),
        ),
      ],
    );
  }
}
