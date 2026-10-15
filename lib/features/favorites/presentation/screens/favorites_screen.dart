import 'package:flutter/material.dart';

import 'package:daily_news/core/widgets/message_view.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: const MessageView(
        icon: Icons.bookmark_border_rounded,
        title: 'No saved articles yet',
        message: 'Articles you save will be available here, even offline.',
      ),
    );
  }
}
