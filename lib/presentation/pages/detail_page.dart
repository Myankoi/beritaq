import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/news_entities.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/remove_favorite.dart';
import '../../domain/usecases/check_favorite.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.news,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkFavorite,
  });

  final NewsEntity news;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckFavorite checkFavorite;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isFavorite = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final result = await widget.checkFavorite(widget.news.id);
    setState(() {
      isFavorite = result;
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    if (isFavorite) {
      await widget.removeFavorite(widget.news.id);
      _showSnackBar('Dihapus dari favorit');
    } else {
      await widget.addFavorite(widget.news);
      _showSnackBar('Ditambahkan ke favorit');
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final news = widget.news;
    final date = DateFormat('dd MMM yyyy').format(news.publishedAt);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Detail Berita'),
        actions: [
          if (!isLoading)
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: _toggleFavorite,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO IMAGE
            Hero(
              tag: news.id,
              child: news.imageUrl.isNotEmpty
                  ? Image.network(
                news.imageUrl,
                width: double.infinity,
                height: 240,
                fit: BoxFit.cover,
              )
                  : _imagePlaceholder(),
            ),


            // CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // META
                  Text(
                    '${news.sourceName} • $date',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // DESCRIPTION
                  if (news.description.isNotEmpty)
                    Text(
                      news.description,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // CONTENT
                  Text(
                    _cleanContent(news.content),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final uri = Uri.parse(news.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Read full article'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cleanContent(String content) {
    if (content.contains('[+')) {
      return content.split('[+').first.trim();
    }
    return content;
  }


  Widget _imagePlaceholder() {
    return Container(
      height: 240,
      color: Colors.grey.shade300,
      child: const Center(
        child: Icon(Icons.image, size: 48, color: Colors.grey),
      ),
    );
  }
}
