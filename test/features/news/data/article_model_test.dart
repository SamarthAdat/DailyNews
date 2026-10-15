import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/features/news/data/models/article_model.dart';
import 'package:daily_news/features/news/data/models/articles_response_model.dart';

Map<String, dynamic> _articleJson({
  String? url = 'https://example.com/a',
  String? title = 'Markets rally on rate cut hopes - Reuters',
  String source = 'Reuters',
  String? publishedAt = '2026-10-14T08:00:01Z',
  String? content,
}) {
  return {
    'source': {'id': null, 'name': source},
    'author': 'Jane Doe',
    'title': title,
    'description': '  Stocks climbed on Tuesday.  ',
    'url': url,
    'urlToImage': '',
    'publishedAt': publishedAt,
    'content': content,
  };
}

void main() {
  group('ArticleModel.tryParse', () {
    test('parses a valid article and cleans its fields', () {
      final article = ArticleModel.tryParse(_articleJson())!;

      expect(article.title, 'Markets rally on rate cut hopes');
      expect(article.sourceName, 'Reuters');
      expect(article.description, 'Stocks climbed on Tuesday.');
      expect(article.imageUrl, isNull);
      expect(article.publishedAt, DateTime.utc(2026, 10, 14, 8, 0, 1));
    });

    test('strips the source suffix when it is a domain variant', () {
      final article = ArticleModel.tryParse(
        _articleJson(
          title: 'ASML boosts outlook - Bloomberg.com',
          source: 'Bloomberg',
        ),
      )!;

      expect(article.title, 'ASML boosts outlook');
    });

    test('strips abbreviated and spaced source names', () {
      final wsj = ArticleModel.tryParse(
        _articleJson(
          title: 'Albertsons wants \$8 billion from Kroger - WSJ',
          source: 'The Wall Street Journal',
        ),
      )!;
      final utilityDive = ArticleModel.tryParse(
        _articleJson(
          title: 'FERC rejects PJM plan - Utility Dive',
          source: 'Utilitydive.com',
        ),
      )!;

      final yahoo = ArticleModel.tryParse(
        _articleJson(
          title: 'Futures edge higher ahead of CPI data - Yahoo Finance',
          source: 'Yahoo Entertainment',
        ),
      )!;

      expect(wsj.title, 'Albertsons wants \$8 billion from Kroger');
      expect(utilityDive.title, 'FERC rejects PJM plan');
      expect(yahoo.title, 'Futures edge higher ahead of CPI data');
    });

    test('keeps dashes that are part of the headline', () {
      final article = ArticleModel.tryParse(
        _articleJson(
          title: 'Oil jumps - what it means for you - CNBC',
          source: 'CNBC',
        ),
      )!;

      expect(article.title, 'Oil jumps - what it means for you');
    });

    test('removes the truncation marker from content', () {
      final article = ArticleModel.tryParse(
        _articleJson(content: 'The Fed held rates steady… [+4167 chars]'),
      )!;

      expect(article.content, 'The Fed held rates steady…');
    });

    test('rejects removed or incomplete articles', () {
      expect(ArticleModel.tryParse(_articleJson(title: '[Removed]')), isNull);
      expect(ArticleModel.tryParse(_articleJson(url: null)), isNull);
      expect(ArticleModel.tryParse(_articleJson(publishedAt: 'n/a')), isNull);
    });
  });

  test('toMap and fromMap round-trip an article', () {
    final article = ArticleModel.tryParse(
      _articleJson(content: 'Body text [+120 chars]'),
    )!;

    expect(ArticleModel.fromMap(article.toMap()), article);
  });

  test('ArticlesResponseModel drops duplicates and invalid entries', () {
    final response = ArticlesResponseModel.fromJson({
      'status': 'ok',
      'totalResults': 42,
      'articles': [
        _articleJson(),
        _articleJson(),
        _articleJson(url: 'https://example.com/b'),
        _articleJson(title: '[Removed]', url: 'https://example.com/c'),
      ],
    });

    expect(response.totalResults, 42);
    expect(response.articles.map((a) => a.url), [
      'https://example.com/a',
      'https://example.com/b',
    ]);
  });
}
