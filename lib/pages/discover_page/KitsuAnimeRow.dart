import 'package:animetv/models/TwistModel.dart';
import 'package:animetv/models/kitsu/KitsuAnimeListModel.dart';
import 'package:animetv/models/kitsu/KitsuModel.dart';
import 'package:animetv/pages/discover_page/DiscoverAnimeTile.dart';
import 'package:animetv/pages/discover_page/LoadingAnimeTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class KitsuAnimeRow extends StatefulWidget {
  KitsuAnimeRow({Key key, @required this.futureProvider}) : super(key: key);

  final FutureProvider<Tuple2<Map<TwistModel, KitsuModel>, KitsuAnimeListModel>>
      futureProvider;

  @override
  _KitsuAnimeRowState createState() => _KitsuAnimeRowState();
}

class _KitsuAnimeRowState extends State<KitsuAnimeRow>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, watch, child) {
        return watch(widget.futureProvider).when(
          data: (data) {
            return Container(
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemCount: data.item1.keys.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: DiscoverAnimeTile(
                      kitsuModel: data.item1.values.elementAt(index),
                      twistModel: data.item1.keys.elementAt(index),
                    ),
                  );
                },
              ),
            );
          },
          loading: () {
            return Container(
              height: 250,
              margin: EdgeInsets.symmetric(horizontal: 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: LoadingAnimeTile(),
                  );
                },
              ),
            );
          },
          error: (e, s) => Container(),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
