import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Reusable skeleton loading wrapper.
/// Wraps any widget — shows animated skeleton when [isLoading] is true.
///
/// Usage:
/// ```dart
/// SkeletonLoader(
///   isLoading: ref.watch(dataProvider).isLoading,
///   child: MyContentWidget(data: data),
/// )
/// ```
class SkeletonLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final bool enabled;

  const SkeletonLoader({
    super.key,
    required this.isLoading,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading && enabled,
      child: child,
    );
  }
}

/// Skeleton placeholder for a list of cards.
/// Use when you don't have the actual widget structure yet.
class SkeletonCardList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const SkeletonCardList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Card(
          child: SizedBox(
            height: itemHeight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 14,
                          width: double.infinity,
                          color: cs.surfaceContainerHighest,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 120,
                          color: cs.surfaceContainerHighest,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Skeleton for a single text block.
class SkeletonText extends StatelessWidget {
  final int lines;
  final double lineHeight;

  const SkeletonText({
    super.key,
    this.lines = 3,
    this.lineHeight = 14,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          lines,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              height: lineHeight,
              width: i == lines - 1
                  ? 140 // Last line shorter
                  : double.infinity,
              color: cs.surfaceContainerHighest,
            ),
          ),
        ),
      ),
    );
  }
}
