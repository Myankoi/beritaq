import '../entities/news_entities.dart';
import '../repositories/news_repository.dart';

class GetNews {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<List<NewsEntity>> call({
    String query = '',
    int page = 1,
  }) {
    return repository.getTopHeadlines(
      query: query,
      page: page,
    );
  }
}
