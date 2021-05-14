import 'dart:convert';
// import 'dart:html';
// import 'dart:html';
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
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<List<Week>> getweek() async {
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
        // print(r.imageUrl);
        result.add(r);
        number++;
      } catch (e) {
        break;
      }
      // var u = jsonData['anime'][i.toString()];
      // print(u);

    }
    return result;
  }

  Future<List<Result>> getNew() async {
    var headers = {
      'authority': 'animixplay.to',
      'pragma': 'no-cache',
      'cache-control': 'no-cache',
      'accept': '*/*',
      'x-requested-with': 'XMLHttpRequest',
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.4430.85 Safari/537.36',
      'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
      'sec-gpc': '1',
      'origin': 'https://animixplay.to',
      'sec-fetch-site': 'same-origin',
      'sec-fetch-mode': 'cors',
      'sec-fetch-dest': 'empty',
      'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
      'cookie': '__cfduid=d62877aff882f820d7673deefff480e981618578873',
    };
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(now);
    var data = {'seasonal': formattedDate};
    var response = await http.post(
        Uri.https('animixplay.to', 'a/3KjJkx2RVQu1zeXQnrZWc'),
        headers: headers,
        body: data);
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
    return Scaffold(
      appBar: AppBar(
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
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchPage()));
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
                child: CircularProgressIndicator(),
              );
            } else {
              var r;
              final List<Widget> _children = [
                Screen1(
                  data: snapshot.data,
                ),
                Container(
                  child: FutureBuilder(
                      future: getRecent(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            final orientation =
                                MediaQuery.of(context).orientation;
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 80),
                              child: GridView.builder(
                                itemCount: snapshot.data.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height *
                                              1.15 /
                                              1.5),
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DiscoverAnimeFav(
                                        anime: snapshot.data[index]),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      }),
                ),
                Container(
                  child: FutureBuilder(
                      future: getMovies(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                            return Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 80),
                              child: Card(
                                color: HexColor("#191919"),
                                child: GridView.builder(
                                  itemCount: snapshot.data.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (orientation == Orientation.portrait)
                                            ? 2
                                            : 3,
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .width /
                                        (MediaQuery.of(context).size.height *
                                            1.15 /
                                            1.5),
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: DiscoverAnimeFav(
                                          anime: snapshot.data[index]),
                                    );
                                  },
                                ),
                              ),
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
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.discord,
              ),
              iconSize: 30.0,
              onPressed: () async {
                var url = 'https://discord.gg/WpVjTDfbek';
                // if (await canLaunch(url)) {
                await launch(url);
                // }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class Screen1 extends StatelessWidget {
  final data;
  const Screen1({
    Key key,
    this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SizedBox(
          //   height: 20,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubCategoryText(
                  text: 'Featured',
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                Container(
                  height: 280,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: data[2].length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: DiscoverAnimeTileWeek(anime: data[2][index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubCategoryText(
                  text: 'Popular',
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                Container(
                  height: 280,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: data[0].length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: DiscoverAnimeTile(anime: data[0][index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 20,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubCategoryText(
                  text: 'New Eps',
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                Container(
                  height: 280,
                  margin: EdgeInsets.symmetric(horizontal: 0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemCount: data[1].length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 170,
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: DiscoverAnimeTileResults(
                          anime: data[1][index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeTile extends StatelessWidget {
  const DiscoverAnimeTile({
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
      borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              anime.imageUrl,
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
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
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

class DiscoverAnimeTileResults extends StatelessWidget {
  const DiscoverAnimeTileResults({
    Key key,
    this.anime,
  }) : super(key: key);

  final anime;
  // final title;

  String getImageUrl(BuildContext context) {
    return anime.url;
  }

  @override
  Widget build(BuildContext context) {
    var color = Theme.of(context).cardColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              anime.picture,
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
                height: 80,
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
                            fontWeight: FontWeight.bold, fontSize: 15),
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetVideo(path: anime.url)));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoverAnimeTileWeek extends StatelessWidget {
  const DiscoverAnimeTileWeek({
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
      borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
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
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
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
      borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              anime.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
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
      borderRadius: BorderRadius.circular(12),
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
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              anime.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: color,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    anime.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
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
