import 'package:flutter/material.dart';

import '../../core/local/user_pref.dart';
import '../../domain/entities/news_entities.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/check_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/get_news.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../widgets/news_card.dart';
import '../widgets/news_card_skeleton.dart';
import 'detail_page.dart';
import 'favorite_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.getNews,
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkFavorite,
  });

  final GetNews getNews;
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckFavorite checkFavorite;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;

  String username = '';
  List<NewsEntity> newsList = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  String query = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadUser();
    _fetchNews();
  }

  Future<void> _loadUser() async {
    final name = await UserPref.getUsername();
    setState(() => username = name ?? '');
  }

  Future<void> _searchNews() async {
    FocusScope.of(context).unfocus();

    query = _searchController.text.trim();

    _scrollController.jumpTo(0);

    await _fetchNews(loadMore: false);
  }


  Future<void> _fetchNews({bool loadMore = false}) async {
    if (isLoading) return;

    if (!loadMore) {
      page = 1;
      hasMore = true;
      newsList.clear();
    }

    setState(() => isLoading = true);

    final result = await widget.getNews(
      query: query,
      page: page,
    );

    setState(() {
      if (result.isEmpty) {
        hasMore = false;
      } else {
        newsList.addAll(result);
        page++;
      }
      isLoading = false;
    });
  }


  Future<void> _refresh() async {
    query = _searchController.text;
    await _fetchNews();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !isLoading &&
        hasMore) {
      _fetchNews(loadMore: true);
    }
  }

  Future<void> _logout() async {
    await UserPref.clearUsername();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('BeritaQ'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritePage(
                    getFavorites: widget.getFavorites,
                    removeFavorite: widget.removeFavorite,
                    addFavorite: widget.addFavorite,
                    checkFavorite: widget.checkFavorite,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
              pinned: false,
              floating: true,
              snap: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $username 👋',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Baca berita teknologi terbaru hari ini',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 🔍 SEARCH BAR
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (_) => _searchNews(),
                  decoration: InputDecoration(
                    hintText: 'Cari berita...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _searchNews,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),

                ),
              ),
            ),

            // 📰 NEWS LIST
            if (newsList.isEmpty && isLoading)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => const NewsCardSkeleton(),
                  childCount: 5,
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index == newsList.length) {
                      return hasMore
                          ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                          : const SizedBox.shrink();
                    }

                    final news = newsList[index];

                    return NewsCard(
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
                        );
                      },
                    );
                  },
                  childCount: newsList.length + (hasMore ? 1 : 0),
                ),
              ),

          ],
        ),
      ),

    );
  }
}
