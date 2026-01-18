import '../entities/news_entities.dart';

/// REPOSITORY (Domain Layer)
/// Kontrak / aturan data apa yang bisa diambil atau disimpan
abstract class NewsRepository {
  /// Ambil berita dari API
  Future<List<NewsEntity>> getTopHeadlines({
    String query = "",
    String country = "us",
    int page = 1,
  });

  /// Ambil semua berita favorit (LOCAL)
  Future<List<NewsEntity>> getFavorites();

  /// Tambah berita ke favorit
  Future<void> addToFavorite(NewsEntity news);

  /// Hapus berita dari favorit
  Future<void> removeFromFavorite(String newsId);

  /// Cek apakah berita sudah favorit
  Future<bool> isFavorite(String newsId);
}
