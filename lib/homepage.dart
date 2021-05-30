import 'dart:convert';
import 'dart:ui';
// import 'dart:html';
// import 'dart:html';
import 'package:animetv/Model/movie.dart';
import 'package:animetv/Model/recently_watched.dart';
import 'package:animetv/Model/week.dart';
import 'package:animetv/appbar.dart';
import 'package:animetv/getvideo.dart';
import 'package:animetv/Model/new.dart';
import 'package:animetv/Model/popular.dart';
import 'package:animetv/animeInfo.dart';
import 'package:animetv/searchpage.dart';

import 'package:animetv/subcatogery.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock/wakelock.dart';

import 'addss.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  void initState() {
    FBAd.initialize();
    FBAd.loadInterstitialAd();
    super.initState();
  }

  Future<List<Week>> getweek() async {
    // var response1 = await http.get(Uri.https('animeowl1033.herokuapp.com', ''));
    // if (response1.statusCode == 200) {
    //   return [];
    // }
    var response = await http.get(
      Uri.https('animixplay.to', 'assets/s/featured.json'),
    );
    var jsonData = jsonDecode(response.body);
    // print(jsonData['anime']);
    List<Week> result = [];

    for (var u in jsonData) {
      var str = u['url'];
      const start = "/anime/";
      const end = "/";

      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);

      var malid = int.parse(str.substring(startIndex + start.length, endIndex));
      Week r = Week(
        title: u['title'],
        url: "https://myanimelist.net" + u['url'],
        malId: malid,
        img: u['img'],
      );
      result.add(r);
    }
    return result;
  }

  Future<List<Anime>> getPop() async {
    // var response1 = await http.get(Uri.https('animeowl1033.herokuapp.com', ''));
    // if (response1.statusCode == 200) {
    //   return [];
    // }
    var response = await http.get(
      Uri.https('animixplay.to', 'assets/season/2021/spring.json'),
    );
    var jsonData = jsonDecode(response.body);
    // print(jsonData['anime']);
    List<Anime> result = [];
    int number = 150;
    for (var i = 0; i <= number; i++) {
      // if(request.status < 400) {
      try {
        var u = jsonData['anime'][i.toString()];
        // print(u['mal_id']);
        Anime r = Anime(
          title: u['title'],
          url: u['url'],
          malId: u['mal_id'],
          imageUrl: u['image_url'],
        );
        result.add(r);
        number++;
      } catch (e) {
        break;
      }
    }
    return result;
  }

  Future<List<MovieG>> getMoviesG() async {
    var headers = {
      'authority': 'animixplay.to',
      'pragma': 'no-cache',
      'cache-control': 'no-cache',
      'accept': '*/*',
      'x-requested-with': 'XMLHttpRequest',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'sec-gpc': '1',
      'origin': 'https://animixplay.to',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'cors',
      'sec-fetch-dest': 'empty',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
    };
    var data = {'movie': '99999999'};
    var response = await http.post(Uri.https('animixplay.to', 'api/search'),
        headers: headers, body: data);
    var jsonData = jsonDecode(response.body);
    List<MovieG> result = [];
    for (var u in jsonData['result']) {
      MovieG r = MovieG(
          title: u['title'],
          url: u['url'],
          picture: u['picture'],
          infotext: u['infotext'],
          score: u['score']);
      // print(r.url);
      result.add(r);
    }
    return result;
  }

  Future<List<Result>> getNew() async {
    // var response1 = await http.get(Uri.https('animeowl1033.herokuapp.com', ''));
    // if (response1.statusCode == 200) {
    //   return [];
    // }

    var headers = {
      'authority': 'animixplay.to',
      'pragma': 'no-cache',
      'cache-control': 'no-cache',
      'accept': '*/*',
      'x-requested-with': 'XMLHttpRequest',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.212 Safari/537.36',
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'sec-gpc': '1',
      'origin': 'https://animixplay.to',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'cors',
      'sec-fetch-dest': 'empty',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
    };
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    var data = {'seasonal': formattedDate};
    var response = await http.post(Uri.https('animixplay.to', 'api/search'),
        headers: headers, body: data);
    var jsonData = jsonDecode(response.body);
    // print(jsonData['result']);
    List<Result> result = [];
    for (var u in jsonData['result']) {
      Result r = Result(
          title: u['title'],
          url: u['url'],
          picture: u['picture'],
          infotext: u['infotext'],
          timetop: u['timetop'],
          score: u['score']);
      // print(r.url);
      result.add(r);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // elevation: 0,
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            indicatorColor: Theme.of(context).accentColor,
            indicatorSize: TabBarIndicatorSize.label,
            onTap: (index) {
              setState(() {
                _currentIndex = 0;
              });
            },
            tabs: [
              Tab(
                child: Align(
                    alignment: Alignment.center,
                    child: Text("New Eps", style: GoogleFonts.montserrat())),
              ),
              Tab(
                child: Align(
                    alignment: Alignment.center,
                    child: Text("Featured", style: GoogleFonts.montserrat())),
              ),
              Tab(
                child: Align(
                    alignment: Alignment.center,
                    child: Text("Popular", style: GoogleFonts.montserrat())),
              ),
              // Tab(
              //   child: Align(
              //       alignment: Alignment.center,
              //       child: Text("Movies", style: GoogleFonts.montserrat())),
              // ),
            ],
          ),
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25))),
          primary: true,
          backgroundColor: HexColor("#191919"),
          title: AppbarText(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              },
            ),
          ],
        ),
        body: Container(
          child: FutureBuilder(
            future: Future.wait([getPop(), getNew(), getweek()]),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).accentColor,
                  ),
                );
              } else {
                var r;
                final orientation = MediaQuery.of(context).orientation;
                final List<Widget> _children = [
                  TabBarView(
                    children: [
                      Container(
                        child: GridView.builder(
                          itemCount: snapshot.data[1].length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3,
                            childAspectRatio: (orientation ==
                                    Orientation.portrait)
                                ? MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height *
                                        1.15 /
                                        1.5)
                                : MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height * 2.1),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: DiscoverAnimeTileResults(
                                    anime: snapshot.data[1][index]));
                          },
                        ),
                      ),
                      Container(
                        child: GridView.builder(
                          itemCount: snapshot.data[2].length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3,
                            childAspectRatio: (orientation ==
                                    Orientation.portrait)
                                ? MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height *
                                        1.15 /
                                        1.5)
                                : MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height * 2.1),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: DiscoverAnimeTileWeek2(
                                    anime: snapshot.data[2][index])
                                // child: DiscoverAnimeFav2(
                                //     anime: snapshot.data[2][index]),
                                );
                          },
                        ),
                      ),
                      Container(
                        child: GridView.builder(
                          itemCount: snapshot.data[0].length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3,
                            childAspectRatio: (orientation ==
                                    Orientation.portrait)
                                ? MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height *
                                        1.15 /
                                        1.5)
                                : MediaQuery.of(context).size.width /
                                    (MediaQuery.of(context).size.height * 2.1),
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: DiscoverAnimeTile2(
                                    anime: snapshot.data[0][index])
                                // child: DiscoverAnimeFav2(
                                //     anime: snapshot.data[2][index]),
                                );
                          },
                        ),
                      ),
                      // Container(
                      //   child: GridView.builder(
                      //     itemCount: snapshot.data[3].length,
                      //     gridDelegate:
                      //         SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount:
                      //           (orientation == Orientation.portrait) ? 2 : 3,
                      //       childAspectRatio: (orientation ==
                      //               Orientation.portrait)
                      //           ? MediaQuery.of(context).size.width /
                      //               (MediaQuery.of(context).size.height *
                      //                   1.15 /
                      //                   1.5)
                      //           : MediaQuery.of(context).size.width /
                      //               (MediaQuery.of(context).size.height * 2.1),
                      //     ),
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return Padding(
                      //           padding: const EdgeInsets.all(1.0),
                      //           child: DiscoverAnimeTileResults2(
                      //               anime: snapshot.data[3][index]));
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  Container(
                    child: FutureBuilder(
                        future: getRecent(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: Icon(Icons.timer_outlined),
                            );
                          } else {
                            if (snapshot.data.length == 0) {
                              return Center(
                                child: Icon(Icons.timer_outlined),
                              );
                            } else {
                              return GridView.builder(
                                itemCount: snapshot.data.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3,
                                  childAspectRatio: (orientation ==
                                          Orientation.portrait)
                                      ? MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height *
                                              1.15 /
                                              1.5)
                                      : MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height *
                                              2.1),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return DiscoverAnimeFav(
                                      anime: snapshot.data[index]);
                                },
                              );
                            }
                          }
                        }),
                  ),
                  Container(
                    child: FutureBuilder(
                        future: getMovies(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                              child: Icon(Icons.favorite_border),
                            );
                          } else {
                            if (snapshot.data.length == 0) {
                              return Center(
                                child: Icon(Icons.favorite_border),
                              );
                            } else {
                              final orientation =
                                  MediaQuery.of(context).orientation;
                              return GridView.builder(
                                itemCount: snapshot.data.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3,
                                  childAspectRatio: (orientation ==
                                          Orientation.portrait)
                                      ? MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height *
                                              1.15 /
                                              1.5)
                                      : MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height *
                                              2.1),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return DiscoverAnimeFav(
                                      anime: snapshot.data[index]);
                                },
                              );
                            }
                          }
                        }),
                  ),
                  Container(
                      child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          // color: HexColor("#191919"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  "Data",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text(
                                  'Reset Recently Watched',
                                  style: GoogleFonts.montserrat(),
                                ),
                                subtitle: Text(
                                  'Clear recently watched animes',
                                  style: GoogleFonts.montserrat(),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.restore),
                                    onPressed: () {
                                      Hive.box('recentbox').clear();
                                    }),
                              ),
                              ListTile(
                                title: Text(
                                  'Reset Favourite Anime',
                                  style: GoogleFonts.montserrat(),
                                ),
                                subtitle: Text(
                                  'Clear your favourite animes',
                                  style: GoogleFonts.montserrat(),
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.restore),
                                    onPressed: () {
                                      Hive.box('animebox').clear();
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          // color: HexColor("#191919"),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 10.0,
                                ),
                                child: Text(
                                  "Contact",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('Discord'),
                                subtitle: Text('Join our Discord Channel.'),
                                trailing: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.discord,
                                  ),
                                  // iconSize: 30.0,
                                  onPressed: () async {
                                    var url = 'https://discord.gg/WpVjTDfbek';
                                    // if (await canLaunch(url)) {
                                    await launch(url);
                                    // }
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('About App'),
                                subtitle: Text('Learn more!'),
                                onTap: () => showInfoDialog(),
                                trailing: IconButton(
                                  icon: Icon(Icons.info_outline_rounded),
                                  onPressed: () => showInfoDialog(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
                ];
                return _children[_currentIndex];
              }
            },
          ),
        ),
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: HexColor("#191919"),
            child: BottomNavigationBar(
              onTap: onTabTapped, // new
              currentIndex: _currentIndex,
              selectedItemColor: Theme.of(context).accentColor,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                  tooltip: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timer_outlined),
                  label: 'Recent',
                  tooltip: 'Recent',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border_rounded),
                  label: 'Favorites',
                  tooltip: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                  tooltip: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<List<RecentlyWatched>> getMovies() async {
    final movieBox = await Hive.openBox('animebox');
    //2
    final movieIds = movieBox.keys;
    //3
    List<RecentlyWatched> movies = [];
    //4
    movieIds.forEach((movieId) {
      movies.add(movieBox.get(movieId));
    });
    //5
    return movies;
  }

  Future<List<RecentlyWatched>> getRecent() async {
    final movieBox = await Hive.openBox('recentbox');

    final movieIds = movieBox.keys;

    List<RecentlyWatched> recent = [];

    movieIds.forEach((movieId) {
      recent.add(movieBox.get(movieId));
    });
    return recent;
  }

  void showInfoDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'AnimeOWL',
    );
  }
}

