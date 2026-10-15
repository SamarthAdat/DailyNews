import 'package:flutter/material.dart';

import 'package:daily_news/features/search/domain/entities/search_query.dart';

class SearchFiltersBar extends StatelessWidget {
  const SearchFiltersBar({
    super.key,
    required this.query,
    required this.onSortChanged,
    required this.onPeriodChanged,
  });

  final SearchQuery query;
  final ValueChanged<SearchSort> onSortChanged;
  final ValueChanged<SearchPeriod> onPeriodChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _FilterMenu<SearchSort>(
            icon: Icons.swap_vert_rounded,
            value: query.sort,
            options: SearchSort.values,
            labelOf: (sort) => sort.label,
            onSelected: onSortChanged,
          ),
          const SizedBox(width: 8),
          _FilterMenu<SearchPeriod>(
            icon: Icons.schedule_rounded,
            value: query.period,
            options: SearchPeriod.values,
            labelOf: (period) => period.label,
            onSelected: onPeriodChanged,
          ),
        ],
      ),
    );
  }
}

class _FilterMenu<T> extends StatelessWidget {
  const _FilterMenu({
    required this.icon,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onSelected,
  });

  final IconData icon;
  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return MenuAnchor(
      menuChildren: [
        for (final option in options)
          MenuItemButton(
            onPressed: () => onSelected(option),
            leadingIcon: Icon(
              Icons.check_rounded,
              size: 18,
              color: option == value ? colors.primary : Colors.transparent,
            ),
            child: Text(labelOf(option)),
          ),
      ],
      builder: (context, controller, _) => ActionChip(
        avatar: Icon(icon, size: 18),
        visualDensity: VisualDensity.compact,
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(labelOf(value)),
            const Icon(Icons.arrow_drop_down_rounded, size: 20),
          ],
        ),
      ),
    );
  }
}
