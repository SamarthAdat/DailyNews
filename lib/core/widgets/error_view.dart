import 'package:flutter/material.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/core/widgets/message_view.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final failure = mapToFailure(error);

    return MessageView(
      icon: failure is NetworkFailure
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
      title: failure is NetworkFailure ? 'You are offline' : 'Could not load',
      message: failure.message,
      actionLabel: onRetry == null ? null : 'Try again',
      onAction: onRetry,
    );
  }
}
