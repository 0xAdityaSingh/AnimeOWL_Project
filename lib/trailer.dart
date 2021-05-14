import 'package:animetv/Model/info.dart';
// import 'package:animetv/models/kitsu/KitsuModel.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchTrailerButton extends StatelessWidget {
  final Information kitsuModel;

  WatchTrailerButton({
    Key key,
    this.kitsuModel,
  }) : super(key: key);

  Future launchTrailer(String link) async {
    if (link != null) await launch(link);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 25.0,
        bottom: 20.0,
      ),
      child: ElevatedButton(
        onPressed: () {
          launchTrailer(kitsuModel.trailerUrl);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8.0,
            ),
          ),
          primary: Colors.amber[800],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow,
              size: 30.0,
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              'Watch Trailer',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
