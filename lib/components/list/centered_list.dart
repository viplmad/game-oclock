import 'dart:math' as math;

import 'package:flutter/rendering.dart';

class SliverGridDelegateWithFixedCrossAxisCountAndCenteredLast
    extends SliverGridDelegateWithFixedCrossAxisCount {
  const SliverGridDelegateWithFixedCrossAxisCountAndCenteredLast({
    required this.itemCount,
    required super.crossAxisCount,
    super.mainAxisSpacing = 0.0,
    super.crossAxisSpacing = 0.0,
    super.childAspectRatio = 1.0,
    super.mainAxisExtent,
  }) : assert(itemCount >= 0),
       assert(crossAxisCount > 0),
       assert(mainAxisSpacing >= 0),
       assert(crossAxisSpacing >= 0),
       assert(childAspectRatio > 0),
       assert(mainAxisExtent == null || mainAxisExtent >= 0);

  /// The total number of items in the layout.
  final int itemCount;

  bool _debugAssertIsValid() {
    assert(itemCount >= 0);
    assert(crossAxisCount > 0);
    assert(mainAxisSpacing >= 0.0);
    assert(crossAxisSpacing >= 0.0);
    assert(childAspectRatio > 0.0);
    return true;
  }

  @override
  SliverGridLayout getLayout(final SliverConstraints constraints) {
    assert(_debugAssertIsValid());
    final double usableCrossAxisExtent = math.max(
      0.0,
      constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1),
    );
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent =
        mainAxisExtent ?? childCrossAxisExtent / childAspectRatio;

    return SliverGridCustomGeometryTileLayout(
      itemCount: itemCount,
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(
    final SliverGridDelegateWithFixedCrossAxisCountAndCenteredLast oldDelegate,
  ) {
    return oldDelegate.itemCount != itemCount ||
        super.shouldRelayout(oldDelegate);
  }
}

class SliverGridCustomGeometryTileLayout extends SliverGridRegularTileLayout {
  const SliverGridCustomGeometryTileLayout({
    required this.itemCount,
    required super.crossAxisCount,
    required super.mainAxisStride,
    required super.crossAxisStride,
    required super.childMainAxisExtent,
    required super.childCrossAxisExtent,
    required super.reverseCrossAxis,
  }) : assert(itemCount >= 0),
       assert(crossAxisCount > 0),
       assert(mainAxisStride >= 0),
       assert(crossAxisStride >= 0),
       assert(childMainAxisExtent >= 0),
       assert(childCrossAxisExtent >= 0);

  /// The total number of items in the layout.
  final int itemCount;

  @override
  SliverGridGeometry getGeometryForChildIndex(final int index) {
    double crossAxisOffset;
    final double initialCrossAxisStart =
        (index % crossAxisCount) * crossAxisStride;
    final lastCount = itemCount % crossAxisCount;
    if (lastCount > 0 &&
        index <= itemCount - 1 &&
        index >= itemCount - lastCount) {
      final int unusedCount = crossAxisCount - lastCount;
      final double additionalCrossAxisStart =
          (unusedCount * crossAxisStride) / 2;

      final double crossAxisStart =
          additionalCrossAxisStart + initialCrossAxisStart;
      crossAxisOffset = _getOffsetFromStartInCrossAxis(crossAxisStart);
    } else {
      final double crossAxisStart = initialCrossAxisStart;
      crossAxisOffset = _getOffsetFromStartInCrossAxis(crossAxisStart);
    }

    return SliverGridGeometry(
      scrollOffset: (index ~/ crossAxisCount) * mainAxisStride,
      crossAxisOffset: crossAxisOffset,
      mainAxisExtent: childMainAxisExtent,
      crossAxisExtent: childCrossAxisExtent,
    );
  }

  double _getOffsetFromStartInCrossAxis(final double crossAxisStart) {
    if (reverseCrossAxis) {
      return crossAxisCount * crossAxisStride -
          crossAxisStart -
          childCrossAxisExtent -
          (crossAxisStride - childCrossAxisExtent);
    }
    return crossAxisStart;
  }
}
