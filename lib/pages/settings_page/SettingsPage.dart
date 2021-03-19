import 'package:animetv/pages/settings_page/ClearCacheSetting.dart';
import 'package:animetv/pages/settings_page/DoubleTapDurationSetting.dart';
import 'package:animetv/pages/settings_page/PlaybackSpeedSetting.dart';
import 'package:animetv/pages/settings_page/ResetFavouritesSetting.dart';
import 'package:animetv/pages/settings_page/ResetRecentlyWatchedSetting.dart';
import 'package:animetv/pages/settings_page/ResetToWatchSetting.dart';
import 'package:animetv/pages/settings_page/SettingsCategory.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: [
            SizedBox(height: 4.0),
            SettingsCategory(title: 'Data'),
            ResetRecentlyWatchedSetting(),
            ResetToWatchSetting(),
            ResetFavouritesSetting(),
            ClearCacheSetting(),
            SettingsCategory(title: 'Player'),
            PlaybackSpeedSetting(),
            DoubleTapDurationSetting(),
          ],
        ),
      ),
    );
  }
}
