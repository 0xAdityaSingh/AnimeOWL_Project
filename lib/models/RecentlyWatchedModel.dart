// Package imports:
import 'package:animetv/models/EpisodeModel.dart';
import 'package:animetv/models/kitsu/KitsuModel.dart';
import 'package:animetv/models/TwistModel.dart';
import 'package:hive/hive.dart';

part 'RecentlyWatchedModel.g.dart';

@HiveType(typeId: 3)
class RecentlyWatchedModel extends HiveObject {
  @HiveField(0)
  final TwistModel twistModel;
  @HiveField(1)
  final KitsuModel kitsuModel;
  @HiveField(2)
  final EpisodeModel episodeModel;

  RecentlyWatchedModel(this.twistModel, this.kitsuModel, this.episodeModel);
}
