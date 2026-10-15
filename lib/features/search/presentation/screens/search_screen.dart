import 'package:flutter/material.dart';

import 'package:daily_news/core/widgets/message_view.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: const MessageView(
        icon: Icons.manage_search_rounded,
        title: 'Search business news',
        message: 'Find articles by company, market or topic.',
      ),
    );
  }
}
