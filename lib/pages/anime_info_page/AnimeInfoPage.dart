// Flutter imports:
import 'dart:math';
import 'dart:ui';

import 'package:animetv/animations/Transitions.dart';
import 'package:animetv/pages/watch_page/WatchPage.dart';
import 'package:animetv/providers.dart';
import 'package:animetv/pages/anime_info_page/DescriptionWidget.dart';
import 'package:animetv/pages/anime_info_page/RatingGraph.dart';
import 'package:animetv/pages/anime_info_page/RatingWidget.dart';
import 'package:animetv/pages/anime_info_page/WatchTrailerButton.dart';
import 'package:animetv/pages/error_page/ErrorPage.dart';
import 'package:animetv/services/twist_service/TwistApiService.dart';
import 'package:animetv/widgets/custom_shimmer.dart';
import 'package:animetv/widgets/device_orientation_builder.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animetv/utils/GetUtils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supercharged/supercharged.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Project imports:
import '../../addds.dart';
import '../../models/EpisodeModel.dart';
import '../../models/kitsu/KitsuModel.dart';
import '../../models/TwistModel.dart';
import '../../providers/EpisodesWatchedProvider.dart';
import '../../services/kitsu_service/KitsuApiService.dart';
import 'package:animetv/constants.dart';
import '../../animations/TwistLoadingWidget.dart';

import 'FavouriteButton.dart';

// InterstitialAd createInterstitialAdd() {
//   return InterstitialAd(
//       adUnitId: 'ca-app-pub-7187079853593886/2620740358',
//       );
// }

class AnimeInfoPage extends StatefulWidget {
  final TwistModel twistModel;
  final bool isFromSearchPage;
  final FocusNode focusNode;
  final bool isFromRecentlyWatched;
  final int lastWatchedEpisodeNum;

  AnimeInfoPage({
    this.twistModel,
    this.isFromSearchPage,
    this.focusNode,
    this.isFromRecentlyWatched = false,
    this.lastWatchedEpisodeNum = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimeInfoPageState();
  }
}

class _AnimeInfoPageState extends State<AnimeInfoPage> {
  ScrollController _scrollController;
  ScrollController _placeholderController;
  ChangeNotifierProvider<EpisodesWatchedProvider> _episodesWatchedProvider;
  bool hasScrolled = false;
  KitsuModel kitsuModel;
  List<EpisodeModel> episodes;
  FutureProvider _initDataProvider;

  final offsetProvider = StateProvider<double>((ref) {
    return 0.0;
  });

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    AdmobService.initialize();
    _scrollController = ScrollController();
    _placeholderController = ScrollController();
    _scrollController.addListener(() {
      setImageOffset();
    });
    _initDataProvider = FutureProvider((ref) async {
      await initData();
    });
  }

