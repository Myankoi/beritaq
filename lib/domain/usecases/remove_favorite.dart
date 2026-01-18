import '../repositories/news_repository.dart';

class RemoveFavorite {
  final NewsRepository repository;

  RemoveFavorite(this.repository);

  Future<void> call(String newsId) {
    return repository.removeFromFavorite(newsId);
  }
}
