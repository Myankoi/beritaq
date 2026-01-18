
class NewsEntity {
  final String id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;
  final String sourceName;
  final DateTime publishedAt;
  final String url;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
    required this.url,
  });
}
