import 'dart:convert';

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
    var response = await Dio().get(
      'http://52.66.198.139:8080/api/v1/video?url=' + widget.path,
    );
    // print("hiii");
    // print(response.statusCode);
    var jsonData = jsonDecode(response.data);
    print(jsonData[0]);
    return jsonData[0];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Container(),
      backgroundColor: Colors.black,
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
