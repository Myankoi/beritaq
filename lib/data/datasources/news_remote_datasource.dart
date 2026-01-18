import '../../core/network/api_client.dart';
import '../../core/error/exception.dart';
import '../models/news.dart';

abstract class NewsRemoteDatasource {
  Future<List<NewsModel>> getTopHeadlines({
    String country,
    String query,
    int page,
  });
}

class NewsRemoteDatasourceImpl implements NewsRemoteDatasource {
  final ApiClient apiClient;

  NewsRemoteDatasourceImpl(this.apiClient);

  @override
  Future<List<NewsModel>> getTopHeadlines({
    String country = "us",
    String query = "",
    int page = 1,
  }) async {
    try {
      final json = await apiClient.get(
        '/top-headlines',
        query: {
          'country': country,
          'q': query,
          'page': page.toString(),
        },
      );

      final List articles = json['articles'];

      return articles
          .map((e) => NewsModel.fromApi(e))
          .toList();
    } on AppException {
      rethrow;
    } catch (_) {
      throw ServerException('Failed to fetch news');
    }
  }
}
