import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:animetv/Model/recently_watched.dart';
import 'package:animetv/homepage.dart';
import 'package:animetv/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(RecentlyWatchedAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: getDarkTheme(Colors.amber[800]),

        // darkTheme: getDarkTheme(Colors.amber[800]),
        debugShowCheckedModeBanner: false,
        title: 'AnimeOWL',
        home: AnimatedSplashScreen(
          backgroundColor: Colors.black,
          splash: 'assets/main.png',
          nextScreen: HomePage(),
          splashTransition: SplashTransition.fadeTransition,
          // pageTransitionType: PageTransitionType.scale,
        ));
  }
}

// flutter clean && flutter build appbundle --release
// flutter clean
// flutter pub get
// flutter build appbundle --release --no-tree-shake-icons
