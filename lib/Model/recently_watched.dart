import 'package:hive/hive.dart';

part 'recently_watched.g.dart';

@HiveType(typeId: 0)
class RecentlyWatched {
  @HiveField(0)
  int malId;
  @HiveField(1)
  String url;

  @HiveField(2)
  String title;

  @HiveField(3)
  String imageUrl;

  @HiveField(4)
  int enumber;

  @HiveField(5)
  int denumber;

  RecentlyWatched(
      {this.title,
      this.malId,
      this.imageUrl,
      this.url,
      this.enumber,
      this.denumber});
}
