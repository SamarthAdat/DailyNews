import 'package:daily_news/features/news/domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.url,
    required super.title,
    required super.sourceName,
    required super.publishedAt,
    super.description,
    super.content,
    super.author,
    super.imageUrl,
  });

  factory ArticleModel.fromEntity(Article article) {
    if (article is ArticleModel) return article;
    return ArticleModel(
      url: article.url,
      title: article.title,
      sourceName: article.sourceName,
      publishedAt: article.publishedAt,
      description: article.description,
      content: article.content,
      author: article.author,
      imageUrl: article.imageUrl,
    );
  }

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      url: map['url'] as String,
      title: map['title'] as String,
      sourceName: map['sourceName'] as String,
      publishedAt: DateTime.parse(map['publishedAt'] as String),
      description: map['description'] as String?,
      content: map['content'] as String?,
      author: map['author'] as String?,
      imageUrl: map['imageUrl'] as String?,
    );
  }

  static const _removedMarker = '[Removed]';
  static final _truncationSuffix = RegExp(r'\s*\[\+\d+ chars\]$');

  Map<String, dynamic> toMap() => {
    'url': url,
    'title': title,
    'sourceName': sourceName,
    'publishedAt': publishedAt.toIso8601String(),
    'description': description,
    'content': content,
    'author': author,
    'imageUrl': imageUrl,
  };

  static ArticleModel? tryParse(Map<String, dynamic> json) {
    final url = _clean(json['url']);
    final rawTitle = _clean(json['title']);
    final publishedAt = DateTime.tryParse(json['publishedAt'] as String? ?? '');

    if (url == null || rawTitle == null || publishedAt == null) return null;
    if (rawTitle == _removedMarker) return null;

    final source = json['source'];
    final sourceName =
        (source is Map ? _clean(source['name']) : null) ?? 'Unknown source';

    return ArticleModel(
      url: url,
      title: _stripSourceSuffix(rawTitle, sourceName),
      sourceName: sourceName,
      publishedAt: publishedAt,
      description: _clean(json['description']),
      content: _clean(json['content'])?.replaceFirst(_truncationSuffix, ''),
      author: _clean(json['author']),
      imageUrl: _clean(json['urlToImage']),
    );
  }

  static String? _clean(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String _stripSourceSuffix(String title, String sourceName) {
    final separator = title.lastIndexOf(' - ');
    if (separator <= 0) return title;

    final suffix = _normalize(title.substring(separator + 3));
    final source = _normalize(sourceName);
    if (suffix.length < 2 || source.isEmpty) return title;

    final isSourceName =
        suffix.contains(source) ||
        source.contains(suffix) ||
        suffix == _initials(sourceName);

    return isSourceName ? title.substring(0, separator).trim() : title;
  }

  static String _normalize(String value) =>
      value.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');

  static String _initials(String value) => value
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty && word != 'the')
      .map((word) => word[0])
      .join();
}
