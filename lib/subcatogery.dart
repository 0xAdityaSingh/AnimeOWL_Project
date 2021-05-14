import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubCategoryText extends StatelessWidget {
  const SubCategoryText({
    Key key,
    this.text,
    this.padding,
  }) : super(key: key);

  final String text;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          // style: GoogleFonts.montserrat(
          color: Theme.of(context).accentColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          // letterSpacing: 0.5,
        ),
      ),
    );
  }
}
