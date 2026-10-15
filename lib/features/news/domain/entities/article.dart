import 'package:equatable/equatable.dart';

class Article extends Equatable {
  const Article({
    required this.url,
    required this.title,
    required this.sourceName,
    required this.publishedAt,
    this.description,
    this.content,
    this.author,
    this.imageUrl,
  });

  final String url;
  final String title;
  final String sourceName;
  final DateTime publishedAt;
  final String? description;
  final String? content;
  final String? author;
  final String? imageUrl;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
    url,
    title,
    sourceName,
    publishedAt,
    description,
    content,
    author,
    imageUrl,
  ];
}
