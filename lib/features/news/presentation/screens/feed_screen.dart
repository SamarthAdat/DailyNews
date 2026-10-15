import 'package:flutter/material.dart';

import 'package:daily_news/core/widgets/message_view.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily News')),
      body: const MessageView(
        icon: Icons.newspaper_outlined,
        title: 'Headlines are on the way',
      ),
    );
  }
}
