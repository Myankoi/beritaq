import '../entities/news_entities.dart';
import '../repositories/news_repository.dart';

class AddFavorite {
  final NewsRepository repository;

  AddFavorite(this.repository);

  Future<void> call(NewsEntity news) {
    return repository.addToFavorite(news);
  }
}
