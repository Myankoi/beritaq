import '../../domain/entities/news_entities.dart';

class NewsModel extends NewsEntity {
  const NewsModel({
    required super.id,
    required super.title,
    required super.description,
    required super.content,
    required super.imageUrl,
    required super.sourceName,
    required super.publishedAt,
    required super.url,
  });

  factory NewsModel.fromApi(Map<String, dynamic> json) {
    return NewsModel(
      id: json['url'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      sourceName: json['source']?['name'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt']),
      url: json['url'] ?? '',
    );
  }

  /// TO JSON (Local / Favorite)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
      'sourceName': sourceName,
      'publishedAt': publishedAt.toIso8601String(),
      'url': url,
    };
  }

  /// FROM JSON (Favorite Local)
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      sourceName: json['sourceName'],
      publishedAt: DateTime.parse(json['publishedAt']),
      url: json['url'],
    );
  }
}
