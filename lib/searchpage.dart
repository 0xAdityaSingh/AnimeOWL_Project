// Flutter imports:
import 'dart:convert';

import 'package:animetv/Model/Search.dart';
import 'package:animetv/animeInfo.dart';
import 'package:animetv/appbar.dart';
import 'package:animetv/searchinputbox.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';

import 'addss.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  // @override
  // void initState() {
  //   super.initState();
  // }

  List<Searchh> search_list;
  String result = "";
// List<Searchh> filteredUsers = List();
  Future<List<Searchh>> getsearch(String text) async {
    if (text == "") {
      return [];
    } else {
      var response = await Dio().get(
        'https://api.jikan.moe/v3/search/anime?q=' + text,
      );
      // print(response.statusCode);
      // print(response.data['results']);
      var jsonData = response.data['results'];
      // print(jsonData);

      List<Searchh> result = [];

      for (var u in jsonData) {
        // print(u['title']);
        Searchh r = Searchh(
          title: u['title'],
          url: u['url'],
          malId: u['mal_id'],
          imageUrl: u['image_url'],
          type: u['type'],
        );
        result.add(r);
      }
      // setState(() {
      //   search = result;
      // });
      return result;
    }
  }

  TextEditingController _textEditingController;
  ScrollController _scrollController;
  FocusNode listTileNode;
  FocusNode backButtonNode;

  @override
  void initState() {
    FBAd.initialize();
    FBAd.loadInterstitialAd();
    _textEditingController = TextEditingController(text: '');
    _scrollController = ScrollController();
    listTileNode = FocusNode();
    backButtonNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    listTileNode.dispose();
    backButtonNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        // primary: true,
        backgroundColor: HexColor("#191919"),
        title: AppbarText(
          custom: 'search',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: SearchPageInputBox(
                  listTileFocusNode: listTileNode,
                  backButtonFocusNode: backButtonNode,
                  controller: _textEditingController,
                  // onSubmitted:()
                  onChanged: (string) async {
                    // _debouncer.run(() {
                    // await getsearch(string);

                    List<Searchh> test = [];
                    test = await getsearch(string);

                    setState(() {
                      result = string;
                      search_list = test;
                    });
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getsearch(result),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (search_list == null) {
                      return Container();
                    } else {
                      return ListView.builder(
                        itemCount: search_list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              // color: HexColor("#191919"),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              search_list[index].imageUrl),
                                        ),
                                        title: Text(
                                          search_list[index].title,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          search_list[index].type,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        onTap: () async {
                                          // await FBAd.showInterstitialAd();
                                          print(search_list[index].malId);
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AnimeInfo(
                                                        malID:
                                                            search_list[index]
                                                                .malId,
                                                        url: search_list[index]
                                                            .url,
                                                      )));
                                        },
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      size: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
