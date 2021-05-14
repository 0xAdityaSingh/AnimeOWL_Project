import 'dart:convert';

import 'package:animetv/Model/info.dart';
import 'package:animetv/getvideo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:intl/intl.dart';
import 'package:web_scraper/web_scraper.dart';

class GetEpisodes extends StatefulWidget {
  final path;
  GetEpisodes({Key key, this.path}) : super(key: key);

  @override
  _GetEpisodesState createState() => _GetEpisodesState();
}

class _GetEpisodesState extends State<GetEpisodes> {
  @override
  Widget build(BuildContext context) {
    Future<List<int>> getEpisodes() async {
      final rawUrl = 'https://animixplay.to/' + widget.path;
      final webScraper = WebScraper('https://animixplay.to');
      final endpoint = rawUrl.replaceAll(r'https://animixplay.to', '');
      if (await webScraper.loadWebPage(endpoint)) {
        final titleElements = webScraper.getElement('#epslistplace', []);
        // final titlevid = webScraper.getElement('body > div.playerpage', []);
        String str = titleElements[0]['title'];
        const start = '{"eptotal":';
        const end = ',"0"';
        final startIndex = str.indexOf(start);
        final endIndex = str.indexOf(end, startIndex + start.length);

        int enumber =
            int.parse(str.substring(startIndex + start.length, endIndex));
        print("Enumber: " + enumber.toString());
        var list = new List<int>.generate(enumber, (i) => i + 1);
        return list;
      }
    }

    return Scaffold(
        //  child: child,
        body: Column(children: [
      SizedBox(
        height: 40,
      ),
      Text("Episodes"),
      FutureBuilder(
          future: getEpisodes(),
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Container(
                        height: 50,
                        child:
                            Center(child: Text('EP ${snapshot.data[index]}')),
                      ),
                      onTap: () {
                        if (snapshot.data[index] == 1) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  GetVideo(path: widget.path)));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GetVideo(
                                  path: widget.path +
                                      "/ep" +
                                      snapshot.data[index].toString())));
                        }
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              );
            }
          }),
    ]));
  }
}