  void setImageOffset() {
    var controller = _placeholderController;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      controller = _scrollController;
    }
    var offset = controller.offset / MediaQuery.of(context).size.height * 5;
    context.read(offsetProvider).state = offset;
  }

  @override
  void dispose() {
    Get.delete<TwistModel>();
    Get.delete<KitsuModel>();
    Get.delete<ChangeNotifierProvider<EpisodesWatchedProvider>>();
    _scrollController.dispose();
    _placeholderController.dispose();

    super.dispose();
  }

  Future initData() async {
    Get.delete<TwistModel>();
    Get.put<TwistModel>(widget.twistModel);

    var twistApiService = Get.find<TwistApiService>();

    episodes = await twistApiService.getEpisodesForSource(
      twistModel: widget.twistModel,
    );

    kitsuModel = await KitsuApiService.getKitsuModel(
        widget.twistModel.kitsuId, widget.twistModel.ongoing);

    Get.delete<KitsuModel>();
    Get.put<KitsuModel>(kitsuModel);

    await precacheImage(
        NetworkImage(kitsuModel?.posterImage ??
            (kitsuModel?.coverImage ?? DEFAULT_IMAGE_URL)),
        context);

    _episodesWatchedProvider = ChangeNotifierProvider<EpisodesWatchedProvider>(
      (ref) {
        return EpisodesWatchedProvider(slug: widget.twistModel.slug);
      },
    );
    await context.read(_episodesWatchedProvider).getWatchedPref();
    await Future.delayed(400.milliseconds);
  }

  void scrollToLastWatched(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;

    if (hasScrolled) return;
    if (widget.isFromRecentlyWatched && widget.lastWatchedEpisodeNum != null) {
      if (orientation == Orientation.portrait) {
        var sliverAppBarHeight = height * 0.4;
        var descHeight = 150;
        var maxScrollExtent = _scrollController.position.maxScrollExtent;
        // Approximate height of each episode card. We use this to calculate how
        // much we need to scroll by multiplying it by our last watched episode.
        var episodeCardHeight =
            (maxScrollExtent - (sliverAppBarHeight + descHeight)) /
                episodes.length;

        var scrollLength = sliverAppBarHeight +
            descHeight +
            (widget.lastWatchedEpisodeNum * episodeCardHeight);

        // Don't overscroll if our calculated scroll length is greater than the
        // maximum
        if (scrollLength > maxScrollExtent) scrollLength = maxScrollExtent;

        var duration = max(1000, widget.lastWatchedEpisodeNum * 10);

        _scrollController
            .animateTo(
              scrollLength,
              duration: duration.milliseconds,
              curve: Curves.ease,
            )
            .whenComplete(() => hasScrolled = true);
      } else {
        var cardHeight =
            _scrollController.position.maxScrollExtent / episodes.length;
        var scrollLength = cardHeight * widget.lastWatchedEpisodeNum;
        var duration = max(1000, widget.lastWatchedEpisodeNum * 10);

        _scrollController
            .animateTo(
              scrollLength,
              duration: duration.milliseconds,
              curve: Curves.ease,
            )
            .whenComplete(() => hasScrolled = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        return true;
      },
      child: Scaffold(
        body: Consumer(
          builder: (context, watch, child) {
            return watch(_initDataProvider).when(
              data: (data) {
                WidgetsBinding.instance.addPostFrameCallback(
                    (timeStamp) => scrollToLastWatched(context));
                return DeviceOrientationBuilder(
                  portrait: Scrollbar(
                    controller: _scrollController,
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        SliverAppBar(
                          expandedHeight: orientation == Orientation.portrait
                              ? height * 0.4
                              : width * 0.28,
                          stretch: true,
                          actions: [RatingWidget(kitsuModel: kitsuModel)],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Positioned.fill(
                                    child: Consumer(
                                      builder: (context, watch, child) {
                                        final provider = watch(offsetProvider);
                                        return CachedNetworkImage(
                                          imageUrl: kitsuModel?.posterImage ??
                                              kitsuModel?.coverImage ??
                                              DEFAULT_IMAGE_URL,
                                          fit: BoxFit.cover,
                                          alignment: Alignment(
                                              0, -provider.state.abs()),
                                          placeholder: (_, __) =>
                                              CustomShimmer(),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Theme.of(context)
                                          .cardColor
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 20,
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            fit: FlexFit.loose,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: AutoSizeText(
                                                    widget.twistModel.title,
                                                    textAlign: TextAlign.left,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    minFontSize: 20.0,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30.0,
                                                    ),
                                                  ),
                                                ),
                                                Consumer(
                                                  builder:
                                                      (context, watch, child) {
                                                    final provider =
                                                        watch(toWatchProvider);
                                                    return Container(
                                                      height: 35.0,
                                                      margin: EdgeInsets.only(
                                                        left: 5.0,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          provider.isAlreadyInToWatch(
                                                                      widget
                                                                          .twistModel) >=
                                                                  0
                                                              ? FontAwesomeIcons
                                                                  .minus
                                                              : FontAwesomeIcons
                                                                  .plus,
                                                        ),
                                                        onPressed: () {
                                                          provider
                                                              .toggleFromToWatched(
                                                            episodeModel: null,
                                                            kitsuModel:
                                                                kitsuModel,
                                                            twistModel: widget
                                                                .twistModel,
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            (episodes?.length?.toString() ??
                                                    '0') +
                                                ' Episodes | ' +
                                                (widget.twistModel.ongoing
                                                    ? 'Ongoing'
                                                    : 'Finished'),
                                            textAlign: TextAlign.left,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15.0,
                                              color:
                                                  Theme.of(context).hintColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                children: [
                                  Expanded(
                                    child: WatchTrailerButton(
                                      kitsuModel: kitsuModel,
                                    ),
                                  ),
                                  FavouriteButton(
                                    twistModel: widget.twistModel,
                                    kitsuModel: kitsuModel,
                                  ),
                                ],
                              ),
                              DescriptionWidget(
                                twistModel: widget.twistModel,
                                kitsuModel: kitsuModel,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 8.0,
                                ),
                                child: Text(
                                  'SEASON ' +
                                      widget.twistModel.season.toString(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        EpisodesSliver(
                          episodes: episodes,
                          episodesWatchedProvider: _episodesWatchedProvider,
                        ),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 15.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  landscape: Row(
                    children: [
                      Expanded(
                        child: CustomScrollView(
                          controller: _placeholderController,
                          slivers: [
                            SliverAppBar(
                              expandedHeight:
                                  orientation == Orientation.portrait
                                      ? height * 0.4
                                      : width * 0.28,
                              stretch: true,
                              actions: [RatingWidget(kitsuModel: kitsuModel)],
                              flexibleSpace: FlexibleSpaceBar(
                                background: Container(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Positioned.fill(
                                        child: Consumer(
                                          builder: (context, watch, child) {
                                            final provider =
                                                watch(offsetProvider);
                                            return CachedNetworkImage(
                                              imageUrl:
                                                  kitsuModel?.posterImage ??
                                                      kitsuModel?.coverImage ??
                                                      DEFAULT_IMAGE_URL,
                                              fit: BoxFit.cover,
                                              alignment: Alignment(
                                                  0, -provider.state.abs()),
                                              placeholder: (_, __) =>
                                                  CustomShimmer(),
                                            );
                                          },
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          color: Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                      Positioned.fill(
                                        bottom: 20,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        widget.twistModel.title,
                                                        textAlign:
                                                            TextAlign.left,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        minFontSize: 20.0,
                                                        style: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30.0,
                                                        ),
                                                      ),
                                                    ),
                                                    Consumer(
                                                      builder: (context, watch,
                                                          child) {
                                                        final provider = watch(
                                                            toWatchProvider);
                                                        return Container(
                                                          height: 35.0,
                                                          margin:
                                                              EdgeInsets.only(
                                                            left: 5.0,
                                                          ),
                                                          child: IconButton(
                                                            icon: Icon(
                                                              provider.isAlreadyInToWatch(
                                                                          widget
                                                                              .twistModel) >=
                                                                      0
                                                                  ? FontAwesomeIcons
                                                                      .minus
                                                                  : FontAwesomeIcons
                                                                      .plus,
                                                            ),
                                                            onPressed: () {
                                                              provider
                                                                  .toggleFromToWatched(
                                                                episodeModel:
                                                                    null,
                                                                kitsuModel:
                                                                    kitsuModel,
                                                                twistModel: widget
                                                                    .twistModel,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 5.0),
                                              Text(
                                                (episodes?.length?.toString() ??
                                                        '0') +
                                                    ' Episodes | ' +
                                                    (widget.twistModel.ongoing
                                                        ? 'Ongoing'
                                                        : 'Finished'),
                                                textAlign: TextAlign.left,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15.0,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: WatchTrailerButton(
                                          kitsuModel: kitsuModel,
                                        ),
                                      ),
                                      FavouriteButton(
                                        twistModel: widget.twistModel,
                                        kitsuModel: kitsuModel,
                                      ),
                                    ],
                                  ),
                                  DescriptionWidget(
                                    twistModel: widget.twistModel,
                                    kitsuModel: kitsuModel,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: RatingGraph(
                                        ratingFrequencies:
                                            kitsuModel.ratingFrequencies),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: SafeArea(
                        child: Scrollbar(
                          controller: _scrollController,
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 16.0,
                                    right: 16.0,
                                    bottom: 8.0,
                                    top: 8.0,
                                  ),
                                  child: Text(
                                    'SEASON ' +
                                        widget.twistModel.season.toString(),
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                              EpisodesSliver(
                                episodesWatchedProvider:
                                    _episodesWatchedProvider,
                                episodes: episodes,
                              ),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                );
              },
              loading: () => Center(child: RotatingPinLoadingAnimation()),
              error: (e, s) => ErrorPage(
                stackTrace: s,
                e: e,
                message:
                    'Whoops! An error occured. Looks like twist.moe is down, or your internet is not working. Please try again later.',
                onRefresh: () => context.refresh(_initDataProvider),
              ),
            );
          },
        ),
      ),
    );
  }
}

class EpisodesSliver extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final ChangeNotifierProvider<EpisodesWatchedProvider> episodesWatchedProvider;

  EpisodesSliver({
    Key key,
    @required this.episodes,
    @required this.episodesWatchedProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isPortrait = orientation == Orientation.portrait;
    var width = MediaQuery.of(context).size.width;

    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 14.0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: isPortrait ? width / 125 : width / 250,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: EdgeInsets.all(
                1.0,
              ),
              child: EpisodeCard(
                episodeModel: episodes.elementAt(index),
                episodes: episodes,
                episodesWatchedProvider: episodesWatchedProvider,
              ),
            );
          },
          childCount: episodes.length,
        ),
      ),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final List<EpisodeModel> episodes;
  final EpisodeModel episodeModel;

  final TwistModel twistModel = Get.find();
  final KitsuModel kitsuModel = Get.find<KitsuModel>();
  final ChangeNotifierProvider<EpisodesWatchedProvider> episodesWatchedProvider;

  EpisodeCard({
    @required this.episodes,
    @required this.episodeModel,
    @required this.episodesWatchedProvider,
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var orientation = MediaQuery.of(context).orientation;

    return Consumer(
      builder: (context, watch, child) {
        final prov = watch(episodesWatchedProvider);
        return CupertinoContextMenu(
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                elevation: 10,
                primary: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {
                prov.toggleWatched(episodeModel.number);
                Navigator.of(context).pop();
              },
              child: Text(
                prov.isWatched(episodeModel.number)
                    ? 'Remove from watched'
                    : 'Add to watched',
                style: GoogleFonts.montserrat(),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    12.0,
                  ),
                ),
                elevation: 0,
                primary: Theme.of(context).dialogBackgroundColor,
              ),
              onPressed: () {
                prov.setWatchedTill(episodeModel.number);
                Navigator.of(context).pop();
              },
              child: Text(
                'Set watched till here',
                style: GoogleFonts.montserrat(),
              ),
            ),
          ],
          child: Container(
            width: width * 0.5,
            height: orientation == Orientation.portrait
                ? height * 0.07
                : height * 0.175,
            child: Card(
              child: InkWell(
                onTap: () {
                  // FirebaseAdMob.instance.initialize(
                  //     appId: 'ca-app-pub-7187079853593886~3954729679');

                  AdmobService.showInterstitialAd();

                  context.read(recentlyWatchedProvider).addToLastWatched(
                        twistModel: twistModel,
                        kitsuModel: kitsuModel,
                        episodeModel: episodeModel,
                      );
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => WatchPage(
                      episodeModel: episodeModel,
                      episodes: episodes,
                      episodesWatchedProvider: episodesWatchedProvider,
                    ),
                  );
                  prov.setWatchedTill(episodeModel.number);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AutoSizeText(
                        'EP ' + episodeModel.number.toString(),
                        style: GoogleFonts.montserrat(
                          fontSize: 14.0,
                          color: Theme.of(context)
                              .textTheme
                              .headline6
                              .color
                              .withOpacity(
                                0.9,
                              ),
                        ),
                      ),
                      prov.isWatched(episodeModel.number)
                          ? Icon(
                              Icons.check,
                              color: Theme.of(context).accentColor,
                            )
                          : Icon(
                              Icons.navigate_next,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
