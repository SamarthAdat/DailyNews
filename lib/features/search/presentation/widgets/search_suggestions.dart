import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/search/presentation/providers/recent_searches_controller.dart';

class SearchSuggestions extends ConsumerWidget {
  const SearchSuggestions({super.key, required this.onSelected});

  static const _topics = [
    'Interest rates',
    'Earnings',
    'Inflation',
    'Oil prices',
    'AI chips',
    'Startups',
    'Mergers',
    'Crypto',
  ];

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recent = ref.watch(recentSearchesProvider);

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        if (recent.isNotEmpty) ...[
          _SectionHeader(
            title: 'Recent searches',
            action: TextButton(
              onPressed: () =>
                  ref.read(recentSearchesProvider.notifier).clear(),
              child: const Text('Clear'),
            ),
          ),
          for (final text in recent)
            ListTile(
              dense: true,
              leading: const Icon(Icons.history_rounded),
              title: Text(text),
              trailing: const Icon(Icons.north_west_rounded, size: 18),
              onTap: () => onSelected(text),
            ),
          const SizedBox(height: 12),
        ],
        const _SectionHeader(title: 'Trending in business'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final topic in _topics)
                ActionChip(
                  label: Text(topic),
                  onPressed: () => onSelected(topic),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action});

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}
