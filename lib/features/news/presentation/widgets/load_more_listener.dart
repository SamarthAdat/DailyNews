import 'package:flutter/widgets.dart';

class LoadMoreListener extends StatelessWidget {
  const LoadMoreListener({
    super.key,
    required this.canLoadMore,
    required this.onLoadMore,
    required this.child,
    this.threshold = 600,
  });

  final bool canLoadMore;
  final VoidCallback onLoadMore;
  final double threshold;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final metrics = notification.metrics;
        if (canLoadMore &&
            metrics.axis == Axis.vertical &&
            metrics.extentAfter < threshold) {
          onLoadMore();
        }
        return false;
      },
      child: child,
    );
  }
}
