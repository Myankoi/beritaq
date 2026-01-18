import 'package:flutter/material.dart';

import '../../domain/entities/news_entities.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/check_favorite.dart';
import '../widgets/news_card.dart';
import 'detail_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    super.key,
    required this.getFavorites,
    required this.removeFavorite,
    required this.addFavorite,
    required this.checkFavorite,
  });

  final GetFavorites getFavorites;
  final RemoveFavorite removeFavorite;
  final AddFavorite addFavorite;
  final CheckFavorite checkFavorite;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<NewsEntity> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => isLoading = true);

    final result = await widget.getFavorites();

    setState(() {
      favorites = result;
      isLoading = false;
    });
  }

  Future<void> _remove(String id) async {
    await widget.removeFavorite(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? const Center(
        child: Text(
          'Belum ada berita favorit',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final news = favorites[index];

          return Dismissible(
            key: ValueKey(news.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            onDismissed: (_) => _remove(news.id),
            child: NewsCard(
              news: news,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      news: news,
                      addFavorite: widget.addFavorite,
                      removeFavorite: widget.removeFavorite,
                      checkFavorite: widget.checkFavorite,
                    ),
                  ),
                ).then((_) => _loadFavorites());
              },
            ),
          );
        },
      ),
    );
  }
}
