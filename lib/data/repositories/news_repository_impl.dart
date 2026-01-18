import '../../domain/entities/news_entities.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_remote_datasource.dart';
import '../datasources/favorite_local_datasource.dart';
import '../models/news.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDatasource remoteDatasource;
  final FavoriteLocalDatasource localDatasource;

  NewsRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<NewsEntity>> getTopHeadlines({
    String query = "",
    String country = "us",
    int page = 1,
  }) async {
    final List<NewsModel> models = await remoteDatasource.getTopHeadlines(
      country: country,
      query: query,
      page: page,
    );

    return models;
  }

  @override
  Future<List<NewsEntity>> getFavorites() async {
    final List<NewsModel> models = await localDatasource.getFavorites();
    return models;
  }

  @override
  Future<void> addToFavorite(NewsEntity news) async {

    final model = NewsModel(
      id: news.id,
      title: news.title,
      description: news.description,
      content: news.content,
      imageUrl: news.imageUrl,
      sourceName: news.sourceName,
      publishedAt: news.publishedAt,
      url: news.url,
    );

    await localDatasource.addFavorite(model);
  }

  @override
  Future<void> removeFromFavorite(String newsId) async {
    await localDatasource.removeFavorite(newsId);
  }

  @override
  Future<bool> isFavorite(String newsId) async {
    return localDatasource.isFavorite(newsId);
  }
}
