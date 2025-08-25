import 'package:flutter/material.dart';
import 'package:game_oclock/models/models.dart' show LayoutTier;

// https://m3.material.io/foundations/layout/applying-layout/window-size-classes
const compactBreakpointWidth = 600;
const mediumBreakpointWidth = 840;
const expandedBreakpointWidth = 1200;
const largeBreakpointWidth = 1600;

LayoutTier layoutTierFromSize(final Size size) {
  final LayoutTier tier;
  final width = size.width;
  if (width < compactBreakpointWidth) {
    tier = LayoutTier.compact;
  } else if (compactBreakpointWidth <= width && width < mediumBreakpointWidth) {
    tier = LayoutTier.medium;
  } else if (mediumBreakpointWidth <= width &&
      width < expandedBreakpointWidth) {
    tier = LayoutTier.expanded;
  } else if (expandedBreakpointWidth <= width && width < largeBreakpointWidth) {
    tier = LayoutTier.large;
  } else {
    tier = LayoutTier.extraLarge;
  }
  return tier;
}
