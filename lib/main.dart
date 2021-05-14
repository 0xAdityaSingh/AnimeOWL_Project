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

  // WidgetsFlutterBinding.ensureInitialized();
  // final appDocumentDir = await getApplicationDocumentsDirectory();
  // Hive.registerAdapter<RecentlyWatched>(RecentlyWatchedAdapter());
  // // Hive.registerAdapter(RecentlyWatchedAdapter());
  // Hive.init(appDocumentDir.path);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        darkTheme: getDarkTheme(Colors.amber[800]),
        debugShowCheckedModeBanner: false,
        title: 'AnimeOWL',
        home: HomePage());
  }
}
