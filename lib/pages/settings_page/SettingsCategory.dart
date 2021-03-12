import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsCategory extends StatelessWidget {
  const SettingsCategory({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).accentColor,
        ),
        // style: GoogleFonts.montserrat(
        //   color: Theme.of(context).accentColor,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }
}
