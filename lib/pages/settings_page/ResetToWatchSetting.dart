import 'package:animetv/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetToWatchSetting extends StatefulWidget {
  const ResetToWatchSetting({Key key}) : super(key: key);

  @override
  _ResetToWatchSettingState createState() => _ResetToWatchSettingState();
}

class _ResetToWatchSettingState extends State<ResetToWatchSetting> {
  void showConfirmationSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'To watch list cleared!',
        style: GoogleFonts.montserrat(),
      ),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.read(toWatchProvider);
    return ListTile(
      title: Text(
        'Reset To Watch list',
        style: GoogleFonts.montserrat(),
      ),
      subtitle: Text(
        'Clear to watch animes',
        style: GoogleFonts.montserrat(),
      ),
      trailing: IconButton(
        icon: Icon(Icons.restore),
        onPressed: provider.hasData()
            ? () => setState(() {
                  provider.clearData();
                  showConfirmationSnackbar();
                })
            : null,
      ),
    );
  }
}
