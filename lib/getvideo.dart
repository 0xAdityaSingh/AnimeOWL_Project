import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animetv/video_items.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class GetVideo extends StatefulWidget {
  final path;
  GetVideo({Key key, this.path}) : super(key: key);

  @override
  _GetVideoState createState() => _GetVideoState();
}

class _GetVideoState extends State<GetVideo> {
  Future<String> getVideos() async {
    String temp = widget.path;
    temp = temp.replaceAll('/ep', '-episode-');
    temp = temp.replaceAll('/v1/', '/');
    temp = temp.replaceAll('v1/', '/');

    print("temp: " + temp);

    var response = await Dio().get(
      'https://www1.gogoanime.ai' + temp,
    );
    String str = response.toString();

    const start = 'https://check.gogo-play.net/anime.php?id=';
    const end = '&type=[';
    final startIndex = str.indexOf(start);
    final endIndex = str.indexOf(end, startIndex + start.length);
    String id = str.substring(startIndex + start.length, endIndex);
    var response2 = await Dio().get(
      "https://gogo-play.net/ajax.php?id=" + id,
    );
    var jsonData = jsonDecode(response2.data);

    String last = jsonData['source'][0]['file'];
    return last;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // body: Center(
      //   child: RaisedButton(
      //     onPressed: () async {
      //       await getVideos();
      //     },
      //   ),
      // )
      body: FutureBuilder(
          future: getVideos(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ChewieListItem(
                // videoPlayerController: VideoPlayerController.network(
                //   snapshot.data,
                // ),

                videoPlayerController: VideoPlayerController.network(
                  snapshot.data,
                ),
                // looping: true,
                // autoplay: true,
              );
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      // ),
    );
  }
}
