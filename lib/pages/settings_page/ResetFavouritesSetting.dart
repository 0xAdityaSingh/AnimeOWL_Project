import 'package:animetv/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetFavouritesSetting extends StatefulWidget {
  const ResetFavouritesSetting({Key key}) : super(key: key);

  @override
  _ResetFavouritesSettingState createState() => _ResetFavouritesSettingState();
}

class _ResetFavouritesSettingState extends State<ResetFavouritesSetting> {
  void showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Favourited anime cleared!',
        style: GoogleFonts.montserrat(),
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read(favouriteAnimeProvider);
    return ListTile(
      title: Text(
        'Reset Favourited animes',
        style: GoogleFonts.montserrat(),
      ),
      subtitle: Text(
        'Clear your favourite animes',
        style: GoogleFonts.montserrat(),
      ),
      trailing: IconButton(
        icon: Icon(Icons.restore),
        onPressed: provider.hasData()
            ? () => setState(() {
                  provider.clearFavourites();
                  showConfirmationSnackbar();
                })
            : null,
      ),
    );
  }
}
