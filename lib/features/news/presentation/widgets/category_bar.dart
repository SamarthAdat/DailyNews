import 'package:flutter/material.dart';

import 'package:daily_news/features/news/domain/entities/news_category.dart';

class CategoryBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoryBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final NewsCategory selected;
  final ValueChanged<NewsCategory> onSelected;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: preferredSize.height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
        itemCount: NewsCategory.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = NewsCategory.values[index];
          final isSelected = category == selected;

          return ChoiceChip(
            label: Text(category.label),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
            selectedColor: colors.primary,
            labelStyle: TextStyle(
              color: isSelected ? colors.onPrimary : colors.onSurface,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            side: isSelected
                ? BorderSide.none
                : BorderSide(color: colors.outlineVariant),
            visualDensity: VisualDensity.compact,
          );
        },
      ),
    );
  }
}
