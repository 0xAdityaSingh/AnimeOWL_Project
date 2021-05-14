import 'package:animetv/Model/info.dart';
import 'package:hive/hive.dart';

abstract class AnimeLocalDataSource {
  Future<void> saveAnime(Information movieTable);

  Future<List<Information>> getAnime();

  Future<void> deleteAnime(int movieId);

  Future<bool> checkIfAnimeFavorite(int movieId);
}

class AnimeLocalDataSourceImpl {
  @override
  Future<bool> checkIfMovieFavorite(int movieId) async {
    final movieBox = await Hive.openBox('animebox');
    return movieBox.containsKey(movieId);
  }

  @override
  Future<void> deleteMovie(int movieId) async {
    final movieBox = await Hive.openBox('animebox');
    await movieBox.delete(movieId);
  }

  @override
  Future<List<Information>> getMovies() async {
    final movieBox = await Hive.openBox('animebox');
    //2
    final movieIds = movieBox.keys;
    //3
    List<Information> movies = [];
    //4
    movieIds.forEach((movieId) {
      movies.add(movieBox.get(movieId));
    });
    //5
    return movies;
  }

  @override
  Future<void> saveMovie(Information movieTable) async {
    final movieBox = await Hive.openBox('animebox');
    await movieBox.put(movieTable.malId, movieTable);
  }
}