class DiscoverAnimeTileResults extends StatelessWidget {
  const DiscoverAnimeTileResults({
    Key key,
    this.anime,
  }) : super(key: key);

  final anime;

  String getImageUrl(BuildContext context) {
    return anime.url;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.network(
                              anime.picture,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        anime.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      AutoSizeText(
                        anime.infotext,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  // await FBAd.showInterstitialAd();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetVideo(
                            path: anime.url,
                            name: anime.title,
                            img: anime.picture,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeFav extends StatelessWidget {
  const DiscoverAnimeFav({
    Key key,
    this.anime,
  }) : super(key: key);
  final anime;
  String getImageUrl(BuildContext context) {
    return anime.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      // borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.network(
                              anime.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await FBAd.showInterstitialAd();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AnimeInfo(
                            malID: anime.malId,
                            url: anime.url,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeTileRecent extends StatelessWidget {
  const DiscoverAnimeTileRecent({
    Key key,
    this.anime,
  }) : super(key: key);
  final anime;
  String getImageUrl(BuildContext context) {
    return anime.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.network(
                              anime.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await FBAd.showInterstitialAd();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AnimeInfo(
                            malID: anime.malId,
                            url: anime.url,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeTileWeek2 extends StatelessWidget {
  const DiscoverAnimeTileWeek2({
    Key key,
    this.anime,
  }) : super(key: key);
  final anime;
  String getImageUrl(BuildContext context) {
    return anime.url;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      // borderRadius: BorderRadius.circular(),
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.network(
                              anime.img,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              // placeholder: (_, __) => CustomShimmer(),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await FBAd.showInterstitialAd();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AnimeInfo(
                            malID: anime.malId,
                            url: anime.url,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeTile2 extends StatelessWidget {
  const DiscoverAnimeTile2({
    Key key,
    this.anime,
  }) : super(key: key);
  final anime;
  String getImageUrl(BuildContext context) {
    return anime.url;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      // borderRadius: BorderRadius.circular(),
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.network(
                              anime.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await FBAd.showInterstitialAd();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AnimeInfo(
                            malID: anime.malId,
                            url: anime.url,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeTileResults2 extends StatelessWidget {
  const DiscoverAnimeTileResults2({
    Key key,
    this.anime,
  }) : super(key: key);

  final anime;

  String getImageUrl(BuildContext context) {
    return anime.url;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      child: Stack(
        children: [
          Column(
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: color,
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1),
                            child: Image.network(
                              anime.picture,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        anime.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                            // fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await FBAd.showInterstitialAd();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetVideo(
                            path: anime.url + "-episode-1",
                            name: anime.title,
                            img: anime.picture,
                          )));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
