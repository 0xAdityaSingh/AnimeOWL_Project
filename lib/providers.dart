import 'package:animetv/providers/FavouriteAnimeProvider.dart';
import 'package:animetv/providers/RecentlyWatchedProvider.dart';
import 'package:animetv/providers/TVInfoProvider.dart';
import 'package:animetv/providers/ToWatchProvider.dart';
import 'package:animetv/providers/settings/AccentColorProvider.dart';
import 'package:animetv/providers/settings/DoubleTapDuration.dart';
import 'package:animetv/providers/settings/PlaybackSpeedProvider.dart';
import 'package:animetv/providers/settings/ZoomFactorProvider.dart';
import 'package:animetv/services/SharedPreferencesManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesProvider = Provider<SharedPreferencesManager>((ref) {
  return SharedPreferencesManager();
});

final tvInfoProvider = Provider<TVInfoProvider>((ref) {
  return TVInfoProvider();
});

final accentProvider = ChangeNotifierProvider<AccentColorProvider>((ref) {
  return AccentColorProvider(ref.read(sharedPreferencesProvider));
});

final zoomFactorProvider = ChangeNotifierProvider<ZoomFactorProvider>((ref) {
  return ZoomFactorProvider(ref.read(sharedPreferencesProvider));
});

final doubleTapDurationProvider =
    ChangeNotifierProvider<DoubleTapDurationProvider>((ref) {
  return DoubleTapDurationProvider(ref.read(sharedPreferencesProvider));
});

final playbackSpeeedProvider =
    ChangeNotifierProvider<PlaybackSpeedProvider>((ref) {
  return PlaybackSpeedProvider(ref.read(sharedPreferencesProvider));
});

final recentlyWatchedProvider =
    ChangeNotifierProvider<RecentlyWatchedProvider>((ref) {
  return RecentlyWatchedProvider();
});

final toWatchProvider = ChangeNotifierProvider<ToWatchProvider>((ref) {
  return ToWatchProvider();
});

final favouriteAnimeProvider = ChangeNotifierProvider<FavouriteAnimeProvider>(
    (ref) => FavouriteAnimeProvider());
