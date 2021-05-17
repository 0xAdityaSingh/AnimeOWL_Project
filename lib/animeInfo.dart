import 'dart:convert';

import 'package:animetv/trailer.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

// import 'package:provider/provider.dart';
import 'package:web_scraper/web_scraper.dart';

import 'Model/info.dart';
import 'Model/recently_watched.dart';
import 'addss.dart';
import 'getvideo.dart';

// String path;

class AnimeInfo extends StatefulWidget {
  @override
  final malID;
  final url;
  AnimeInfo({Key key, this.malID, this.url}) : super(key: key);

  @override
  _AnimeInfoState createState() => _AnimeInfoState();
}

class _AnimeInfoState extends State<AnimeInfo> {
  void initState() {
    super.initState();
    FBAd.initialize();
    FBAd.loadInterstitialAd();
  }

  int ic_change = 0;
  int episodenumber = 0;
  int depisodenumber = 0;
  ScrollController _scrollController;
  // ScrollController _placeholderController;
  final offsetProvider = StateProvider<double>((ref) {
    return 0.0;
  });
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    Future<void> saveRecent(RecentlyWatched movieTable) async {
      final movieBox = await Hive.openBox('recentbox');
      await movieBox.put(movieTable.malId, movieTable);
    }

    Future<void> deleteRecent(int movieId) async {
      final movieBox = await Hive.openBox('recentbox');
      await movieBox.delete(movieId);
    }

    Future<bool> checkIfRecent(int movieId) async {
      final movieBox = await Hive.openBox('recentbox');
      return movieBox.containsKey(movieId);
      // return movieBox.get(movieId);
    }

    Future<RecentlyWatched> getRecent(int movieId) async {
      final movieBox = await Hive.openBox('recentbox');
      return movieBox.get(movieId);
      // return movieBox.get(movieId);
    }

    Future<void> saveMovie(RecentlyWatched movieTable) async {
      final movieBox = await Hive.openBox('animebox');
      await movieBox.put(movieTable.malId, movieTable);
    }

    Future<void> deleteMovie(int movieId) async {
      final movieBox = await Hive.openBox('animebox');
      await movieBox.delete(movieId);
    }

    Future<bool> checkIfMovieFavorite(int movieId) async {
      final movieBox = await Hive.openBox('animebox');
      return movieBox.containsKey(movieId);
      // return movieBox.get(movieId);
    }

    Future<RecentlyWatched> getMovieFavorite(int movieId) async {
      final movieBox = await Hive.openBox('animebox');
      return movieBox.get(movieId);
      // return movieBox.get(movieId);
    }

    // Future<List<String>> getFiller() async {
    //   var response = await Dio().get(
    //     'https://api.jikan.moe/v3/anime/' +
    //         widget.malID.toString() +
    //         '/episodes',
    //   );
    //   int num_times = response.data['episodes_last_page'];
    //   List<String> result = [];
    //   for (int i = 1; i <= num_times; i++) {
    //     print(i);
    //     var response = await Dio().get('https://api.jikan.moe/v3/anime/' +
    //         widget.malID.toString() +
    //         '/episodes/' +
    //         i.toString());
    //     var jsonData = response.data['episodes'];

    //     for (var u in jsonData) {
    //       // print(u['episode_id']);
    //       if (u['filler'] == false) {
    //         result.add("");
    //       } else {
    //         result.add("Filler");
    //       }
    //     }
    //   }
    //   // Future<List<String>> getFiller() async {
    //   for (int i = 1; i <= 10; i++) {
    //     result.add("");
    //   }
    //   return result;
    // }

    Future<Information> getInfo() async {
      var response = await http.get(
        Uri.https(
            'animixplay.to', 'assets/mal/' + widget.malID.toString() + '.json'),
      );
      var jsonData = jsonDecode(response.body);
      var u = jsonData;
      bool isfav = await checkIfMovieFavorite(u['mal_id']);

      Information r;
      if (isfav == true) {
        print("Loaded via Fav");
        ic_change = 1;
        // r = await getMovieFavorite(u['malId']);
      }
      bool ans = await checkIfRecent(u['mal_id']);
      if (ans == true) {
        // print("Loaded via Episodes");
        var temp = await getRecent(u['mal_id']);
        episodenumber = temp.enumber;
        depisodenumber = temp.denumber;
      }
      // print("Loaded via API");
      r = Information(
          title: u['title'],
          url: u['url'],
          malId: u['mal_id'],
          image_url: u['image_url'],
          airing: u['airing'],
          synopsis: u['synopsis'],
          trailerUrl: u['trailer_url'],
          enumber: episodenumber,
          denumber: depisodenumber);
      // }

      return r;
    }

