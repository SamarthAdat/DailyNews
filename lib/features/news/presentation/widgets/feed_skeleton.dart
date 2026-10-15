import 'package:flutter/material.dart';

import 'package:daily_news/core/widgets/skeleton.dart';

class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          const AspectRatio(
            aspectRatio: 16 / 9,
            child: SkeletonBox(radius: 14),
          ),
          const SizedBox(height: 14),
          const SkeletonBox(width: 120, height: 12),
          const SizedBox(height: 10),
          const SkeletonBox(height: 20),
          const SizedBox(height: 8),
          const SkeletonBox(width: 220, height: 20),
          const SizedBox(height: 24),
          for (var i = 0; i < 4; i++) const _TileSkeleton(),
        ],
      ),
    );
  }
}

class _TileSkeleton extends StatelessWidget {
  const _TileSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 100, height: 11),
                SizedBox(height: 10),
                SkeletonBox(),
                SizedBox(height: 6),
                SkeletonBox(width: 180),
              ],
            ),
          ),
          SizedBox(width: 14),
          SkeletonBox(width: 92, height: 92, radius: 10),
        ],
      ),
    );
  }
}
