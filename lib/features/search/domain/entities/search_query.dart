import 'package:equatable/equatable.dart';

enum SearchSort {
  relevance('Most relevant', 'relevancy'),
  latest('Latest', 'publishedAt'),
  popularity('Popular', 'popularity');

  const SearchSort(this.label, this.apiValue);

  final String label;
  final String apiValue;
}

enum SearchPeriod {
  anyTime('Any time', null),
  week('Past week', Duration(days: 7)),
  month('Past month', Duration(days: 29));

  const SearchPeriod(this.label, this.window);

  final String label;
  final Duration? window;

  DateTime? startFrom(DateTime now) =>
      window == null ? null : now.subtract(window!);
}

class SearchQuery extends Equatable {
  const SearchQuery({
    this.text = '',
    this.sort = SearchSort.relevance,
    this.period = SearchPeriod.anyTime,
  });

  static const minLength = 2;

  final String text;
  final SearchSort sort;
  final SearchPeriod period;

  bool get isSearchable => text.trim().length >= minLength;

  SearchQuery copyWith({String? text, SearchSort? sort, SearchPeriod? period}) {
    return SearchQuery(
      text: text ?? this.text,
      sort: sort ?? this.sort,
      period: period ?? this.period,
    );
  }

  @override
  List<Object?> get props => [text.toLowerCase(), sort, period];
}
