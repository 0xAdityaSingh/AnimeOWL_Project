import 'dart:convert';
// import 'package:better_player/better_player.dart';

import 'package:animetv/video_items.dart';
import 'package:better_player/better_player.dart';
// import 'package:better_player/better_player.dart';
// import 'package:custom_chewie/custom_chewie.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
// import 'package:video_player/video_player.dart';

import 'package:wakelock/wakelock.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetVideo extends StatefulWidget {
  final name;
  final img;
  final path;
  GetVideo({Key key, this.path, this.name, this.img}) : super(key: key);

  @override
  _GetVideoState createState() => _GetVideoState();
}

class _GetVideoState extends State<GetVideo> {
  BetterPlayerController _betterPlayerController;
  String server = "Change to Server 2";
  String myurl;
  // bool _isKeptOn = false;
  Future<List<String>> getVideos() async {
    String temp = widget.path;
    temp = temp.replaceAll('/ep', '-episode-');
    temp = temp.replaceAll('/v1/', '/');
    temp = temp.replaceAll('v1/', '/');

// temp = temp.replaceAll('/v1/', '');
//     temp = temp.replaceAll('v1/', '');
    // print("temp: " + temp);
    // print('gogoanime.vc/' + temp);

    // var response = await Dio().get('https://gogo-play.net/videos/' + temp);

    // String str = response.toString();

    // const start = '//streamani.net/streaming.php?id=';
    // const end = '&title=';
    // final startIndex = str.indexOf(start);

    // final endIndex = str.indexOf(end, startIndex + start.length);
    // String id = str.substring(startIndex + start.length, endIndex);
    // print("hiii");
    // print(id);
    var response = await Dio().get(
      'https://www1.gogoanime.ai/' + temp,
    );
    String str = response.toString();

    const start = 'https://check.gogo-play.net/anime.php?id=';
    const end = '&type=[';
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    String id = str.substring(startIndex + start.length, endIndex);

    var response2 = await Dio().get("https://gogo-play.net/ajax.php?id=" + id);
    //all data https://streamani.net/download?id=

    // print(response2.statusCode);
    // print('myurl:::::' + id);
    var jsonData = jsonDecode(response2.data);
    // print('jsonData:' + " " + jsonData.toString());
    String last = jsonData['source'][0]['file'];
    // print(jsonData['source_bk'][0]);
    String last1 = jsonData['source_bk'][0]['file'];

    List<String> tempoo = [last, last1];
    // print('myurl::' + last);
    // print('myurl:::' + last1);
    // myurl = last1;
    // setState(() {
    //   myurl = last;
    // });
    return tempoo;
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    _betterPlayerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
          future: getVideos(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  // backgroundColor: ,
                  color: Theme.of(context).accentColor,
                ),
              );
            } else {
              // myurl = snapshot.data[0];
              if (myurl == null) {
                myurl = snapshot.data[0];
              }
              print("myurl:" + myurl);
              BetterPlayerConfiguration betterPlayerConfiguration =
                  BetterPlayerConfiguration(
                controlsConfiguration: BetterPlayerControlsConfiguration(
                  enableFullscreen: true,
                  enablePlayPause: true,
                  progressBarBackgroundColor: Theme.of(context).accentColor,
                  playIcon: Icons.play_arrow,
                  enableProgressBarDrag: true,
                ),
                allowedScreenSleep: false,
                fullScreenByDefault: true,
                aspectRatio: 16 / 9,
              );
              BetterPlayerDataSource dataSource = BetterPlayerDataSource(
                  BetterPlayerDataSourceType.network, myurl);
              _betterPlayerController =
                  BetterPlayerController(betterPlayerConfiguration);
              _betterPlayerController.setupDataSource(dataSource);
              return Stack(
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              color: Colors.white,
                              child: BetterPlayer(
                                  controller: _betterPlayerController)
                              // child: BetterPlayerListVideoPlayer(
                              //   // BetterPlayerConfiguration(),
                              //   BetterPlayerDataSource(
                              //     BetterPlayerDataSourceType.network,
                              //     myurl,
                              //     notificationConfiguration:
                              //         BetterPlayerNotificationConfiguration(
                              //       showNotification: true,
                              //       title: widget.name,
                              //       imageUrl: widget.img,
                              //       activityName: "MainActivity",
                              //     ),
                              //   ),
                              // configuration: BetterPlayerConfiguration(
                              //   controlsConfiguration:
                              //       BetterPlayerControlsConfiguration(
                              //     enableFullscreen: true,
                              //     enablePlayPause: true,
                              //     progressBarBackgroundColor:
                              //         Theme.of(context).accentColor,
                              //     playIcon: Icons.play_arrow,
                              //     enableProgressBarDrag: true,
                              //   ),
                              //   // showPlaceholderUntilPlay: true,
                              //   autoDispose: false,
                              //   allowedScreenSleep: false,

                              //   fullScreenByDefault: true,
                              //   aspectRatio: 16 / 9,
                              // ),
                              // ),
                              ),
                          RaisedButton(
                              color: Theme.of(context).accentColor,
                              child: Text(
                                server,
                                style: GoogleFonts.montserrat(
                                    // fontWeight: FontWeight.bold,
                                    // fontSize: 15.0,
                                    ),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (myurl == snapshot.data[0]) {
                                    setState(() {
                                      myurl = snapshot.data[1];
                                      server = "Change to Server 1";
                                    });
                                  } else {
                                    // print("Heeeeee");
                                    setState(() {
                                      myurl = snapshot.data[0];
                                      server = "Change to Server 2";
                                    });
                                  }
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 25.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 30.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
