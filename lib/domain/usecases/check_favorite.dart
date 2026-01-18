import '../repositories/news_repository.dart';

class CheckFavorite {
  final NewsRepository repository;

  CheckFavorite(this.repository);

  Future<bool> call(String newsId) {
    return repository.isFavorite(newsId);
  }
}