    Future<String> getPath() async {
      // print("_url: " + widget.url);
      var headers = {
        'authority': 'animixplay.to',
        'pragma': 'no-cache',
        'cache-control': 'no-cache',
        'user-agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
        'content-type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'sec-gpc': '1',
        'origin': 'https://animixplay.to',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-mode': 'cors',
        'sec-fetch-dest': 'empty',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'cookie':
            '__cfduid=d62877aff882f820d7673deefff480e981618578873; animix_ses=4c3dkieb699d4nkf7bpu6gmba0hne2kkqcdi',
      };
      var data = {'recomended': widget.malID.toString()};
      var response = await http.post(Uri.https('animixplay.to', 'api/search'),
          headers: headers, body: data);
      var jsonData = jsonDecode(response.body);
      // print(jsonData.toString());
      String str = jsonData.toString();
      var re = RegExp(r'(?<=href=\"\/v1)(.*)(?=\"><img class)');
      // String data = "the quick brown fox jumps over the lazy dog";
      var match = re.allMatches(str).toList();
      // var path;
      if (match.length > 1) {
        if (match[0].group(0).contains("-dub")) {
          return "v1" + (match[1].group(0));
        } else {
          return "v1" + (match[0].group(0));
        }
      } else {
        return "v1" + (match[0].group(0));
      }
    }

