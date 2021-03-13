import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentlyWatchedText extends StatelessWidget {
  const RecentlyWatchedText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(
          0.0,
        ),
      ),
      child: Text(
        'Recently Watched',
        style: GoogleFonts.montserrat(
          // letterSpacing: 1.25,
          fontWeight: FontWeight.bold,
          fontSize: 15.0,
        ),
      ),
    );
  }
}
