import 'package:flutter/material.dart';

import 'package:daily_news/core/widgets/skeleton.dart';

class FeedSkeleton extends StatelessWidget {
  const FeedSkeleton({super.key, this.showFeatured = true});

  final bool showFeatured;

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          if (showFeatured) ...const [
            AspectRatio(aspectRatio: 16 / 9, child: SkeletonBox(radius: 14)),
            SizedBox(height: 14),
            SkeletonBox(width: 120, height: 12),
            SizedBox(height: 10),
            SkeletonBox(height: 20),
            SizedBox(height: 8),
            SkeletonBox(width: 220, height: 20),
            SizedBox(height: 24),
          ],
          for (var i = 0; i < (showFeatured ? 4 : 7); i++)
            const _TileSkeleton(),
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
