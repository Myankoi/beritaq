import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/news.dart';

abstract class FavoriteLocalDatasource {
  Future<List<NewsModel>> getFavorites();
  Future<void> addFavorite(NewsModel news);
  Future<void> removeFavorite(String newsId);
  Future<bool> isFavorite(String newsId);
}

class FavoriteLocalDatasourceImpl implements FavoriteLocalDatasource {
  static const String _key = 'favorite_news';

  final SharedPreferences prefs;

  FavoriteLocalDatasourceImpl(this.prefs);

  @override
  Future<List<NewsModel>> getFavorites() async {
    final List<String> jsonList = prefs.getStringList(_key) ?? [];

    return jsonList
        .map((e) => NewsModel.fromJson(jsonDecode(e)))
        .toList();
  }

  @override
  Future<void> addFavorite(NewsModel news) async {
    final favorites = await getFavorites();

    final exists = favorites.any((item) => item.id == news.id);
    if (exists) return;

    favorites.add(news);

    final jsonList =
    favorites.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(_key, jsonList);
  }

  @override
  Future<void> removeFavorite(String newsId) async {
    final favorites = await getFavorites();

    favorites.removeWhere((item) => item.id == newsId);

    final jsonList =
    favorites.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(_key, jsonList);
  }

  @override
  Future<bool> isFavorite(String newsId) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == newsId);
  }
}
