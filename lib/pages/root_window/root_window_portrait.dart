import 'package:animetv/animations/Transitions.dart';
import 'package:animetv/pages/homepage/AppbarText.dart';
import 'package:animetv/pages/search_page/SearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RootWindowPortrait extends StatelessWidget {
  RootWindowPortrait({
    Key key,
    @required this.pages,
    @required this.indexProvider,
    @required this.pageController,
    @required this.pageViewKey,
  }) : super(key: key);

  final List<Widget> pages;
  final StateProvider indexProvider;
  final PageController pageController;
  final GlobalKey pageViewKey;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        var prov = watch(indexProvider);
        return Scaffold(
          appBar: AppBar(
            primary: true,
            backgroundColor: Colors.transparent,
            title: AppbarText(),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  Transitions.slideTransition(
                    context: context,
                    pageBuilder: () => SearchPage(),
                  );
                },
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: prov.state,
            onTap: (index) {
              pageController.jumpToPage(index);
              return prov.state = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
                tooltip: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                label: 'Favorites',
                tooltip: 'Favorites',
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.list_rounded),
              //   label: 'Discover',
              //   tooltip: 'Discover',
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
                tooltip: 'Settings',
              ),
            ],
          ),
          // body: pages.elementAt(prov.state),
          body: PageView(
            key: pageViewKey,
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: pages,
          ),
        );
      },
    );
  }
}
