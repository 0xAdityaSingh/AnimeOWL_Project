import 'package:animetv/providers.dart';
import 'package:animetv/providers/settings/PlaybackSpeedProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class PlaybackSpeedSetting extends StatefulWidget {
  PlaybackSpeedSetting({Key key}) : super(key: key);

  @override
  PlaybackSpeedSettingState createState() => PlaybackSpeedSettingState();
}

class PlaybackSpeedSettingState extends State<PlaybackSpeedSetting> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var speedProv = watch(playbackSpeeedProvider);
        return ListTile(
          title: Text(
            'Playback speed',
            style: GoogleFonts.montserrat(),
          ),
          // subtitle: Text('Video go brrr...'),
          trailing: DropdownButton<double>(
            onChanged: (value) {
              speedProv.updateValue(value);
            },
            underline: Container(),
            value: speedProv.value,
            dropdownColor: Theme.of(context).cardColor,
            items: PlaybackSpeedProvider.POSSIBLE_SPEEDS.map(
              (double e) {
                return DropdownMenuItem<double>(
                  value: e,
                  child: Text(
                    '${e}x',
                    style: GoogleFonts.montserrat(),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}
