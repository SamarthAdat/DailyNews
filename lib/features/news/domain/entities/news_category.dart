enum NewsCategory {
  business('Business'),
  technology('Technology'),
  general('Top stories'),
  science('Science'),
  health('Health'),
  entertainment('Entertainment'),
  sports('Sports');

  const NewsCategory(this.label);

  final String label;

  String get apiValue => name;
}