    Future<List<int>> getEpisode() async {
      // print("_url: " + widget.url);
      var headers = {
        'authority': 'animixplay.to',
        'pragma': 'no-cache',
        'cache-control': 'no-cache',
        'user-agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
        'content-type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'sec-gpc': '1',
        'origin': 'https://animixplay.to',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-mode': 'cors',
        'sec-fetch-dest': 'empty',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'cookie':
            '__cfduid=d62877aff882f820d7673deefff480e981618578873; animix_ses=4c3dkieb699d4nkf7bpu6gmba0hne2kkqcdi',
      };
      var data = {'recomended': widget.malID.toString()};
      var response = await http.post(Uri.https('animixplay.to', 'api/search'),
          headers: headers, body: data);
      var jsonData = jsonDecode(response.body);
      // print(jsonData.toString());
      String str = jsonData.toString();
      var re = RegExp(r'(?<=href=\"\/v1)(.*)(?=\"><img class)');
      // String data = "the quick brown fox jumps over the lazy dog";
      var match = re.allMatches(str).toList();
      var path;
      if (match.length > 1) {
        if (match[0].group(0).contains("-dub")) {
          path = "v1" + (match[1].group(0));
        } else {
          path = "v1" + (match[0].group(0));
        }
      } else {
        path = "v1" + (match[0].group(0));
      }
      final rawUrl = 'https://animixplay.to/' + path;
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

        String temp = str.substring(startIndex + start.length, endIndex);
        int enumber = int.parse(temp.replaceAll(RegExp('[^0-9]'), ''));
        // print("Enumber: " + enumber.toString());
        var list = new List<int>.generate(enumber, (i) => i + 1);
        return list;
      }
    }

    Future<String> getPathDub() async {
      // print("_url: " + widget.url);
      var headers = {
        'authority': 'animixplay.to',
        'pragma': 'no-cache',
        'cache-control': 'no-cache',
        'user-agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
        'content-type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'sec-gpc': '1',
        'origin': 'https://animixplay.to',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-mode': 'cors',
        'sec-fetch-dest': 'empty',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'cookie':
            '__cfduid=d62877aff882f820d7673deefff480e981618578873; animix_ses=4c3dkieb699d4nkf7bpu6gmba0hne2kkqcdi',
      };
      var data = {'recomended': widget.malID.toString()};
      var response = await http.post(Uri.https('animixplay.to', 'api/search'),
          headers: headers, body: data);
      var jsonData = jsonDecode(response.body);
      // print(jsonData.toString());
      String str = jsonData.toString();
      var re = RegExp(r'(?<=href=\"\/v1)(.*)(?=\"><img class)');
      // String data = "the quick brown fox jumps over the lazy dog";
      var match = re.allMatches(str).toList();
      // var path;
      if (match.length > 1) {
        if (match[0].group(0).contains("-dub")) {
          return "v1" + (match[0].group(0));
        } else {
          return "v1" + (match[1].group(0));
        }
      } else {
        return "";
      }
    }

    Future<List<int>> getEpisodesDub() async {
      // print("_url: " + widget.url);
      var headers = {
        'authority': 'animixplay.to',
        'pragma': 'no-cache',
        'cache-control': 'no-cache',
        'user-agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.93 Safari/537.36',
        'content-type': 'application/x-www-form-urlencoded',
        'accept': '*/*',
        'sec-gpc': '1',
        'origin': 'https://animixplay.to',
        'sec-fetch-site': 'same-origin',
        'sec-fetch-mode': 'cors',
        'sec-fetch-dest': 'empty',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'cookie':
            '__cfduid=d62877aff882f820d7673deefff480e981618578873; animix_ses=4c3dkieb699d4nkf7bpu6gmba0hne2kkqcdi',
      };
      var data = {'recomended': widget.malID.toString()};
      var response = await http.post(Uri.https('animixplay.to', 'api/search'),
          headers: headers, body: data);
      var jsonData = jsonDecode(response.body);
      // print(jsonData.toString());
      String str = jsonData.toString();
      var re = RegExp(r'(?<=href=\"\/v1)(.*)(?=\"><img class)');
      // String data = "the quick brown fox jumps over the lazy dog";
      var match = re.allMatches(str).toList();
      var path;
      if (match.length > 1) {
        if (match[0].group(0).contains("-dub")) {
          path = "v1" + (match[0].group(0));
        } else {
          path = "v1" + (match[1].group(0));
        }
      } else {
        return [];
      }

      final rawUrl = 'https://animixplay.to/' + path;
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
        String temp = str.substring(startIndex + start.length, endIndex);
        int enumber = int.parse(temp.replaceAll(RegExp('[^0-9]'), ''));
        var list = new List<int>.generate(enumber, (i) => i + 1);
        return list;
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            // height: 300,
            child: FutureBuilder(
              future: Future.wait([
                getInfo(),
                getPath(),
                getPathDub(),
                getEpisode(),
                getEpisodesDub(),
                // getFiller()
              ]),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return SafeArea(
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Card(
                                color: HexColor("#191919"),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AutoSizeText(
                                    snapshot.data[0].title,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    minFontSize: 20.0,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: WatchTrailerButton(
                                    kitsuModel: snapshot.data[0],
                                  ),
                                ),
                                Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.amber[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        8.0,
                                      ),
                                    ),
                                  ),
                                  height: 55,
                                  margin: EdgeInsets.only(
                                    // left: 16.0,
                                    right: 16.0,
                                    top: 25.0,
                                    bottom: 20.0,
                                  ),
                                  child: IconButton(
                                      icon: ic_change == 0
                                          ? Icon(Icons.star_border_outlined)
                                          : Icon(Icons.star),
                                      onPressed: () async {
                                        print(snapshot.data[0].malId);
                                        RecentlyWatched r = RecentlyWatched(
                                            title: snapshot.data[0].title,
                                            url: snapshot.data[0].url,
                                            malId: snapshot.data[0].malId,
                                            imageUrl:
                                                snapshot.data[0].image_url,
                                            enumber: episodenumber,
                                            denumber: depisodenumber);
                                        if (ic_change == 0) {
                                          await saveMovie(r);
                                        } else {
                                          await deleteMovie(r.malId);
                                        }
                                        setState(() {
                                          ic_change == 0
                                              ? ic_change = 1
                                              : ic_change = 0;
                                        });
                                      }),
                                )
                              ],
                            ),
                            Card(
                              color: HexColor("#191919"),
                              child: TabBar(
                                indicatorColor: Colors.amber[800],
                                labelColor: Colors.amber[800],
                                unselectedLabelColor: Colors.white,
                                labelStyle: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                                unselectedLabelStyle:
                                    GoogleFonts.montserrat(fontSize: 15),
                                tabs: [
                                  Tab(
                                    child: Text(
                                      "Watch",
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      "Watch Dub",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Expanded(
                                child: TabBarView(children: <Widget>[
                              GridView.builder(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data[3].length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: (2 / 1),
                                ),
                                itemBuilder: (
                                  context,
                                  index,
                                ) {
                                  return FocusedMenuHolder(
                                    menuBoxDecoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    animateMenuItems: true,
                                    // bottomOffsetHeight: 10,
                                    menuItemExtent: 70,
                                    // menuWidth: 10,
                                    menuItems: [
                                      FocusedMenuItem(
                                          backgroundColor: HexColor("#191919"),
                                          title: Text(
                                            'Set watched till here',
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          // trailingIcon: Icon(Icons.share),
                                          onPressed: () async {
                                            setState(() {
                                              if (episodenumber <
                                                  snapshot.data[3][index]) {
                                                episodenumber =
                                                    snapshot.data[3][index];
                                              }
                                            });
                                            RecentlyWatched r = RecentlyWatched(
                                                title: snapshot.data[0].title,
                                                url: snapshot.data[0].url,
                                                malId: snapshot.data[0].malId,
                                                imageUrl:
                                                    snapshot.data[0].image_url,
                                                enumber: episodenumber,
                                                denumber: depisodenumber);
                                            bool ans =
                                                await checkIfRecent(r.malId);
                                            if (ans == false) {
                                              saveRecent(r);
                                            } else {
                                              deleteRecent(r.malId);
                                              saveRecent(r);
                                            }
                                          }),
                                      FocusedMenuItem(
                                          backgroundColor: HexColor("#191919"),
                                          title: Text(
                                            "Remove from watched",
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              if (episodenumber >=
                                                  snapshot.data[3][index]) {
                                                episodenumber =
                                                    snapshot.data[3][index] - 1;
                                              }
                                            });
                                            RecentlyWatched r = RecentlyWatched(
                                                title: snapshot.data[0].title,
                                                url: snapshot.data[0].url,
                                                malId: snapshot.data[0].malId,
                                                imageUrl:
                                                    snapshot.data[0].image_url,
                                                enumber: episodenumber,
                                                denumber: depisodenumber);
                                            bool ans =
                                                await checkIfRecent(r.malId);
                                            if (ans == false) {
                                              saveRecent(r);
                                            } else {
                                              deleteRecent(r.malId);
                                              saveRecent(r);
                                            }
                                          }),
                                    ],
                                    onPressed: null,
                                    child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            if (episodenumber <
                                                snapshot.data[3][index]) {
                                              episodenumber =
                                                  snapshot.data[3][index];
                                            }
                                          });
                                          RecentlyWatched r = RecentlyWatched(
                                              title: snapshot.data[0].title,
                                              url: snapshot.data[0].url,
                                              malId: snapshot.data[0].malId,
                                              imageUrl:
                                                  snapshot.data[0].image_url,
                                              enumber: episodenumber,
                                              denumber: depisodenumber);
                                          bool ans =
                                              await checkIfRecent(r.malId);
                                          if (ans == false) {
                                            saveRecent(r);
                                          } else {
                                            deleteRecent(r.malId);
                                            saveRecent(r);
                                          }
                                          await FBAd.showInterstitialAd();
                                          // if (snapshot.data[3][index] == 1) {
                                          //   Navigator.of(context).push(
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               GetVideo(
                                          //                   path: snapshot
                                          //                       .data[1])));
                                          // } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => GetVideo(
                                                      path: snapshot.data[1] +
                                                          "/ep" +
                                                          snapshot.data[3]
                                                                  [index]
                                                              .toString())));
                                          // }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Card(
                                              elevation: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "EP " +
                                                        snapshot.data[3][index]
                                                            .toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 15),
                                                  ),
                                                  IconButton(
                                                    icon: snapshot.data[3]
                                                                [index] >
                                                            episodenumber
                                                        ? Icon(
                                                            Icons
                                                                .arrow_forward_ios_sharp,
                                                            size: 15)
                                                        : Icon(Icons.done,
                                                            color: Colors
                                                                .amber[800],
                                                            size: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              ),
                              GridView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data[4].length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      orientation == Orientation.portrait
                                          ? 2
                                          : 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: (2 / 1),
                                ),
                                itemBuilder: (
                                  context,
                                  index,
                                ) {
                                  return FocusedMenuHolder(
                                    menuBoxDecoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25.0))),
                                    animateMenuItems: true,
                                    menuItemExtent: 70,
                                    menuItems: [
                                      FocusedMenuItem(
                                          backgroundColor: HexColor("#191919"),
                                          title: Text(
                                            'Set watched till here',
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              if (depisodenumber <
                                                  snapshot.data[4][index]) {
                                                depisodenumber =
                                                    snapshot.data[4][index];
                                              }
                                            });
                                            RecentlyWatched r = RecentlyWatched(
                                                title: snapshot.data[0].title,
                                                url: snapshot.data[0].url,
                                                malId: snapshot.data[0].malId,
                                                imageUrl:
                                                    snapshot.data[0].image_url,
                                                enumber: episodenumber,
                                                denumber: depisodenumber);
                                            bool ans =
                                                await checkIfRecent(r.malId);
                                            if (ans == false) {
                                              saveRecent(r);
                                            } else {
                                              deleteRecent(r.malId);
                                              saveRecent(r);
                                            }
                                          }),
                                      FocusedMenuItem(
                                          backgroundColor: HexColor("#191919"),
                                          title: Text(
                                            "Remove from watched",
                                            style: GoogleFonts.montserrat(),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              if (depisodenumber >=
                                                  snapshot.data[4][index]) {
                                                depisodenumber =
                                                    snapshot.data[4][index] - 1;
                                              }
                                            });
                                            RecentlyWatched r = RecentlyWatched(
                                                title: snapshot.data[0].title,
                                                url: snapshot.data[0].url,
                                                malId: snapshot.data[0].malId,
                                                imageUrl:
                                                    snapshot.data[0].image_url,
                                                enumber: episodenumber,
                                                denumber: depisodenumber);
                                            bool ans =
                                                await checkIfRecent(r.malId);
                                            if (ans == false) {
                                              saveRecent(r);
                                            } else {
                                              deleteRecent(r.malId);
                                              saveRecent(r);
                                            }
                                          }),
                                    ],
                                    onPressed: null,
                                    child: GestureDetector(
                                        onTap: () async {
                                          setState(() {
                                            if (depisodenumber <
                                                snapshot.data[4][index]) {
                                              depisodenumber =
                                                  snapshot.data[4][index];
                                            }
                                          });
                                          RecentlyWatched r = RecentlyWatched(
                                              title: snapshot.data[0].title,
                                              url: snapshot.data[0].url,
                                              malId: snapshot.data[0].malId,
                                              imageUrl:
                                                  snapshot.data[0].image_url,
                                              enumber: episodenumber,
                                              denumber: depisodenumber);
                                          bool ans =
                                              await checkIfRecent(r.malId);
                                          if (ans == false) {
                                            saveRecent(r);
                                          } else {
                                            deleteRecent(r.malId);
                                            saveRecent(r);
                                          }
                                          await FBAd.showInterstitialAd();
                                          // if (snapshot.data[4][index] == 1) {
                                          //   Navigator.of(context).push(
                                          //       MaterialPageRoute(
                                          //           builder: (context) =>
                                          //               GetVideo(
                                          //                   path: snapshot
                                          //                       .data[2])));
                                          // } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => GetVideo(
                                                      path: snapshot.data[2] +
                                                          "/ep" +
                                                          snapshot.data[4]
                                                                  [index]
                                                              .toString())));
                                          // }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Card(
                                              elevation: 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "EP " +
                                                        snapshot.data[3][index]
                                                            .toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 15),
                                                  ),
                                                  IconButton(
                                                    icon: snapshot.data[3]
                                                                [index] >
                                                            depisodenumber
                                                        ? Icon(
                                                            Icons
                                                                .arrow_forward_ios_sharp,
                                                            size: 15)
                                                        : Icon(Icons.done,
                                                            color: Colors
                                                                .amber[800],
                                                            size: 15),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),
                                  );
                                },
                              )
                            ]))
                          ]),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
