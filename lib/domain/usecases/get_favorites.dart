import '../entities/news_entities.dart';
import '../repositories/news_repository.dart';

class GetFavorites {
  final NewsRepository repository;

  GetFavorites(this.repository);

  Future<List<NewsEntity>> call() {
    return repository.getFavorites();
  }
}
